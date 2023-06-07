import 'package:flutter/material.dart';

import 'package:healthy/pages/home/widgets/text.dart';

class CategorySection extends StatelessWidget {
  String imagePath, number, textTitle;
  CategorySection(this.imagePath, this.number, this.textTitle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.30,
      child: Column(
        children: [
          Expanded(child:
          Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ),
          // text
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: text(19, number),
          ),

          // this is another text
          text(12, textTitle),
        ],
      ),
    );
  }
}
