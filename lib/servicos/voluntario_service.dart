import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voluntario.dart';

class VoluntarioService {
  static const String baseUrl = 'http://10.233.23.35:8080/api/v1/voluntario';

  // Login
  Future<Voluntario?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailInstitucional': email,
          'password': senha,
        }),
      );

      if (resposta.statusCode == 200) {
        final json = jsonDecode(resposta.body);
        return Voluntario.fromJson(json);
      } else {
        return null; // Login inválido
      }
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  // Buscar voluntário por ID (exemplo de outro endpoint)
  Future<Voluntario?> buscarPorId(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final json = jsonDecode(resposta.body);
        return Voluntario.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar voluntário: $e');
      return null;
    }
  }
}
