import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthenticationService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  String? _token;
  User? _user;

  /// Inloggen
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _user = User.fromJson(data['user']);
      return true;
    } else {
      return false;
    }
  }

  /// Registreren
  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _user = User.fromJson(data['user']);
      return true;
    } else {
      return false;
    }
  }

  /// Uitloggen
  void logout() {
    _token = null;
    _user = null;
  }

  /// Token ophalen voor beveiligde API-aanroepen
  String? getToken() => _token;

  /// Ingelogde gebruiker ophalen
  User? getUser() => _user;

  /// Check of er een gebruiker is
  bool isLoggedIn() => _user != null && _token != null;
}
