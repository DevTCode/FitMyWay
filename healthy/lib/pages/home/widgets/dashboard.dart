import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthy/pages/home/widgets/bat.dart';
import 'package:healthy/pages/home/widgets/calories.dart';
import 'package:healthy/pages/home/widgets/chart.dart';
import 'package:healthy/pages/home/widgets/circular.dart';
import 'package:healthy/pages/home/widgets/heart.dart';
import 'package:healthy/pages/home/widgets/heartMonitor.dart';
import 'package:healthy/pages/home/widgets/popular.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*class StepCount {
  final String day;
  final int count;

  StepCount(this.day, this.count);
}
*/
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //declaration of notification object

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<dashboard> {
  bool isCounting = true;
  double stepLength = 0.0;
  double x = 0.0;
  int heartRate = 0;
  double y = 0.0;
  double z = 0.0;
  int counter = 0;
  Timer? _timer;
  double miles = 0.0;
  double duration = 0.0;
  double calories = 0.0;
  double addValue = 0.01;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;
  late DatabaseReference wRef;
  late DatabaseReference goalRef;
  late DatabaseReference reference;
  late String lastKey = '';
  int goal = 0;
  late DatabaseReference BRef;
  int YearOfBirth = 0;
  late DateTime currentDate;
  int weight = 0;
  late DatabaseReference dbRef;
  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? '';
    print(userID);
    return userID;
  }
  /*Future<void> initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      goal = prefs.getInt('goal') ?? 500;
      updateGoal();
      resetSteps();
    });
  }*/

  void updateGoal() {
    DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(0); // Initial value
    SharedPreferences.getInstance().then((prefs) {
      final savedDateMillis = prefs.getInt('lastDateMillis') ?? 0;
      if (savedDateMillis != 0) {
        lastDate = DateTime.fromMillisecondsSinceEpoch(savedDateMillis);
      }
      if (isSameDay(DateTime.now(), lastDate)) {
        return;
      }
      if (goal < 40000) {
        setState(() {
          goal += 500;
        });
        prefs.setInt('goal', goal);
        prefs.setInt('lastDateMillis', DateTime.now().millisecondsSinceEpoch);
      }
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

//shared preferences comme cookies en php
  Future<void> resetSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastResetDate = prefs.getString('lastResetDate');
    String currentDate = DateTime.now().toString().split(' ')[0];

    // Check if current date is different from last reset date
    if (lastResetDate != currentDate) {
      prefs.setInt('steps', 0); // Reset steps count to 0
      prefs.setString('lastResetDate', currentDate); // Save the reset date
    }
  }

  void handleResetAndUpdate() async {
    await resetSteps();
    SharedPreferences prefs = await SharedPreferences.getInstance();
   
      // Existing user, update the goal
     
    

    setState(() {
      steps = 0; // Reset the steps count to 0
    });

    prefs.remove('steps');
   
  }
  void upGoal() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
   
      // Existing user, update the goal
      setState(() {
        goal += 500;
      });
      prefs.setInt('goal', goal);
     goalRef.set(goal);
  }
  
  Future<void> initializeGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isNewUser = prefs.getBool('isNewUser') ?? true;

    if (isNewUser) {
      // New user, set the goal to 500
      setState(() {
        goal = 500;
      });
      prefs.setInt('goal', goal);
      prefs.setBool('isNewUser', false); // Mark the user as an existing user
    } else {
      // Existing user, retrieve the goal from SharedPreferences
      setState(() {
        goal = prefs.getInt('goal') ?? 500;
      });
    }
  }

  /*void handleSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Clear all SharedPreferences data
    prefs.setBool('isNewUser', true); // Mark the user as a new user
    initializeGoal(); // Set the goal to 500 for new users
    // You can perform additional sign-up related tasks here
    // For example, storing user data, initializing preferences, etc.
  }*/

  @override
  void initState() {
    super.initState();
    initializePreferences();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    currentDate = DateTime.now();
    setupSensors();
    _startTimer();
     goalRef = FirebaseDatabase.instance
      .reference()
      
      .child(getCurrentUserID())
      .child('But')
      .child('goal');
   fetchGoalFromFirebase();
   dbRef = FirebaseDatabase.instance
   .ref().child(getCurrentUserID()).child('Poids').child('weight');
   fetchWeight();
   wRef = FirebaseDatabase.instance
   .ref().child(getCurrentUserID()).child('TaillePas').child('stepLength');
   fetchStepLength();
   BRef = FirebaseDatabase.instance
   .ref().child(getCurrentUserID()).child('AnneeNaissance').child('YearOfBirth');
   fetchBirth();
  
   
  }
  
  Future<void> initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      goal = prefs.getInt('goal') ?? 500;
      updateGoal();
    });
  }
  void fetchGoalFromFirebase() {
  
    goalRef = FirebaseDatabase.instance
        .reference()
      
        .child( getCurrentUserID())
        .child('But')
        .child('goal');
    
    goalRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          goal = event.snapshot.value as int;
        });
      }
    }, onError: (error) {
      print('Failed to fetch goal from Firebase: $error');
    });
  }
   void fetchWeight() {
  
    dbRef = FirebaseDatabase.instance
        .reference()
       
        .child( getCurrentUserID())
        .child('Poids').child('weight');
        
    
    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          weight = event.snapshot.value as int;
        });
      }
    }, onError: (error) {
      print('Failed to fetch weight from Firebase: $error');
    });
  }
    void fetchStepLength() {
  
    wRef = FirebaseDatabase.instance
        .reference()
        
        .child( getCurrentUserID())
        .child('TaillePas').child('stepLength');
        
    
    wRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          stepLength = event.snapshot.value as double;
        });
      }

    }, onError: (error) {
      print('Failed to fetch step length from Firebase: $error');
    });
  }
  void fetchBirth() {
  
    BRef = FirebaseDatabase.instance
        .reference()
        
        .child( getCurrentUserID())
        .child('AnneeNaissance')
        .child('YearOfBirth');
        
    
    BRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          YearOfBirth = event.snapshot.value as int;
        });
      }

    }, onError: (error) {
      print('Failed to fetch year of birth from Firebase: $error');
    });
  }
  Future<void> _showNotification(int steps) async {
  if (!isCounting) {
    return; // If not counting, don't show the notification
  }

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
    0,
    "FitMyWay",
    "You have taken $steps steps today! :)",
    notificationDetails,
  );
}

  @override
  void dispose() {
    super.dispose();
    stopSensors();
  }
  
  void setupSensors() {
    accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
        distance = getValue(x, y, z);
        if (isCounting) {
          counter++;
          //if(counter > 14)
          if (distance > 10) {
            steps++;
            saveStepCount(steps); // Save the step count
            //counter = 0;
            _showNotification(
                steps); 
                heartRate = calculateHeartRate(YearOfBirth,steps);// Show the updated steps count in the notification
          }
          //counter=0;
        }
        calories = calculateCalories(steps,weight);
        duration = calculateDuration(steps,stepLength);
        miles = calculateMiles(steps,stepLength);
        
       print(heartRate);
      });
    });
  }
void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 30), (_) {
      _water();
    });
  }

  Future<void> _water() async {
    var androidDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        1, "FitMyWay", "It's time to drink water", notificationDetails);
  }
  void stopSensors() {
    accelerometerEvents.drain();
  }

  Future<void> saveStepCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepCount', count);
  }

  /*Future<int> getSavedStepCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('stepCount') ?? 0;
  }*/

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);
    return magnitude;
  }

  void setPreviousValue(double distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = prefs.getDouble("preValue") ?? 0.0;
    });
  }

  double calculateMiles(int steps, double stepLength) {
  double kilometersValue = (stepLength * 100 * steps) / 100000; // Convert steps to kilometers
  return kilometersValue;
}


  double calculateDuration(int steps,double stepLength) {
    double walkingSpeed = 1.2; // in meters per minute
    double duration = (steps * stepLength) / (walkingSpeed * 60);
    return duration;
    /*double durationHours = durationMinutes / 60; // Convert minutes to hours
  return durationHours;*/
  }

  double calculateCalories(int steps, int weight) {
  double caloriesValue = ((steps * 78) / 100000) * weight; // Assume 78 steps burn 1 calorie
  return caloriesValue;
}
int calculateHeartRate(int yearOfBirth,int steps) {
 int age = DateTime.now().year - yearOfBirth;
  int maxHeartRate = 220 - age;

  
  int averageHeartRate;

 
      averageHeartRate = (maxHeartRate * 0.8).round(); // Estimate heart rate for running
   

  return averageHeartRate;
}



/*In this function, the averageStepRate is an assumed average number of steps per minute for an individual. The heart rate is estimated by dividing the number of steps by the average step rate and then multiplying by 60 to convert it to beats per minute. The result is rounded to the nearest integer using the toInt() function.*/
  @override
  Widget build(BuildContext context) {
    _showNotification(steps);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),
          Container(
            
            child: Column(
              children: [
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCounting = !isCounting;
                    });
                  },
                  child: Image.asset(
                    'assets/images/p.png',
                    width: 20,
                    height: 20,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ],
                    ),
                  ),
                  PopularSection(steps, miles, calories, duration, heartRate),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HealthTrackerProgressScreen(calories),
                                  ),
                                );
                              },
                              child: const Text("View calories      "),
                              style: TextButton.styleFrom(
                                primary: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                
                                setState(() {
                                  isCounting = !isCounting;
                                });
                              },
                              child: Icon(
                                Icons.stop_circle_rounded,
                                size: 30,
                              ),
                              style: TextButton.styleFrom(
                                primary: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                         
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => heartPage(
                                  
                                ),
                              ),
                            );
                          },
                          child: const Text("Track heart rate"),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 255, 0, 0),
                          ),
                        ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Steps evolution per day:",
                    style: TextStyle(
                      color: Color.fromARGB(255, 41, 149, 189),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Center(
                    child: chartWidget(steps),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dashboardSection(
                                  steps,
                                  duration,
                                  calories,
                                  
                                  miles,
                                ),
                              ),
                            );
                          },
                          child: const Text("View Daily activity"),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        TextButton(
                          onPressed: handleResetAndUpdate,
                          child: Text('Reset'),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 245, 2, 2),
                          ),
                        ),
                        SizedBox(width: 40,),
                          TextButton(
                          onPressed: upGoal,
                          child: Text('increment goal'),
                          style: TextButton.styleFrom(
                            primary: Color.fromARGB(255, 47, 255, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
