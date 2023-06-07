import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double heartRate = 0.0; // Variable to store the heart rate value

  // Simulate heart rate data with a constant value of 1 BPM
  void startHeartRateSimulation() {
    // Start a timer to update the heart rate every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        heartRate = 1.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startHeartRateSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Heart Rate Monitor'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Heart Rate: ${heartRate.toStringAsFixed(1)} BPM',
                style: TextStyle(fontSize: 24),
              ),
              // Other widgets or calculations using the heart rate value
            ],
          ),
        ),
      ),
    );
  }
}
