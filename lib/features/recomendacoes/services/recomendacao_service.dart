import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/recomendacao_model.dart';

class RecomendacaoService {
  final http.Client _client;

  RecomendacaoService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<RecomendacaoModel>> buscarRecomendacoes(int voluntarioId) async {
    final uri = Uri.parse('$baseUrl/voluntario/$voluntarioId/recomendacoes');

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody.map((e) => RecomendacaoModel.fromJson(e)).toList();
      }

      throw HttpException(
        'Erro ${response.statusCode}: ${response.reasonPhrase}',
        uri: uri,
      );
    } on SocketException {
      throw Exception(
          'Falha de conexão com o servidor. Verifique sua internet.');
    } on TimeoutException {
      throw Exception('Tempo limite de conexão atingido.');
    } on FormatException {
      throw Exception('Erro ao interpretar resposta da API.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
