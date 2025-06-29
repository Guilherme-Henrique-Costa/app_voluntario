import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voluntario.dart';

class VoluntarioService {
  static const String baseUrl = 'http://192.168.15.5:8080/api/v1/voluntario';

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
        return null;
      }
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

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

  Future<bool> cadastrarVoluntario(Voluntario voluntario) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(voluntario.toJsonCompleto()),
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao cadastrar voluntário: $e');
      return false;
    }
  }

  Future<bool> atualizarVoluntario(Voluntario voluntario) async {
    if (voluntario.id == null) return false;

    final url = Uri.parse('$baseUrl/${voluntario.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(voluntario.toJsonCompleto()),
      );
      print('PUT status: ${response.statusCode}');
      print('PUT body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao atualizar voluntário: $e');
      return false;
    }
  }
}
