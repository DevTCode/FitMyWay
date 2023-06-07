import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  Icon someIcon;
  ContainerButton(this.someIcon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.height * 0.13,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Center(
        child: someIcon,
      ),
    );
  }
}