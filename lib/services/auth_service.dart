import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(String u, String p) async {
    final res = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": u, "password": p}),
    );
    return res.statusCode == 200;
  }
}
