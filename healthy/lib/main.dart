import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy/pages/home/widgets/spalshscreen.dart';
import 'package:healthy/pages/home/widgets/water.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthy/authenticate/register.dart';
import 'package:healthy/pages/home/home.dart';
import 'package:healthy/pages/home/widgets/FetchData.dart';
import 'package:healthy/pages/home/widgets/InsertData.dart';
import 'package:healthy/pages/home/widgets/bat.dart';
import 'package:healthy/pages/home/widgets/calories.dart';
import 'package:healthy/pages/home/widgets/chart.dart';
import 'package:healthy/pages/home/widgets/circular.dart';
import 'package:healthy/pages/home/widgets/dashboard.dart';
import 'package:healthy/pages/home/widgets/notif.dart';
import 'package:healthy/pages/home/widgets/header.dart';
import 'package:healthy/pages/home/widgets/profile.dart';
import 'package:healthy/pages/home/widgets/settings.dart';
import 'package:healthy/screens/signin_screen.dart';
import 'package:healthy/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
       
            child: SplashScreen(),
          
        ),
      ),
    );
  }
}
