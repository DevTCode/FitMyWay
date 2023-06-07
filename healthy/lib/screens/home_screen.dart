import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthy/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () {
            // Delete all data from the database
            deleteAllDataFromFirebase();

            // Sign out the user
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
        ),
      ),
    );
  }

 void deleteAllDataFromFirebase() {
  DatabaseReference reference =
      FirebaseDatabase.instance.reference();

  // Remove data from the 'Students' node
  reference.child('Students').remove().then((_) {
    print('Data deleted from "Students" node');
  }).catchError((error) {
    print('Failed to delete data from "Students" node: $error');
  });

  // Remove data from the 'Orders' node
  reference.child('Orders').remove().then((_) {
    print('Data deleted from "Orders" node');
  }).catchError((error) {
    print('Failed to delete data from "Orders" node: $error');
  });

  // Add more lines to delete data from other nodes if needed
  // reference.child('OtherNode').remove()...
}

}
