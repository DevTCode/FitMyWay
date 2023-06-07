import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/heartHistory.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wakelock/wakelock.dart';
import 'chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class heartPage extends StatefulWidget {
  @override
  _HeartPageState createState() => _HeartPageState();
}

class _HeartPageState extends State<heartPage> {
  bool _toggled = false;
  bool _processing = false;
  double heartRate = 0.0;
  List<SensorValue> _data = [];
  CameraController? _controller;
  double _alpha = 0.3;
  double _bpm = 0;
  FlashMode _flashMode = FlashMode.off;
  late DatabaseReference dbRef;
  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }
void fetchGoalFromFirebase() {
  dbRef = FirebaseDatabase.instance
      .reference()
      .child(getCurrentUserID())
      .child('BattementsCoeur')
      .child('heartRate');

  dbRef.onValue.listen((event) {
    print('Heart rate updated: ${event.snapshot.value}');
    if (event.snapshot.value != null) {
      setState(() {
        heartRate = double.parse(event.snapshot.value as String);
      });
    }
  }, onError: (error) {
    print('Failed to fetch heart rate from Firebase: $error');
  });
}

  void saveStepLength(double _bpm) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';

    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(userID).child('BattementsCoeur');

    dbRef
        .set({'heartRate': _bpm.toStringAsFixed(0)})
        .then((_) {})
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving heart rate : $error'),
              backgroundColor: Color.fromARGB(255, 69, 203, 227),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
    fetchGoalFromFirebase();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _initializeController() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.first, ResolutionPreset.low);
        await _controller!.initialize();

        _controller!.startImageStream((CameraImage image) {
          if (!_processing) {
            setState(() {
              _processing = true;
            });
            _scanImage(image);
          }
        });
      }
    } catch (exception) {
      print(exception);
    }
  }

  void _disposeController() {
    // Stop the flash when disposing the camera controller
    _toggleFlash();
    _controller?.dispose();
  }

  void _toggle() {
    _initializeController().then((_) {
      Wakelock.enable();
      setState(() {
        _toggled = true;
        _processing = false;
      });
      _updateBPM();
      _toggleFlash();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    setState(() {
      _toggled = false;
      _processing = false;
    });
  }

  void _updateBPM() async {
    List<SensorValue> values;
    double avg;
    int n;
    double m;
    double threshold;
    double bpm;
    int counter;
    int previous;
    int delayCounter = 0; // Counter to track the delay

    while (_toggled && delayCounter < 60) {
      values = List.from(_data);
      avg = 0;
      n = values.length;
      m = 0;

      values.forEach((SensorValue value) {
        avg += value.value / n;
        if (value.value > m) m = value.value;
      });

      threshold = (m + avg) / 2;
      bpm = 0;
      counter = 0;
      previous = 0;

      for (int i = 1; i < n; i++) {
        if (values[i - 1].value < threshold && values[i].value > threshold) {
          if (previous != 0) {
            counter++;
            bpm += 60000 / (values[i].time.millisecondsSinceEpoch - previous);
          }
          previous = values[i].time.millisecondsSinceEpoch;
        }
      }

      if (counter > 0) {
        bpm = bpm / counter;
        setState(() {
          _bpm = (1 - _alpha) * _bpm + _alpha * bpm;
        });
      }

      await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));

      // Increment delay counter
      delayCounter++;
    }

    if (delayCounter >= 1) {
      // If the delay of 20 seconds is reached, stop counting and display the exact value
      setState(() {
        _toggled = false;
        _processing = false;
        _toggleFlash();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Heart Rate'),
              content: Text(
                'Average heart rate stabilized: ${_bpm.toStringAsFixed(0)} bpm',
                style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  onPressed: () {
                    saveStepLength(_bpm);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  void _scanImage(CameraImage image) {
    final avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;

    if (_data.length >= 50) {
      _data.removeAt(0);
    }

    setState(() {
      _data.add(SensorValue(DateTime.now(), avg));
    });

    Future.delayed(Duration(milliseconds: 1000 ~/ 30)).then((_) {
      setState(() {
        _processing = false;
      });
    });
  }

  void _toggleFlash() {
    if (_flashMode == FlashMode.off) {
      setState(() {
        _flashMode = FlashMode.torch;
      });
    } else {
      setState(() {
        _flashMode = FlashMode.off;
      });
    }

    _controller?.setFlashMode(_flashMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('Heart Rate Monitor'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          _flashMode == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
                        ),
                        color: Colors.black,
                        iconSize: 10,
                        onPressed: () {
                          _toggleFlash();
                        },
                      ),
                    ),
                  ),
                  Text(
                   'Last Heart Rate estimation value: ${heartRate.toStringAsFixed(0)} bpm   ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 280,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: PageView(
                      children: [
                        SizedBox(
                          height: 500,
                          width: 500,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 2,
                                right: 2,
                                bottom: 2,
                                top: 2,
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                    angleRange: 360.0,
                                    startAngle: 0,
                                    customColors: CustomSliderColors(
                                      progressBarColor:
                                          Color.fromARGB(255, 0, 0, 0),
                                      trackColor:
                                          Color.fromARGB(255, 255, 0, 0),
                                    ),
                                    customWidths: CustomSliderWidths(
                                      progressBarWidth: 8,
                                      trackWidth: 9,
                                    ),
                                  ),
                                  innerWidget: (p) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(_toggled
                                              ? Icons.favorite
                                              : Icons.favorite_border),
                                          color: Colors.red,
                                          iconSize: 48,
                                          onPressed: () {
                                            if (_toggled) {
                                              _untoggle();
                                            } else {
                                              _toggle();
                                            }
                                          },
                                        ),
                                        Text(
                                          (_bpm > 30 && _bpm < 150
                                              ? _bpm.round().toString()
                                              : "--"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 41, 149, 189),
                                          ),
                                        ),
                                        Text(
                                          "bpm",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  max: 100,
                                  min: 0,
                                  initialValue: 64,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _toggled
                          ? Color.fromARGB(255, 42, 0, 128)
                          : Color.fromARGB(255, 129, 128, 134),
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 255, 0, 0),
                    size: 28,
                  ),
                ],
              ),
            ),
            Text(
              'Press on the heart below and put your finger on the rear camera to start measuring',
              style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Chart extends StatelessWidget {
  final List<SensorValue> data;

  Chart(this.data);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      [
        charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (SensorValue values, _) => values.time,
          measureFn: (SensorValue values, _) => values.value,
          data: data,
        )
      ],
      animate: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: charts.NoneRenderSpec(),
      ),
      domainAxis: new charts.DateTimeAxisSpec(
        renderSpec: new charts.NoneRenderSpec(),
      ),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}
