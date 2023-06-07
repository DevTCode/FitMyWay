import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/home.dart';
import 'package:healthy/screens/signin_screen.dart';
import 'package:healthy/screens/signup_screen.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  late Query dbRef;
  late DatabaseReference reference;
  late String lastKey = '';
  late String lastChildName = 'informationPersonnelle';

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref(getCurrentUserID()).child('Personne');

    reference = FirebaseDatabase.instance.ref().child('Personne');
  }

  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }

  Widget listItem({required Map Student}) {
    int yearOfBirth = Student['yearOfBirth'];
    int currentYear = DateTime.now().year;
    int age = currentYear - yearOfBirth;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 6,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text('Name: ${Student['name']}'),
          SizedBox(
            height: 20,
          ),
          Text('Height: ${Student['height']} cm'),
          SizedBox(
            height: 20,
          ),
          Text('Weight: ${Student['weight']} Kg'),
          Text('Distance Unit: Km'),
          Text('Age: $age'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: const Text(
            'Profile',
            style: TextStyle(
                color: Color.fromARGB(255, 41, 149, 189),
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 70, right: 40, left: 40),
        color: Color.fromARGB(255, 255, 255, 255),
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            String key = snapshot.key ?? '';
            if (key == lastKey) {
              return Container(); // Return an empty container if the data has already been fetched
            }
            lastKey = key;
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: const Text("back"),
                    style: TextButton.styleFrom(
                      primary: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),*/
                  SizedBox(height: 20,),
                  Center(
                    child: Container(
                      width: 100,
                      height: 150,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://img.myloview.com/stickers/default-avatar-profile-icon-vector-unknown-social-media-user-photo-700-209987478.jpg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.person,color: Color.fromARGB(255, 0, 255, 8),), // Icône à gauche du texte
                          SizedBox(
                              width: 10), // Espacement entre l'icône et le texte
                          Text(
                            '     Name: ${snapshot.child('name').value.toString()}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.height,color: Colors.black,), // Icône à gauche du texte
                          SizedBox(width: 10),
                          Text(
                            '     Height: ${snapshot.child('height').value.toString()} cm             ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons
                              .directions_walk,color: Color.fromARGB(255, 41, 149, 189),), // Icon to the left of the text
                          SizedBox(
                              width: 10), // Spacing between the icon and text
                          Text(
                            '     Distance Unit: Km',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.cake,color: Color.fromARGB(255, 252, 0, 0),), // Icône à gauche du texte
                          SizedBox(width: 10),
                          Text(
                            '     Year of birth: ${snapshot.child('YearOfBirth').value.toString()}   ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        backgroundColor: Color.fromARGB(255, 41, 149, 189),
        onPressed: () {
          // Sign out the user
          FirebaseAuth.instance.signOut().then((value) {
            print("Signed Out");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        },
      ),
    );
  }
}
