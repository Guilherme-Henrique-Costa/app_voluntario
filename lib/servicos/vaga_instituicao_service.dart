import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';

class VagaInstituicaoService {
  static const String _baseUrl = 'http://192.168.15.5:8080/api/v1';

  Future<List<VagaInstituicao>> fetchVagasDisponiveis() async {
    final url = Uri.parse('$_baseUrl/vagasDisponiveis');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => VagaInstituicao.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar vagas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro fetchVagasDisponiveis: $e');
      rethrow;
    }
  }

  Future<void> candidatarVaga({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$_baseUrl/candidaturas');
    final body = jsonEncode({
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId}
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao se candidatar: ${response.body}');
      }
    } catch (e) {
      print('Erro candidatarVaga: $e');
      rethrow;
    }
  }

  Future<List<VagaInstituicao>> buscarCandidaturasDoVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$_baseUrl/candidaturas/voluntario/$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VagaInstituicao.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
    }
  }

  Future<List<VagaInstituicao>> listarVagasDisponiveis() async {
    final response = await http.get(Uri.parse('$_baseUrl/vagasDisponiveis'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => VagaInstituicao.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar vagas');
    }
  }
}
