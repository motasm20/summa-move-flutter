// lib/screens/exercise_screen.dart
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/api_service.dart';
import '../services/authenticatie_service.dart';

class ExerciseScreen extends StatefulWidget {
  final AuthenticationService authService;

  const ExerciseScreen({super.key, required this.authService});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late ApiService _apiService;
  late Future<List<Exercise>> _futureExercises;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(widget.authService);
    _futureExercises = _apiService.getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oefeningen')),
      body: FutureBuilder<List<Exercise>>(
        future: _futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fout: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Geen oefeningen gevonden.'));
          } else {
            final oefeningen = snapshot.data!;
            return ListView.builder(
              itemCount: oefeningen.length,
              itemBuilder: (context, index) {
                final oef = oefeningen[index];
                return ListTile(
                  title: Text(oef.title),
                  subtitle: Text(oef.instructionNl),
                );
              },
            );
          }
        },
      ),
    );
  }
}
