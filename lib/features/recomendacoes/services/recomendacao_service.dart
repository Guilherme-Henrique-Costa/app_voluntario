import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/recomendacao_model.dart';

class RecomendacaoService {
  Future<RecomendacaoModel> fetchRecomendacoes(int voluntarioId) async {
    final url = Uri.parse('$baseUrl/voluntario/$voluntarioId/recomendacoes');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return RecomendacaoModel.fromJson(jsonBody);
    } else {
      throw Exception('Erro ao buscar recomendações: ${response.statusCode}');
    }
  }
}
