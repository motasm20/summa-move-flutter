import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/performance.dart';
import '../models/exercise.dart';
import '../services/api_service.dart';

class PerformanceScreen extends StatefulWidget {
  final ApiService apiService;

  const PerformanceScreen({super.key, required this.apiService});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late Future<List<Performance>> _futurePerformances;

  @override
  void initState() {
    super.initState();
    _futurePerformances = widget.apiService.getPerformances();
  }

  void _refresh() {
    setState(() {
      _futurePerformances = widget.apiService.getPerformances();
    });
  }

  Future<void> _toonBewerkDialog(Performance perf) async {
    final controller = TextEditingController(text: perf.result);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prestatie bewerken'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Resultaat'),
        ),
        actions: [
          TextButton(
            child: const Text('Annuleren'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Opslaan'),
            onPressed: () async {
              if (perf.id != null && perf.exercise?.id != null) {
                await widget.apiService.updatePerformance(
                  perf.id!,
                  controller.text,
                  perf.exercise!.id!,
                );
                _refresh();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _verwijderPrestatie(Performance perf) async {
    if (perf.id != null) {
      await widget.apiService.deletePerformance(perf.id!);
      _refresh();
    }
  }

  Future<void> _toonToevoegDialog() async {
    final resultController = TextEditingController();
    Exercise? geselecteerdeOefening;

    // Laad de oefeningen van de API
    List<Exercise> oefeningen = [];
    try {
      oefeningen = await widget.apiService.getExercises();
    } catch (e) {
      // Foutmelding tonen als ophalen mislukt
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij ophalen van oefeningen: $e')),
        );
      }
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prestatie toevoegen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: resultController,
                decoration: const InputDecoration(labelText: 'Resultaat'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Exercise>(
                decoration: const InputDecoration(labelText: 'Oefening'),
                value: geselecteerdeOefening,
                items: oefeningen.map((exercise) {
                  return DropdownMenuItem(
                    value: exercise,
                    child: Text(exercise.title ?? 'Zonder titel'),
                  );
                }).toList(),
                onChanged: (value) {
                  geselecteerdeOefening = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuleren'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Opslaan'),
              onPressed: () async {
                if (geselecteerdeOefening != null &&
                    resultController.text.trim().isNotEmpty) {
                  await widget.apiService.addPerformance(
                    resultController.text.trim(),
                    geselecteerdeOefening!.id!,
                  );
                  _refresh();
                  Navigator.pop(context);
                } else {
                  // Feedback tonen als gegevens ontbreken
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vul alle velden in.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn Prestaties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _toonToevoegDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Performance>>(
        future: _futurePerformances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fout: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Je hebt nog geen prestaties.'));
          }

          final performances = snapshot.data!;
          return ListView.builder(
            itemCount: performances.length,
            itemBuilder: (context, index) {
              final perf = performances[index];
              final formattedDate = perf.createdAt != null
                  ? DateFormat('yyyy-MM-dd').format(perf.createdAt!)
                  : 'Onbekend';

              return ListTile(
                title: Text('Resultaat: ${perf.result}'),
                subtitle: Text(
                  '${perf.exercise?.title ?? "Onbekende oefening"} - Datum: $formattedDate',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _toonBewerkDialog(perf),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _verwijderPrestatie(perf),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
