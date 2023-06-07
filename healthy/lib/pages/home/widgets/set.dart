import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/profile.dart';

class CircularProgressPage extends StatefulWidget {
  @override
  _CircularProgressPageState createState() => _CircularProgressPageState();
}

class _CircularProgressPageState extends State<CircularProgressPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 5), () {
      // Navigate to another page after 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => setup()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
