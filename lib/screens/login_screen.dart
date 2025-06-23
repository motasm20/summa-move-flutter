import 'package:flutter/material.dart';
import '../services/authenticatie_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void _handleLogin() async {
    final success = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(authService: _authService),
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Fout: Ongeldige e-mail of wachtwoord.';
      });
    }
  }

  void _continueAsGuest() {
    _authService.logout(); // token/user wissen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(authService: _authService),
      ),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterScreen(authService: _authService)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/fitness.png', // ← vervang met jouw achtergrondafbeelding
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Wachtwoord'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Inloggen'),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {}, // eventueel wachtwoord vergeten functie
                    child: const Text('Wachtwoord vergeten?'),
                  ),
                  TextButton(
                    onPressed: _goToRegister,
                    child: const Text('Geen account?'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _continueAsGuest,
                    child: const Text('Doorgaan als Gast'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}