import 'package:flutter/material.dart';
import '../services/authenticatie_service.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthenticationService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await widget.authService.getUser();
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profiel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Naam: ${_user?.name ?? 'Gast'}'),
            Text('Email: ${_user?.email ?? '-'}'),
            Text('Rol: ${_user?.role ?? '-'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                widget.authService.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                }
              },
              child: const Text('Uitloggen'),
            ),
          ],
        ),
      ),
    );
  }
}
