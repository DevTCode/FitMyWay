import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/screens/signin_screen.dart';
import 'package:share/share.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthy/pages/home/widgets/set.dart';

class goal extends StatefulWidget {
  const goal({Key? key}) : super(key: key);

  @override
  State<goal> createState() => _GoalState();
}

class _GoalState extends State<goal> {
  int? _selectedGoal;
  String? _selectedSensitivity;
  bool _showInstructions1 = false;
  bool _showInstructions2 = false;
  bool _showInstructions3 = false;
  bool _showInstructions4 = false;
  bool _showInstructions5 = false;
  bool _showInstructions6 = false;
 int? _selectedstep;

  List<int> _generateStep() {
    List<int> heights = [];
    for (int i = 60; i <= 80; i++) {
      heights.add(i);
    }
    return heights;
  }
  
  List<int> generateGoals() {
    List<int> goals = [];
    for (int i = 1000; i <= 40000; i += 500) {
      goals.add(i);
    }

    return goals;
  }

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('goal');
  }

  void shareApp() {
    Share.share('Check out this awesome Applicatio '+'FitMyWay' +', try it now!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'More',
            style: TextStyle(color: Color.fromARGB(255, 41, 149, 189)),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
               
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions :',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions1 = !_showInstructions1;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.start,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'How to use?',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions1
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'While moving, the application will count your steps. Click on stop to stop counting. And you should press on reset in the beginig of each day to reset steps already counted in the past day and start new day',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions2 = !_showInstructions2;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Shaking phone',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions2
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'If you check your phone, it might be counted as a step because of the built-in sensor.',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions3 = !_showInstructions3;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.place_rounded,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Placement',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions3
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We suggest you put it in your hand, pocket, or bag. In general, place it in any place close to your body.',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions4 = !_showInstructions4;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.battery_3_bar_outlined,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Battery saving',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions4
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We read your steps from the built-in sensor. No GPS tracking. You can pause the app to save battery when you are not running.',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions5 = !_showInstructions5;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.private_connectivity,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Privacy',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions5
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '100% private',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showInstructions6 = !_showInstructions6;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.run_circle_rounded,
                      color: Color.fromARGB(255, 41, 149, 189),
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Step Goal',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      _showInstructions6
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _showInstructions6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We help you set your goal according to your achieved steps to keep you motivated. While pressing on reset the goal will be incremented by 500 , which means that every day the goal will be incremented by 500 until attending 40000 which is the maximum goal to attend',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  shareApp();
                },
                child: Icon(Icons.share),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 16),
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  // Set the desired color here
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: Text('Version 1.0.0')),
            ],
          ),
        ),
      ),
    );
  }
}
