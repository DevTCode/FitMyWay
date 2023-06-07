import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/FetchData.dart';
import 'package:healthy/pages/home/widgets/custom.dart';
import 'package:healthy/pages/home/widgets/dashboard.dart';
import 'package:healthy/pages/home/widgets/calories.dart';
import 'package:healthy/pages/home/widgets/notif.dart';
import 'package:healthy/pages/home/widgets/settings.dart';
import 'package:healthy/pages/home/widgets/water.dart';

import 'package:healthy/screens/home_screen.dart';
import 'package:healthy/services/auth.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FetchData(),
    const DailyInfoPage(),
    const dashboard(),
    WaterReminderScreen(),
    goal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        items: const <Widget>[
          Icon(
            Icons.account_box_outlined,
            size: 30,
            color: Color.fromARGB(255, 255, 0, 0),
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Color.fromARGB(255, 196, 57, 228),
          ),
          Icon(
            Icons.directions_walk,
            size: 60,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          Icon(
            Icons.water_drop_rounded,
            size: 30,
            color: Colors.blue,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: Color.fromARGB(255, 2, 52, 92),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
