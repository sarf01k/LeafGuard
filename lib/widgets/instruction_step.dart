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
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF2E2E2E),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            stepNumber,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: const Color(0xFFFFFFFF)
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Icon(
            stepIcon,
            color: const Color(0xFF2E2E2E),
            size: 40,
            weight: 300,
          ),
        ),
        Text(
          stepName,
          style: TextStyle(
            color: const Color(0xFF2E2E2E),
            fontSize: 14,
            fontWeight: FontWeight.w400
          )
        )
      ],
    );
  }
}