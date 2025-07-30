import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                '🗃️ Downloads',
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
        child: Text('Donloads'),
      ),
    );
  }
}