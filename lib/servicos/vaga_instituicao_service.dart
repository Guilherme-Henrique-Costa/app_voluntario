// lib/servicos/vaga_instituicao_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';
import '../constants/api.dart'; // <- baseUrl centralizado

class VagaInstituicaoService {
  Future<List<VagaInstituicao>> fetchVagasDisponiveis() async {
    final url = Uri.parse('$baseUrl/vagasDisponiveis');

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
    final url = Uri.parse('$baseUrl/candidaturas');
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
    final url = Uri.parse('$baseUrl/candidaturas/voluntario/$voluntarioId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VagaInstituicao.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
    }
  }

  Future<List<VagaInstituicao>> listarVagasDisponiveis() async {
    final url = Uri.parse('$baseUrl/vagasDisponiveis');

    try {
      final response = await http.get(url);

      print('🔍 Status: ${response.statusCode}');
      print('🔍 Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => VagaInstituicao.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao buscar vagas: ${response.statusCode}');
      }
    } catch (e) {
      print('🔥 Erro listarVagasDisponiveis: $e');
      rethrow;
    }
  }

  Future<bool> criarVagaInstituicao(VagaInstituicao vaga) async {
    final url = Uri.parse('$baseUrl/vagasInstituicao');
    final body = jsonEncode(vaga.toJson());

    print('📤 [CRIAR VAGA] POST $url');
    print('🧾 Headers: {Content-Type: application/json}');
    print('📦 Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Vaga criada com sucesso!');
        return true;
      } else if (response.statusCode == 403) {
        print('⛔️ Acesso proibido (403). Verifique permissões ou CORS.');
      } else {
        print('⚠️ Erro ao criar vaga: ${response.body}');
      }

      return false;
    } catch (e) {
      print('🔥 Exceção ao criar vaga: $e');
      return false;
    }
  }
}
