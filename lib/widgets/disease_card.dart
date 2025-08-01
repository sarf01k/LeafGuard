// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DiseaseCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String symptoms;
  final double? elevation;
  final Color? bgColor;
  final Color? textColor;

  const DiseaseCard({
    super.key,
    required this.imageUrl, required this.title, required this.symptoms, this.elevation, this.bgColor, this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: elevation ?? 6,
        borderRadius: BorderRadius.circular(18),
        shadowColor: Colors.black.withOpacity(0.3),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor ?? Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageUrl,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: const Color(0xFF666666).withOpacity(0.3),
                        )
                      ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      symptoms,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              textColor == null
                ? Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        iconSize: 18,
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: const Color(0xFF666666).withOpacity(0.8),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
