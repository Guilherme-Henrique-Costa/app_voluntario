import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voluntario.dart';
import '../constants/api.dart'; // Importa a URL centralizada

class VoluntarioService {
  // Login
  Future<Voluntario?> login(String email, String senha) async {
    final url = Uri.parse('$voluntarioUrl/login');

    try {
      final resposta = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'emailInstitucional': email,
          'password': senha,
        }),
      );

      if (resposta.statusCode == 200) {
        final json = jsonDecode(resposta.body);
        return Voluntario.fromJson(json);
      } else {
        print('Erro no login: ${resposta.statusCode}');
        print(resposta.body);
        return null;
      }
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  // Buscar voluntário por ID
  Future<Voluntario?> buscarPorId(int id) async {
    final url = Uri.parse('$voluntarioUrl/$id');
    try {
      final resposta = await http.get(url);
      if (resposta.statusCode == 200) {
        final json = jsonDecode(resposta.body);
        return Voluntario.fromJson(json);
      } else {
        print('Erro ao buscar voluntário: ${resposta.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar voluntário: $e');
      return null;
    }
  }

  // Cadastrar novo voluntário
  Future<bool> cadastrarVoluntario(Voluntario voluntario) async {
    final url = Uri.parse(voluntarioUrl);
    try {
      final jsonBody = jsonEncode(voluntario.toJsonCompleto());
      print('➡️ JSON enviado: $jsonBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonBody,
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao cadastrar voluntário: $e');
      return false;
    }
  }

  // Atualizar dados do voluntário
  Future<bool> atualizarVoluntario(Voluntario voluntario) async {
    if (voluntario.id == null) return false;

    final url = Uri.parse('$voluntarioUrl/${voluntario.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
