import 'package:flutter/material.dart';

class InstructionStep extends StatelessWidget {
  final String stepNumber;
  final String stepName;
  final IconData stepIcon;

  const InstructionStep({
    super.key,
    required this.stepNumber,
    required this.stepName,
    required this.stepIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            stepNumber,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Icon(
            stepIcon,
            color: Colors.white,
            size: 50
          ),
        ),
        Text(
          stepName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold
          )
        )
      ],
    );
  }
}