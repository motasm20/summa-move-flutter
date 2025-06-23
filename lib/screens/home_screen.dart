import 'package:flutter/material.dart';
import 'exercise_screen.dart';
import 'performance_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'contact_info_screen.dart';
import '../services/authenticatie_service.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final AuthenticationService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late ApiService _apiService;
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(widget.authService);
    _isLoggedIn = widget.authService.isLoggedIn();

    _screens = [
      _buildWelcomeScreen(),
      ExerciseScreen(authService: widget.authService),
      if (_isLoggedIn) PerformanceScreen(apiService: _apiService),
      ProfileScreen(authService: widget.authService),
    ];

    _navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Oefeningen'),
      if (_isLoggedIn)
        const BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Prestaties'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profiel'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welkom bij de MoJackWin Fitness App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('Over deze App'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactInfoScreen()),
                );
              },
              icon: const Icon(Icons.contact_mail),
              label: const Text('Contactinformatie'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: _navItems,
      ),
    );
  }
}
