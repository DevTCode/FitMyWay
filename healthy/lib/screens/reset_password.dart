import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthy/reusable_widgets/reusable_widget.dart';
import 'package:healthy/screens/home_screen.dart';
import 'package:healthy/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back arrow
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
           Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 41, 149, 189),
          Color.fromARGB(255, 41, 149, 189)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
                  height: 40,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController,decoration: InputDecoration(
    // Empty InputDecoration object
  ),),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Reset Password", () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) => Navigator.of(context).pop());
                })
              ],
            ),
          ))),
    );
  }
}
