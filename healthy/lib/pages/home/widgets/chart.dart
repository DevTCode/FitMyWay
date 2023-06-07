import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class chartWidget extends StatefulWidget {
  int steps;

  chartWidget(this.steps);

  @override
  State<chartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<chartWidget> {
  late DatabaseReference dbRef;
  late String userID;
  int goal = 500;
   late DatabaseReference reference;
  @override
  void initState() {
    super.initState();
    fetchGoalFromFirebase();
  }

 void fetchGoalFromFirebase() {
    userID = getCurrentUserID();
    dbRef = FirebaseDatabase.instance
        .reference()
       
        .child(userID)
        .child('But').child('goal');
    
    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          goal = event.snapshot.value as int;
        });
      }
    }, onError: (error) {
      print('Failed to fetch goal from Firebase: $error');
    });
  }


  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    return userID;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 20,
                child: LinearProgressIndicator(
                  value: widget.steps / goal,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Goal: $goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 20,
                child: LinearProgressIndicator(
                  value: 1,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 0, 255, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
