import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:healthy/pages/home/widgets/category.dart';
import 'package:healthy/pages/home/widgets/container.dart';
import 'package:healthy/pages/home/widgets/search.dart';
import 'package:healthy/pages/home/widgets/text.dart';

import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PopularSection extends StatelessWidget {
  int steps, heartRate;
  double miles, calories, duration;
  PopularSection(
      this.steps, this.miles, this.calories, this.duration, this.heartRate,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 280,
          decoration: const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
          child: Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: PageView(
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 44,
                            right: 44,
                            bottom: 30,
                            top: 30,
                            child: SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                angleRange: 360.0,
                                startAngle: 0,
                                customColors: CustomSliderColors(
                                    progressBarColor:
                                        Color.fromARGB(255, 41, 149, 189),
                                    trackColor: Color.fromARGB(255, 0, 255, 0)),
                                customWidths: CustomSliderWidths(
                                    progressBarWidth: 8, trackWidth: 9),
                              ),
                              innerWidget: (p) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.run_circle_outlined,
                                        size: 80,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    text(30, steps.toString()),
                                    Text(
                                      "Steps",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                              max: 100,
                              min: 0,
                              initialValue: 64,
                            ),
                          ),
                          Positioned(
                            left: 38,
                            right: 38,
                            bottom: 20,
                            top: 20,
                            child: SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                angleRange: 360.0,
                                startAngle: 0,
                                customColors: CustomSliderColors(
                                    progressBarColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    trackColor:
                                        Color.fromARGB(255, 255, 255, 255)),
                                customWidths: CustomSliderWidths(
                                    progressBarWidth: 4, trackWidth: 4),
                              ),
                              innerWidget: (p) {
                                return Container();
                              },
                              max: 100,
                              min: 0,
                              initialValue: 64,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: 
                const Text(
                  "Overview",
                  style: TextStyle(
                      color: Color.fromARGB(255, 11, 11, 11),
                      fontWeight: FontWeight.bold),
                ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CategorySection("assets/images/locations.png",
                    miles.toStringAsFixed(2), "Km"),
                CategorySection("assets/images/calories.png",
                    calories.toStringAsFixed(2), "Kcal"),
                CategorySection("assets/images/stopwatch.png",
                    duration.toStringAsFixed(0), "minutes"),
              
              ],
            )
          ]),
        ),
      ],
    );
  }
}
