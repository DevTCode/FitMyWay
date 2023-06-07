import 'package:flutter/material.dart';
import 'package:healthy/pages/home/widgets/header.dart';
import 'package:healthy/pages/home/widgets/spalshscreen.dart';

class setup extends StatefulWidget {
  const setup({super.key});

  @override
  State<setup> createState() => _setupState();
}

class _setupState extends State<setup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        title: Text('Fill with informations'),
        backgroundColor: Color.fromARGB(255, 41, 149, 189),
        shadowColor: Color.fromARGB(255, 41, 149, 189),
      ),*/
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 150.0, left: 60, right: 60),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 150,
                  color: Color.fromARGB(255, 14, 231, 21),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Setup Complete',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Your Step Counter Is Now Set Up',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 400,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplashScreen(),
                      ),
                    );
                  },
                  child: Text('Done'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 2,
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
