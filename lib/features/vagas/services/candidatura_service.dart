import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/vaga_candidatada_model.dart';

/// Serviço responsável por gerenciar candidaturas (criar, cancelar, listar, verificar).
class CandidaturaService {
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
    print('📡 [GET] $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('✅ Recebidas ${data.length} candidaturas');

      // ✅ Log dos campos para depuração
      if (data.isNotEmpty) {
        print('🔎 Exemplo de resposta: ${data.first}');
      }

      // ✅ Agora mapeamos o status também
      return data.map((e) {
        final vaga = VagaCandidatada.fromJson(e);
        return VagaCandidatada(
          id: vaga.id,
          cargo: vaga.cargo,
          localidade: vaga.localidade,
          descricao: vaga.descricao,
          especificacoes: vaga.especificacoes,
          tipoVaga: vaga.tipoVaga,
          area: vaga.area,
          horario: vaga.horario,
          tempoVoluntariado: vaga.tempoVoluntariado,
          disponibilidade: vaga.disponibilidade,
          instituicao: vaga.instituicao,
          dataCandidatura: vaga.dataCandidatura,
          latitude: vaga.latitude,
          longitude: vaga.longitude,
          cidade: vaga.cidade,
          status: e['status'] ??
              e['situacao'] ??
              e['estado'] ??
              'Desconhecido', // ✅ campo status garantido
        );
      }).toList();
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
