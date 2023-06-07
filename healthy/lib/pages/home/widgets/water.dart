



import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthy/pages/home/widgets/custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cupSizeKey = 'cupSize';
const _waterIntakeKey = 'waterIntake';

class WaterReminderScreen extends StatefulWidget {
  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  List<bool> _cupsFilled = List.generate(7, (_) => false);
  double _cupSize = 200.0;
  double _waterIntake = 0.0;
  bool _isWaterAnimating = false;
  double _waterIconSize = 120;
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isAnimationCompleted = false;
  int goal = 2000;

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
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadData();
    _startTimer();
    dbRef = FirebaseDatabase.instance
        .ref()
        
        .child(getCurrentUserID())
        .child('VersEau').child('goal');
  }

  Future<void> _resetWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_waterIntakeKey);
    setState(() {
      _waterIntake = 0.0;
      _cupsFilled = List.generate(7, (_) => false);
    });
  }

 
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cupSize = prefs.getDouble(_cupSizeKey) ?? 200.0;
      _waterIntake = prefs.getDouble(_waterIntakeKey) ?? 0.0;
      if (_waterIntake >= 2000) {
        _isAnimationCompleted = true;
      }
    });
  }

  Future<void> _saveCupSize(double cupSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_cupSizeKey, cupSize);
    setState(() {
      _cupSize = cupSize;
    });
  }
 Future<void> _addWater(double amount) async {
    setState(() {
      _isWaterAnimating = true;
      _waterIconSize = 150;
      // Increase the size of the water icon during animation
    });

    // Delay for animation duration
    await Future.delayed(Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final newWaterIntake = _waterIntake + amount;
    await prefs.setDouble(_waterIntakeKey, newWaterIntake);

    // Update goal value on Firebase
    dbRef.set(goal); // Set the goal value on Firebase

    setState(() {
      _waterIntake = newWaterIntake;
      if (_waterIntake >= goal) {
        _isAnimationCompleted = true;
      }
      if (_waterIntake == goal) {
        _cupsFilled = List.generate(7, (_) => true);
      }
      _isWaterAnimating = false;
      _waterIconSize = 120; // Reset the size of the water icon after animation
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 30), (_) {
      _showNotification();
    });
  }

  Future<void> _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: false,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        1, "FitMyWay", "It's time to drink water", notificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        color: Colors.white,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/photos-gratuite/vue-laterale-eau-plate-dans-verre-planche-decouper-bois-fond-bleu_140725-130399.jpg?w=900&t=st=1684607339~exp=1684607939~hmac=8cc5967de87155672f7a08bc094bee1a68a825b6f4dabe223344a2e7d3bda7d2'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    width: _waterIconSize,
                    height: _waterIconSize,
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.blueAccent,
                      size: 120,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Water Intake',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${_waterIntake.toInt()} ml',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Cup Size: ${_cupSize.toInt()} ml',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Choose Cup Size: ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      DropdownButton<double>(
                        value: _cupSize,
                        onChanged: (newCupSize) {
                          if (newCupSize != null) {
                            _saveCupSize(newCupSize);
                          }
                        },
                        items: <double>[150.0, 200.0, 250.0, 300.0]
                            .map<DropdownMenuItem<double>>((double value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text(
                              '${value.toInt()} ml',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 127, 175, 231)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addWater(_cupSize);
                      _startTimer();
                    },
                    child: Text('Add $_cupSize ml of Water'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Challenges:',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  SizedBox(
                    height: 20,
                  ),
                 

Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _cupsFilled[0] = !_cupsFilled[0];
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: _cupsFilled[0]
                                    ? Colors.green
                                    : Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.local_drink_sharp,
                                  size: 35.0,
                                  color: _cupsFilled[0]
                                      ? Colors.white
                                      : Color.fromARGB(255, 21, 149, 254),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: _resetWaterIntake,
                    child: Text('Begin From Zero'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


