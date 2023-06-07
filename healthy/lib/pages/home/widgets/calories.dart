import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/notif.dart';
import 'package:table_calendar/table_calendar.dart';

class dashboardSection extends StatefulWidget {
  int steps;
  double miles, calories, duration;
  dashboardSection(
      this.steps, this.calories, this.duration, this.miles,
      {Key? key})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class StepCount {
  final String day;
  final int count;

  StepCount(this.day, this.count);
}

class _DashboardState extends State<dashboardSection> {
  late DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _events = {}; // Empty events map
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();
  Map<String, dynamic> _dailyActivityData = {};

  @override
  void initState() {
    super.initState();
    fetchDailyActivities();
  }
String getCurrentUserID() {
  User? user = FirebaseAuth.instance.currentUser;
  String userID = user?.uid ?? '';
  print(userID);
  return userID;
  
}
  void fetchDailyActivities() {
    DatabaseReference dailyActivityRef =
        _databaseReference.child('ActivitePhysique');

    dailyActivityRef.once().then((DatabaseEvent snapshot) {
      Map<dynamic, dynamic>? data =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          DateTime date = DateTime.parse(key);
          List<String> events = value.cast<String>();
          _events[date] = events;
        });
      }
      setState(() {});
    }).catchError((error) {
      print('Failed to fetch daily activities: $error');
    });
  }

 void _storeDailyActivity(DateTime selectedDay, String userID) {
  String formattedDate = selectedDay.toIso8601String().split('T').first;

  DatabaseReference dailyActivityRef = _databaseReference
     
      .child(userID)
      .child('ActivitePhysique')
      .child(formattedDate);

  Map<String, dynamic> activityData = {
    'steps': widget.steps,
    
    'miles': widget.miles.toStringAsFixed(2),
    'calories': widget.calories.toStringAsFixed(2),
    'duration': widget.duration.toStringAsFixed(0),
  };

  dailyActivityRef.set(activityData).then((value) {
    print('Daily activity stored successfully');
  }).catchError((error) {
    print('Failed to store daily activity: $error');
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'Daily activity',
            style: TextStyle(color: Color.fromARGB(255, 41, 149, 189)),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back arrow
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color.fromARGB(255, 41, 149, 189), width: 4),
              ),
              todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 38, 255, 0)),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Store the daily activity data in the Firebase database
              _storeDailyActivity(selectedDay,getCurrentUserID());
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child: _events[_selectedDay] != null
                    ? ListView.builder(
                        itemCount: _events[_selectedDay]!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_events[_selectedDay]![index]),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            color: Color.fromARGB(255, 41, 149, 189),
                            child: SizedBox(
                              height: 60,
                              width: 500,

                              // set the padding value
                              child: ListTile(
                                leading: Icon(
                                  Icons.run_circle_outlined,
                                  size: 40,
                                ),
                                iconColor: Color.fromARGB(255, 255, 255, 255),
                                title: Text(
                                  ' Steps                             ${widget.steps} step  ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          Card(
                            color: Color.fromARGB(255, 255, 255, 255),
                            child: SizedBox(
                              height: 60,
                              width: 500,
                              child: ListTile(
                                leading: Icon(
                                  Icons.directions_bike,
                                  size: 40,
                                ),
                                iconColor: Colors.black,
                                title: Text(
                                  ' Miles                             ${widget.miles.toStringAsFixed(2)} km',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                             color: Color.fromARGB(255, 41, 149, 189),
                            child: SizedBox(
                              height: 60,
                              width: 500,
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_fire_department,
                                  size: 40,
                                ),
                                iconColor: Color.fromARGB(255, 255, 98, 0),
                                title: Text(
                                  ' Calories                        ${widget.calories.toStringAsFixed(2)} Kcal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Color.fromARGB(255, 255, 255, 255),
                            child: SizedBox(
                              height: 60,
                              width: 500,
                              child: ListTile(
                                leading: Icon(Icons.access_time, size: 40),
                                iconColor: Color.fromARGB(255, 5, 25, 255),
                                title: Text(
                                  ' Duration                        ${widget.duration.toStringAsFixed(0)} min',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*Text(
                            'clic on the day to save informations after finishing and before seeing history',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )*/
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
