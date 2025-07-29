import 'package:flutter/material.dart';
import 'package:leafguard/services/image_service.dart';
import 'package:leafguard/widgets/disease_card.dart';
import 'package:leafguard/widgets/instruction_step.dart';

class Home extends StatelessWidget {
  final ImageService _imageService = ImageService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF228B22),
        title: Text(
          'LeafGuard',
        ),
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🌿 Let\'s check your plant!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                )
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Crop Health Analysis',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF228B22),
                  borderRadius: BorderRadius.circular(18)
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
                          padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                          backgroundColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          )
                        ),
                        onPressed: () {
                          _imageService.openImagePickerOptions(context, _imageService);
                        },
                        child: Text(
                          '🔍 Diagnose Your Plant',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '💡 Tip: Make sure the image is well-lit and focused for best results.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: 32),
              Text(
                '🦠 Some Common Diseases:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DiseaseCard(
                      title: 'Leaf Spot',
                    ),
                    DiseaseCard(
                      title: 'Blight',
                    ),
                    DiseaseCard(
                      title: 'Powdery Mildew',
                    ),
                    DiseaseCard(
                      title: 'Rust',
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}