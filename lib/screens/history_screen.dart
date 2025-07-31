import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: const Color(0xFF21d660),
          title: null, // Disable default title
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft, // Bottom left alignment
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0), // Adjust spacing
              child: Text(
                '📜 History',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Histoy"),
          ],
        ),
      ),
    );
  }
}