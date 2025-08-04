import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafguard/screens/articles_screen.dart';
import 'package:leafguard/screens/downloads_screen.dart';
import 'package:leafguard/screens/tips_screen.dart';
import 'package:leafguard/screens/home_screen.dart';
import 'package:leafguard/services/image_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // debug sake
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

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
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MainScreen(),
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
    ArticlesScreen(),
    TipsScreen(),
    DownloadsScreen()
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
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: const Color(0xFF2E2E2E),
        child: SvgPicture.asset(
          'assets/images/camera.svg',
          height: 28,
          width: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomAppBar(
          color: const Color(0xFFffffff),
          shape: const CircularNotchedRectangle(),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: SvgPicture.asset(
                        'assets/images/home.svg',
                        height: 32,
                        width: 32,
                        color: _selectedIndex == 0 ? const Color(0xFF388E3C) : const Color(0xFFA8A8A8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: SvgPicture.asset(
                        'assets/images/articles.svg',
                        height: 32,
                        width: 32,
                        color: _selectedIndex == 1 ? const Color(0xFF388E3C) : const Color(0xFFA8A8A8),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: SvgPicture.asset(
                        'assets/images/tips.svg',
                        height: 32,
                        width: 32,
                        color: _selectedIndex == 2 ? const Color(0xFF388E3C) : const Color(0xFFA8A8A8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(3),
                      child: SvgPicture.asset(
                        'assets/images/downloads.svg',
                        height: 32,
                        width: 32,
                        color: _selectedIndex == 3 ? const Color(0xFF388E3C) : const Color(0xFFA8A8A8),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}