import 'package:flutter/material.dart';
import '../services/authenticatie_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthenticationService authService;

  const RegisterScreen({super.key, required this.authService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void _handleRegister() async {
    final success = await widget.authService.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(authService: widget.authService),
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Registratie mislukt. Probeer een ander e-mailadres.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registreren')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Naam'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mailadres'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Wachtwoord'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleRegister,
              child: const Text('Account aanmaken'),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
