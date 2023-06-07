import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthy/pages/home/widgets/dashboard.dart';
import 'package:healthy/pages/home/widgets/header.dart';
import 'package:healthy/pages/home/widgets/search.dart';
import 'package:healthy/pages/home/widgets/spalshscreen.dart';
import 'package:healthy/screens/signin_screen.dart';
import 'package:healthy/screens/signup_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
   
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/vecteurs-libre/homme-courir-vague-fluide-bleue_1017-9202.jpg?w=740&t=st=1684350804~exp=1684351404~hmac=08804b81aaa5aa0244e9d32cd20a55b91a567fc8742de66eba9e61c125239cc4'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Image.asset(
                        'assets/images/lg.png',
                        width: 600, // Adjust the width as needed
                        height: 120, // Adjust the height as needed
                      ),
                      SizedBox(height: 300),
                      const Text(
                        "Transform",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 38,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const Text(
                        "your life",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 32,
                            color: Color.fromARGB(255, 41, 149, 189)),
                      ),
                      const Text(
                        "for better",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 38,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Change your life and try this application that helps you count your steps, how much calories you burn by doing an effort, and much more.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 41, 149, 189)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  SignInScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 6, 6, 6),
                            borderRadius: BorderRadius.circular(24),
                            shape: BoxShape.rectangle,
                          ),
                          width: 330,
                          height: 45,
                          child: Row(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30)),
                              Text(
                                "Discover Now!",
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(
                                        255, 255, 255, 255)),
                              ),
                              SizedBox(width: 20),
                              Icon(
                                Icons.arrow_forward,
                                size: 25,
                                color: Color.fromARGB(
                                    255, 41, 149, 189),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      
      ),
    );
  }
}
