import 'package:flutter/material.dart';

class history extends StatelessWidget {
  int steps;
  final double miles;
  final double duration;
  final double calories;

  history({
    Key? key,
    required this.steps,
    required this.miles,
    required this.duration,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Values'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Steps: $steps'),
            Text('Miles: $miles'),
            Text('Duration: $duration'),
            Text('Calories: $calories'),
          ],
        ),
      ),
    );
  }
}
