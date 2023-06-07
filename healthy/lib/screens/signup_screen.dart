import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/InsertData.dart';
import 'package:healthy/reusable_widgets/reusable_widget.dart';
import 'package:healthy/screens/home_screen.dart';
import 'package:healthy/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  TextEditingController _genderTextController = TextEditingController();

  int? _selectedWeight;
  int? _selectedHeight;

  List<int> _generateWeights() {
    List<int> heights = [];
    for (int i = 30; i <= 150; i++) {
      heights.add(i);
    }
    return heights;
  }

  List<int> _generateHeights() {
    List<int> heights = [];
    for (int i = 140; i <= 220; i++) {
      heights.add(i);
    }
    return heights;
  }

  int? _selectedYear;
  List<int> _generateYears() {
    final years = List<int>.generate(
      DateTime.now().year - 2000,
      (int index) => DateTime.now().year - index,
    );
    return years;
  }

  Future<void> _resetWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('waterIntake');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back arrow
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 41, 149, 189),
                Color.fromARGB(255, 41, 149, 189)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/lg.png',
                  width: 600, // Adjust the width as needed
                  height: 120, // Adjust the height as needed
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  decoration: InputDecoration(
                      // Empty InputDecoration object
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                  decoration: InputDecoration(
                      // Empty InputDecoration object
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    await _resetWaterIntake();

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear(); // Clear all SharedPreferences data
                    prefs.setBool(
                        'isNewUser', true); // Mark the user as a new user

                    print("Created New Account");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InsertData()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Email already used! , try another one'),
                          backgroundColor: Color.fromARGB(255, 250, 17, 1),
                        ),
                      );
                    }
                  }
                })
              ],
            ),
          ))),
    );
  }
}
