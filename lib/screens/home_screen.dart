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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: const Color(0xFF21d660),
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 16.0),
              child: Text(
                'LeafGuard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
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
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Crop Health Analysis',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InstructionStep(stepNumber: '1', stepName: 'Capture', stepIcon: Icons.center_focus_strong_outlined),
                        InstructionStep(stepNumber: '2', stepName: 'Analyze', stepIcon: Icons.remove_red_eye_outlined),
                        InstructionStep(stepNumber: '3', stepName: 'Treatment', stepIcon: Icons.medication_outlined)
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 24),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                          padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                          backgroundColor: WidgetStateProperty.all(const Color(0xFF21d660)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          )
                        ),
                        onPressed: () {
                          _imageService.openImagePickerOptions(context, _imageService);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_services_rounded, color:Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Diagnose Your Plant',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
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
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: 32),
              Text(
                '🦠 Some Common Diseases:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DiseaseCard(
                      title: 'Leaf Spot', imageUrl: 'assets/images/leaf_spot_main.jpg', symptoms: 'Small brown, black, or yellow spots on leaves',
                    ),
                    DiseaseCard(
                      title: 'Blight', imageUrl: 'assets/images/blight_main.jpg', symptoms: 'Spots or lesions on fruits',
                    ),
                    DiseaseCard(
                      title: 'Powdery Mildew', imageUrl: 'assets/images/powdery_mildew_main.jpg', symptoms: 'White or gray powdery spots on leaves and stems',
                    ),
                    DiseaseCard(
                      title: 'Rust', imageUrl: 'assets/images/rust_main.jpg', symptoms: 'Rust-colored pustules on leaves',
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