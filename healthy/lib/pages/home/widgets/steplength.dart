import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/set.dart';

class stepLength extends StatefulWidget {
  const stepLength({Key? key}) : super(key: key);

  @override
  State<stepLength> createState() => _InsertDataState();
}

class _InsertDataState extends State<stepLength> {
  double? _selectedstep;
  List<double> _generateStep() {
    List<double> steps = [0.6, 0.7, 0.8];
    return steps;
  }

  late DatabaseReference dbRef;
  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }

  void saveStepLength(double _selectedstep) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';

    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        
        .child(userID)
        .child('TaillePas');

    dbRef.set({'stepLength': _selectedstep}).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CircularProgressPage()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving step length: $error'),
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
                  Icons.directions_walk,
                  size: 150,
                ),
                Text(
                  'Necessary Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('for',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('calculating duration',style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),Text('and distance',style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<double>(
                  decoration: InputDecoration(
                    labelText: "Step Length",
                    hintText: "Distance & speed calculation needs it",
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
                      Icons.label_important,
                      color: Color.fromARGB(255, 9, 255, 1),
                    ),
                  ),
                  value: _selectedstep,
                  items: _generateStep()
                      .map((height) => DropdownMenuItem<double>(
                            value: height,
                            child: Text(height.toString()),
                          ))
                      .toList(),
                  onChanged: (double? value) {
                    setState(() {
                      _selectedstep = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                 Text('if you do not know the value '),
                 SizedBox(height: 8,),
                 Text('you should enter 0.7'),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedstep != null) {
                      saveStepLength(_selectedstep!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select your step length.'),
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
