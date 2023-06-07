import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/set.dart';
import 'package:healthy/pages/home/widgets/steplength.dart';

class birth extends StatefulWidget {
  const birth({Key? key}) : super(key: key);

  @override
  State<birth> createState() => _InsertDataState();
}

class _InsertDataState extends State<birth> {
  int? _selectedYear;
  List<int> _generateYears() {
    final years = List<int>.generate(
      DateTime.now().year - 1800,
      (int index) => DateTime.now().year - index,
    );
    return years;
  }

  late DatabaseReference dbRef;
  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }

  void saveBirth(int _selectedYear) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';

    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        
        .child(userID)
        .child('AnneeNaissance');

    dbRef.set({'YearOfBirth': _selectedYear}).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => stepLength()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving Year of birth: $error'),
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
                  Icons.cake,color: Color.fromARGB(255, 0, 179, 255),
                  size: 150,
                ),
                Text(
                  'Necessary Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('for',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('estimating heart rate',style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),Text('and distance',style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Year Of Birth",
                    hintText: "Heart rate calculation needs it",
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
                      Icons.calendar_month_outlined,
                      color: Color.fromARGB(255, 9, 255, 1),
                    ),
                  ),
                  value: _selectedYear,
                  items: _generateYears()
                      .map((height) => DropdownMenuItem<int>(
                            value: height,
                            child: Text(height.toString()),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedYear = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                 
                ElevatedButton(
                  onPressed: () {
                    if (_selectedYear != null) {
                      saveBirth(_selectedYear!);
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
