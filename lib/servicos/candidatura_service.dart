import 'dart:convert';
import 'package:app_voluntario/models/vaga_candidatada_model.dart';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';

class CandidaturaService {
  static const String _baseUrl = 'http://192.168.15.5:8080/api/v1';

  Future<void> candidatar({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$_baseUrl/candidaturas');
    final body = jsonEncode({
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId},
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao candidatar: ${response.body}');
    }
  }

  Future<List<VagaCandidatada>> buscarCandidaturasDoVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$_baseUrl/vagasCandidatadas/$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VagaCandidatada.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
    }
  }

  Future<bool> verificarCandidatura(int vagaId, int voluntarioId) async {
    final url = Uri.parse(
        '$_baseUrl/candidaturas/verificar?vagaId=$vagaId&voluntarioId=$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['candidatado'] == true;
    } else {
      throw Exception('Erro ao verificar candidatura: ${response.statusCode}');
    }
  }

  Future<bool> cancelarCandidatura(int idVaga, int idVoluntario) async {
    final url = Uri.parse('$_baseUrl/candidaturas/cancelar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'vaga': {'id': idVaga},
        'voluntario': {'id': idVoluntario},
      }),
    );

    return response.statusCode == 200;
  }
}
