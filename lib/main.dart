import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafguard/screens/capture_screen.dart';
import 'package:leafguard/screens/history_screen.dart';
import 'package:leafguard/screens/home_screen.dart';
import 'package:leafguard/services/image_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const LeafGuard());
}

class LeafGuard extends StatelessWidget {
  const LeafGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    CaptureScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final ImageService _imageService = ImageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _imageService.pickImage(context, ImageSource.camera);
        },
        backgroundColor: const Color(0xFF228B22),
        foregroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE6F4EA),
        shape: const CircularNotchedRectangle(),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.home_rounded,
                    color: _selectedIndex == 0 ? const Color(0xFF228B22) : const Color(0xFFA8A8A8)),
                onPressed: () => _onItemTapped(0),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.history_rounded,
                    color: _selectedIndex == 2 ? const Color(0xFF228B22) : const Color(0xFFA8A8A8)),
                onPressed: () => _onItemTapped(2),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}