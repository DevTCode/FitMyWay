import 'dart:isolate';
import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int steps;

  HomeScreen(this.steps, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Isolate? _isolate;
  bool _isRunning = false;
  int _currentSteps = 0;

  @override
  void initState() {
    super.initState();
    startIsolate();
  }

  @override
  void dispose() {
    stopIsolate();
    super.dispose();
  }

  void startIsolate() async {
    _isolate = await Isolate.spawn(runBackgroundTask, widget.steps);
    _isRunning = true;
  }

  void stopIsolate() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
      _isRunning = false;
    }
  }

  static void runBackgroundTask(dynamic steps) {
    int currentSteps = 0;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      currentSteps++;
      print('You have made $currentSteps steps today');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRunning ? 'Background task is running' : 'Background task stopped',
            ),
            SizedBox(height: 20),
            Text(
              'You have made $_currentSteps steps today',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
