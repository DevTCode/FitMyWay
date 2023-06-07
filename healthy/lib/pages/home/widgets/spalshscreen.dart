import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/header.dart';
import 'dart:async';

import 'package:healthy/screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation1;
  late Animation<double> _textAnimation2;
  late Animation<double> _textAnimation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2), // Adjust the duration as needed
      vsync: this,
    );

    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.4), // Adjust the animation interval for the image
      ),
    );

    _textAnimation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.6), // Adjust the animation interval for the first text
      ),
    );

    _textAnimation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.8), // Adjust the animation interval for the second text
      ),
    );

    _textAnimation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 0.10), // Adjust the animation interval for the third text
      ),
    );

    _animationController.forward();
   Timer(Duration(seconds: 7), () {
      // Naviguez vers l'écran suivant après 5 secondes (ou toute autre durée souhaitée)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HeaderSection()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _imageAnimation,
              child: Image.asset(
                'assets/images/lg.png',
                width: 500, // Adjust the width as needed
                height: 120, // Adjust the height as needed
              ),
            ),
            SizedBox(height: 150),
            FadeTransition(
              opacity: _textAnimation1,
              child: Text('Daily Step Tracker',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            SizedBox(height: 10,),
            FadeTransition(
              opacity: _textAnimation2,
              child: Text('&',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color.fromARGB(255, 0, 255, 8))),
            ),
              SizedBox(height: 10,),
            FadeTransition(
              opacity: _textAnimation3,
              child: Text('Heart Rate Monitor',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ),
            SizedBox(height: 210),
            // Add the loading widget (e.g., CircularProgressIndicator)
            Text('Loading ...',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 71, 181, 201)),)
          ],
        ),
      ),
    );
  }
}

