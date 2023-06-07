import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/FetchData.dart';
import 'package:healthy/pages/home/widgets/profile.dart';
import 'package:healthy/pages/home/widgets/set.dart';
import 'package:healthy/pages/home/widgets/weight.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController _genderTextController = TextEditingController();
  late String lastChildName = 'informationPersonnelle';

  int? _selectedWeight;
  int? _selectedHeight;
  double? _selectedstep;


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

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance
        .ref(getCurrentUserID())
        
        .child('Personne');
        
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
                  Icons.boy_rounded,
                  size: 150,
                ),
                Text(
                  'Personnal Informations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('&',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Body Measurements',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 254, 254),
                      ),
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Enter Your Name',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 255, 255, 255), // Set the hint text color here
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 41, 149, 189),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                            8.0), // Add your desired padding value
                        child: Text(
                          'Gender',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _genderTextController.text = 'Female';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: _genderTextController.text == 'Female'
                              ? Color.fromARGB(255, 41, 149, 189)
                              : Color.fromARGB(255, 0, 0, 0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Color.fromARGB(255, 41, 149, 189)),
                          ),
                        ),
                        child: const Text(
                          'Female',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _genderTextController.text = 'Male';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: _genderTextController.text == 'Male'
                              ? Color.fromARGB(255, 41, 149, 189)
                              : Color.fromARGB(255, 0, 0, 0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Color.fromARGB(255, 41, 149, 189)),
                          ),
                        ),
                        child: const Text(
                          'Male',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Height",
                    hintText: "Select your height (in cm)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(),
                    ),
                    // Set the color of the label and hint text
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(color: Colors.grey),
                    // Set the color of the border
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 41, 149, 189)),
                    ),
                    prefixIcon: Icon(
                      Icons.height,
                      color: Colors.black,
                    ),
                  ),
                  value: _selectedHeight,
                  items: _generateHeights()
                      .map((height) => DropdownMenuItem<int>(
                            value: height,
                            child: Text(height.toString()),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedHeight = value!;
                    });
                  },
                ),
                const SizedBox(
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
                /*
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
                ),*/
               
              
                SizedBox(
                  height: 10,
                ),
                /*DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(),
                    ),
                    prefixIcon: Icon(
                      Icons.cake,
                      color: Color.fromARGB(255, 245, 5, 85),
                    ),
                  ),
                  value: _selectedYear,
                  hint: const Text(
                    "Select Year of Birth",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  items: _generateYears()
                      .map((year) => DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),*/
                SizedBox(
                  height: 40,
                ),
                
                ElevatedButton(
                  onPressed: () {
                    if (_selectedHeight != null && _selectedYear != null) {
                      dbRef.push().set({
                        'name': userNameController.text,
                        'gender': _genderTextController.text,
                        'height': _selectedHeight,
                        'YearOfBirth': _selectedYear,
                        'id':getCurrentUserID(),
                      
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => weight()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all the details.'),
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
