import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:healthy/screens/signin_screen.dart';

class DailyInfoPage extends StatefulWidget {
  const DailyInfoPage({Key? key}) : super(key: key);

  @override
  State<DailyInfoPage> createState() => _DailyInfoPageState();
}

class _DailyInfoPageState extends State<DailyInfoPage> {
  late Query dbRef;
  late DatabaseReference reference;
  late String lastKey = '';
  // State variable to control the visibility of the progress indicator

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance
        .ref(getCurrentUserID())
      
        .child('ActivitePhysique');
    reference = FirebaseDatabase.instance.ref();
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
            'History',
            style: TextStyle(
              color: Color.fromARGB(255, 41, 149, 189),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            child: FirebaseAnimatedList(
              query: dbRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                String date = snapshot.key ?? '';
                Map<String, dynamic> data =
                    (snapshot.value as Map<dynamic, dynamic>)
                        .cast<String, dynamic>();
                return listItem(date: date, data: data);
              },
            ),
          );
        },
      ),
    );
  }
}

Widget listItem({required String date, required Map<String, dynamic> data}) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    height: 190,
    color: Color.fromARGB(255, 0, 0, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date: $date',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 41, 149, 189)),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Aligns the icon and text vertically
          children: [
            Icon(Icons.local_fire_department,
                color: Color.fromARGB(255, 255, 98, 0)),
            SizedBox(width: 5), // Adds some spacing between the icon and text
            Text(
              'Calories left : ${data['calories']} ' + 'Kcal',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.timer, color: Color.fromARGB(255, 237, 227, 134)),
            SizedBox(
              width: 5,
            ),
            Text(
              'Duration : ${data['duration']}' + ' min',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.place_rounded,
                color: Color.fromARGB(255, 103, 244, 166)),
            SizedBox(
              width: 5,
            ),
            Text(
              'Miles : ${data['miles']}' + ' Km',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.directions_walk_sharp,
                color: Color.fromARGB(255, 41, 149, 189)),
            SizedBox(
              width: 5,
            ),
            Text(
              'Steps : ${data['steps']}' + ' steps',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
