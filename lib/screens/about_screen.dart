import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Over deze app')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'MoJackWin Fitness App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Deze app helpt gebruikers om oefeningen te bekijken, '
                  'prestaties toe te voegen en hun voortgang bij te houden.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text('📱 Versie: 1.0.0'),
            Text('📧 Contact: support@fitnessapp.nl'),
            Text('📍 Gemaakt door Team MoJackWin'),
          ],
        ),
      ),
    );
  }
}
