import 'package:flutter/material.dart';
import 'package:leafguard/screens/capture_screen.dart';
import 'package:leafguard/widgets/instruction_step.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 Halo, null!',
                  style: TextStyle(
                    fontSize: 22,fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Crop Health Analysis',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InstructionStep(stepNumber: '1', stepName: 'Capture', stepIcon: Icons.center_focus_strong_rounded),
                                InstructionStep(stepNumber: '2', stepName: 'Analyze', stepIcon: Icons.remove_red_eye_outlined),
                                InstructionStep(stepNumber: '3', stepName: 'Recommendations', stepIcon: Icons.medication)
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 24),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(Colors.white),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  )
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CaptureScreen()),
                                  );
                                },
                                child: Text(
                                  'Diagnose your plant',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
    );
  }
}