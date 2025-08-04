import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TipsScreen extends StatelessWidget {
  TipsScreen({super.key});

  final String tipOfTheDay =
      'Rotate crops every season to reduce soil-borne diseases.';

  final Map<String, List<String>> farmingTopics = {
    'Soil Preparation': [
      'Test your soil before planting.',
      'Mix compost or manure well.',
      'Avoid tilling too deep.'
    ],
    'Crop Rotation': [
      'Don’t plant the same crop every season.',
      'Rotate with legumes to fix nitrogen.'
    ],
    'Irrigation': [
      'Water early morning.',
      'Use drip systems for efficiency.',
      'Avoid overwatering.'
    ],
    'Pest Control': [
      'Use neem oil or organic sprays.',
      'Introduce natural predators like ladybugs.',
    ],
    'Disease Control': [
      'Remove infected leaves.',
      'Avoid overcrowding crops.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: const Color(0xFF388E3C),
          title: null, // Disable default title
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft, // Bottom left alignment
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0), // Adjust spacing
              child: Text(
                'Farming Tips',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xFFE0E0E0).withOpacity(0.6)
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/lightbulb.svg',
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tip of the Day: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: tipOfTheDay,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...farmingTopics.entries.map((entry) {
            return ExpansionTile(
              title: Text(
                entry.key,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: entry.value.map((tip) {
                return ListTile(
                  title: Text('• $tip'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}