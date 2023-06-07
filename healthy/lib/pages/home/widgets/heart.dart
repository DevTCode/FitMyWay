import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
class HeartRateMonitorPage extends StatefulWidget {
  @override
  _HeartRateMonitorPageState createState() => _HeartRateMonitorPageState();
}

class _HeartRateMonitorPageState extends State<HeartRateMonitorPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isMonitoring = false;
  int _targetHeartRate = 80;
  bool _isHeartRateReached = false;
  Timer? _timer;
  List<int> _redPixelValues = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _startMonitoring() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      _captureFrame();
    });

    setState(() {
      _isMonitoring = true;
    });
  }

  void _stopMonitoring() {
    _timer?.cancel();

    setState(() {
      _isMonitoring = false;
    });
  }

   Future<void> _captureFrame() async {
    if (!_isMonitoring || _isHeartRateReached) return;

    final image = await _cameraController!.takePicture();
    final bytes = await image.readAsBytes();

    final decodedImage = img.decodeImage(bytes);
    final resizedImage = img.copyResize(decodedImage!, width: 120);

    final redPixels = _extractRedPixels(resizedImage);

    setState(() {
      _redPixelValues = redPixels;
    });

    final currentHeartRate = _calculateHeartRate();
    if (currentHeartRate == _targetHeartRate) {
      _isHeartRateReached = true;
      _stopMonitoring();
    }
  }

  List<int> _extractRedPixels(img.Image image) {
    final redPixels = <int>[];

    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        final pixel = image.getPixel(x, y);
        final redValue = img.getRed(pixel);

        redPixels.add(redValue);
      }
    }

    return redPixels;
  }

  double _calculateHeartRate() {
    // Implement your heart rate calculation logic here using the red pixel values
    // You can use the _redPixelValues list to access the pixel data

    // Example calculation using dummy logic
    return math.Random().nextInt(100) + 60;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Heart Rate Monitor'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate Monitor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraPreview(_cameraController!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _isMonitoring ? _stopMonitoring : _startMonitoring,
                      child: Text(_isMonitoring ? 'Stop Monitoring' : 'Start Monitoring'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Heart Rate: ${_calculateHeartRate().toStringAsFixed(0)} bpm',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
