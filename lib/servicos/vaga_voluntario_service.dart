import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';
import '../constants/api.dart'; // importa baseUrl centralizado

class VagasVoluntariasService {
  Future<void> candidatar({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$baseUrl/candidaturas');
    final body = {
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId}
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao candidatar: ${response.body}');
    }
  }

  Future<List<VagaInstituicao>> buscarCandidaturasDoVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$baseUrl/candidaturas/voluntario/$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VagaInstituicao.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
    }
  }
}
