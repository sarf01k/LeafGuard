import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leafguard/widgets/disease_card.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        elevation: 1,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 16),
          child: SizedBox(
            width: 20,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2E2E2E),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF388E3C), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiseaseCard(disease: disease, bgColor: Colors.grey.withOpacity(0.3), nav: false),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/info.svg',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    " Description",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                disease['info'],
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/bug.svg',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    " Mode of Spread",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                disease['spread_method'],
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/leaf.svg',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    " Other Symptoms",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 5),
              ...disease['symptoms'].skip(1).map<Widget>((symptom) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• $symptom',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/spray-can.svg',
                    height: 18,
                    width: 18,
                  ),
                  Text(
                    " Treatment & Prevention",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                disease['treatment'],
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Chemical Control: ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: disease['chemical_control'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Organic Control: ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: disease['organic_control'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              ...disease['prevention'].map<Widget>((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• $entry',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/sprout.svg',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    " Vulnerable Plants",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 5),
              ...disease['vulnerable_plants'].map<Widget>((plant) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• $plant',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}