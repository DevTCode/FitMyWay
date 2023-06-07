import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:healthy/screens/signin_screen.dart';

class heartHistory extends StatefulWidget {
  const heartHistory({Key? key}) : super(key: key);

  @override
  State<heartHistory> createState() => _DailyInfoPageState();
}

class _DailyInfoPageState extends State<heartHistory> {
  late Query dbRef;
  late DatabaseReference reference;
  late String lastKey = '';
  double heartRate = 0.0;
  // State variable to control the visibility of the progress indicator
  void fetchGoalFromFirebase() {
  
    dbRef = FirebaseDatabase.instance
        .reference()
      
        .child( getCurrentUserID())
         .child('BattementsCoeur').child('heartRate');
    
    dbRef.onValue.listen((event) {
      print('Heart rate updated: ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        setState(() {
          heartRate = event.snapshot.value as double;
        });
      }
    }, onError: (error) {
      print('Failed to fetch heart rate from Firebase: $error');
    });
  }
  @override
  void initState() {
    super.initState();
   dbRef = FirebaseDatabase.instance
   .ref().child(getCurrentUserID()).child('BattementsCoeur').child('heartRate');
   fetchGoalFromFirebase();
  }

  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }

  // ...
  @override
  Widget build(BuildContext context) {
    // Continue with the regular page content
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: const Text(
            'Last Heart Rate Estimation',
            style: TextStyle(
              color: Color.fromARGB(255, 41, 149, 189),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
child: Column(
  children: [
    Text('Last value is : $heartRate'),
  ],
),
      )
    );
  }
}

