import 'package:flutter/material.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contactinformatie')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Heb je geen account?\nNeem contact met ons op:',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text('📧 Email: support@fitnessapp.nl'),
            Text('📞 Telefoon: 06-12345678'),
            Text('🏢 Adres: Sportlaan 1, Eindhoven'),
          ],
        ),
      ),
    );
  }
}
