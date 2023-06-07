import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/birth.dart';
import 'package:healthy/pages/home/widgets/steplength.dart';

class weight extends StatefulWidget {
  const weight({Key? key}) : super(key: key);

  @override
  State<weight> createState() => _InsertDataState();
}

class _InsertDataState extends State<weight> {
  int? _selectedWeight;

  List<int> _generateWeights() {
    List<int> heights = [];
    for (int i = 30; i <= 150; i++) {
      heights.add(i);
    }
    return heights;
  }

  late DatabaseReference dbRef;
  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }

  void saveWeight(int selectedWeight) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';

    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        
        .child(userID)
        .child('Poids');

    dbRef.set({'weight': selectedWeight}).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => stepLength()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving weight: $error'),
          backgroundColor: Color.fromARGB(255, 69, 203, 227),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        title: Text('Fill with informations'),
        backgroundColor: Color.fromARGB(255, 41, 149, 189),
        shadowColor: Color.fromARGB(255, 41, 149, 189),
      ),*/
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.0, left: 60, right: 60),
            child: Column(
              children: [
                Icon(
                  Icons.monitor_weight_rounded,
                  size: 150,
                ),
                Text(
                  'Necessary Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('for',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('calculating calories',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "weight",
                    hintText: "Select your weight (in kg)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(),
                    ),
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(color: Colors.grey),
                    // Set the color of the border
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    prefixIcon: Icon(
                      Icons.monitor_weight,
                      color: Colors.blue,
                    ),
                  ),
                  value: _selectedWeight,
                  items: _generateWeights()
                      .map((height) => DropdownMenuItem<int>(
                            value: height,
                            child: Text(height.toString()),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedWeight = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedWeight != null) {
                      saveWeight(_selectedWeight!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select your weight.'),
                          backgroundColor: Color.fromARGB(255, 69, 203, 227),
                        ),
                      );
                    }
                  },
                  child: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 7,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set the background color of the button
                    primary: Color.fromARGB(255, 41, 149, 189),
                    // Set the color of the button when it's being pressed
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
