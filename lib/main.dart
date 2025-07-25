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
        onPressed: () {
          _imageService.pickImage(context, ImageSource.camera);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 50,
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(0),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: Icon(Icons.history,
                  color: _selectedIndex == 2 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}