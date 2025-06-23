import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';
import '../models/performance.dart';
import 'authenticatie_service.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthenticationService authService;

  ApiService(this.authService);

  /// ✅ Oefeningen ophalen (openbare route)
  Future<List<Exercise>> getExercises() async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Kan oefeningen niet ophalen: ${response.body}');
    }
  }

  /// ✅ Prestaties ophalen van de ingelogde gebruiker
  Future<List<Performance>> getPerformances() async {
    final token = authService.getToken();
    if (token == null) throw Exception('Geen token gevonden');

    final response = await http.get(
      Uri.parse('$baseUrl/performances'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Performance.fromJson(json)).toList();
    } else {
      throw Exception('Kan prestaties niet ophalen: ${response.body}');
    }
  }

  /// ✅ Prestatie toevoegen (gekoppeld aan oefening)
  Future<void> addPerformance(String result, int exerciseId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Geen token gevonden');

    final response = await http.post(
      Uri.parse('$baseUrl/performances'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'result': result,
        'exercise_id': exerciseId.toString(),
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Fout bij toevoegen prestatie: ${response.body}');
    }
  }

  /// ✅ Prestatie bijwerken
  Future<void> updatePerformance(int id, String result, int exerciseId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Geen token gevonden');

    final response = await http.put(
      Uri.parse('$baseUrl/performances/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'result': result,
        'exercise_id': exerciseId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Fout bij bijwerken prestatie: ${response.body}');
    }
  }

  /// ✅ Prestatie verwijderen
  Future<void> deletePerformance(int id) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Geen token gevonden');

    final response = await http.delete(
      Uri.parse('$baseUrl/performances/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Fout bij verwijderen prestatie: ${response.body}');
    }
  }
}
