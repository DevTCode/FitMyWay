import 'package:flutter/material.dart';

class HealthTrackerProgressScreen extends StatelessWidget {
  final double calories;

  HealthTrackerProgressScreen(this.calories, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back arrow
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 184, 204, 214),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/calor.png'),
            fit: BoxFit.cover,
          ),
        ),
         padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            const Text(
              "                 Calories Progress",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              /*child: Icon(
                Icons.local_fire_department_rounded,
                color: Color.fromARGB(255, 255, 60, 0),
                size: 120,
              ),*/
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Calories left",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: Color.fromARGB(255, 226, 92, 55),
                  size: 40,
                ),
                SizedBox(width: 10,),
                Text(
                  calories.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color.fromARGB(255, 41, 149, 189)
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  "KCal",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
         
           
            Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 149, 189),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text("Calories left today", style: TextStyle(fontSize: 30,color: Color.fromARGB(255, 9, 9, 9),fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(),
            SizedBox(
              height: 80,
            ),
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  value: calories / 600, // assuming a daily goal of 600 calories
                  strokeWidth: 30,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 41, 149, 189),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
