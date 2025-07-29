import 'package:flutter/material.dart';

class DiseaseCard extends StatelessWidget {
  final String title;

  const DiseaseCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/200',
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Holes in leaves, yellowing and wilting foliage",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                iconSize: 18,
                icon: Icon(Icons.arrow_forward_ios_rounded),
                color: Color(0xFF666666),
              ),
            )
          )
        ],
      ),
    );
  }
}
