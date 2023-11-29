import 'package:flutter/material.dart';

class Followbutton extends StatelessWidget {
  final Function()? function; //idk yet
  // the color of the button changes depending on the action
  final Color backgroundColor;
  final Color borderColor;
  //depending on the function of the mouse
  final String text;
  final Color textColor;
  const Followbutton(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
            top: 2), // space above the button and belw the stats of the profile
        child: TextButton(
          onPressed: function,
          child: Container(
            // the color of the button changes depending on the action
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            width: 250,
            height: 27,
          ),
        ));
  }
}
