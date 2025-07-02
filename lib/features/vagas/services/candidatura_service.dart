import 'dart:convert';
import 'package:app_voluntario/features/vagas/models/vaga_candidatada_model.dart';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';
import '../../../core/constants/api.dart'; // Importa baseUrl centralizado

class CandidaturaService {
  Future<void> candidatar({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$candidaturaUrl/candidaturas');
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
    final url = Uri.parse('$baseUrl/vagasCandidatadas/$voluntarioId');

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
        '$candidaturaUrl/candidaturas/verificar?vagaId=$vagaId&voluntarioId=$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['candidatado'] == true;
    } else {
      throw Exception('Erro ao verificar candidatura: ${response.statusCode}');
    }
  }

  Future<bool> cancelarCandidatura(int idVaga, int idVoluntario) async {
    final url = Uri.parse('$candidaturaUrl/candidaturas/cancelar');

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
