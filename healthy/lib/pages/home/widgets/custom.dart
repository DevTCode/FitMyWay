import 'package:flutter/material.dart';

class GlassOfWater extends StatefulWidget {
  @override
  _GlassOfWaterState createState() => _GlassOfWaterState();
}

class _GlassOfWaterState extends State<GlassOfWater>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentWaterLevel = 0.0;
  final double _maxWaterLevel = 150.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _currentWaterLevel =
              _animation.value * _maxWaterLevel;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addWater() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 110.0,
          width: 90.0,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 46, 253),
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 4.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: _currentWaterLevel,
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
             
            ],
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _addWater,
          child: Text('Add Water'),
        ),
      ],
    );
  }
}
