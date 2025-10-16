import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/vaga_candidatada_model.dart';

/// Serviço responsável por gerenciar candidaturas (criar, cancelar, listar, verificar).
class CandidaturaService {
  /// Envia uma candidatura.
  ///
  /// Retorna `true` se o envio for bem-sucedido, `false` caso contrário.
  Future<bool> candidatar({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$baseUrl/candidaturas');
    final body = jsonEncode({
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId},
    });

    log('📤 [POST] $url');
    log('📦 Body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('✅ Candidatura enviada com sucesso');
      return true;
    } else {
      log('❌ Erro ao enviar candidatura: ${response.body}');
      return false;
    }
  }

  Future<List<VagaCandidatada>> buscarCandidaturasDoVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$baseUrl/vagasCandidatadas/$voluntarioId');
    log('📡 [GET] $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      log('✅ Recebidas ${data.length} candidaturas');
      return data.map((e) => VagaCandidatada.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
    }
  }

  Future<bool> cancelarCandidatura(int vagaId, int voluntarioId) async {
    final url = Uri.parse('$baseUrl/candidaturas/cancelar');
    final body = jsonEncode({
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId},
    });

    log('📤 [POST] $url');
    log('📦 Body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      log('✅ Candidatura cancelada');
      return true;
    } else {
      log('❌ Falha ao cancelar: ${response.body}');
      return false;
    }
  }

  Future<bool> verificarCandidatura(int vagaId, int voluntarioId) async {
    final url = Uri.parse(
        '$baseUrl/candidaturas/verificar?vagaId=$vagaId&voluntarioId=$voluntarioId');
    log('📡 [GET] $url');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['candidatado'] == true;
    } else {
      throw Exception('Erro ao verificar candidatura: ${response.statusCode}');
    }
  }
}
