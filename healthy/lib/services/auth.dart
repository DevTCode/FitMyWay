import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/bat.dart';
import 'package:healthy/pages/home/widgets/chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:healthy/pages/home/widgets/circular.dart';


import 'package:healthy/pages/home/widgets/popular.dart';
import 'package:healthy/pages/home/widgets/search.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class heartCount extends StatefulWidget {
  const heartCount({Key? key}) : super(key: key);

  @override
  _heartCountState createState() => _heartCountState();
}

class StepCount {
  final String day;
  final int count;

  StepCount(this.day, this.count);
}

// ignore: camel_case_types
class _heartCountState extends State<heartCount> {
  double x = 0.0;
  int heartRate = 0;
  double y = 0.0;
  double z = 0.0;

  double addValue = 0.01;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AccelerometerEvent>(
        stream: SensorsPlatform.instance.accelerometerEvents,
        builder: (context, snapShort) {
          if (snapShort.hasData) {
            x = snapShort.data!.x;
            y = snapShort.data!.y;
            z = snapShort.data!.z;
            distance = getValue(x, y, z);

            
            heartRate = calculateHeartRate(steps);
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ])),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            // this is the farthest button

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ],
                        ),
                      ),
                      // dashboard card
                      
                    
                   
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int counter = 0;

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);

    counter++;
    if (counter > 14) {
      steps++;
      counter = 0;
    }

    return modDistance;
  }

  void setPreviousValue(double distance) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = _pref.getDouble("preValue") ?? 0.0;
    });
  }

  // void calculate data
}

int calculateHeartRate(int steps) {
  int averageStepRate = 120;

// Estimation du nombre de battements de cœur par minute
int heartRate = (steps / averageStepRate * 60).toInt();
return heartRate;
}
