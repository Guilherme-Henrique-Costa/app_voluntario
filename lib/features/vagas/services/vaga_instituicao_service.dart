import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vaga_instituicao_model.dart';
import '../../../core/constants/api.dart'; // <- baseUrl centralizado

class VagaInstituicaoService {
  /// 🔹 Lista todas as vagas disponíveis
  Future<List<VagaInstituicao>> listarVagasDisponiveis() async {
    final url = Uri.parse('$baseUrl/vagasInstituicao/vagasDisponiveis');

    try {
      final response = await http.get(url);

      print('🔍 [listarVagasDisponiveis] Status: ${response.statusCode}');
      print('🔍 [listarVagasDisponiveis] Body: ${response.body}');

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

  /// 🔹 Realiza candidatura do voluntário em uma vaga
  Future<void> candidatarVaga({
    required int vagaId,
    required int voluntarioId,
  }) async {
    final url = Uri.parse('$baseUrl/candidaturas');
    final body = jsonEncode({
      'vaga': {'id': vagaId},
      'voluntario': {'id': voluntarioId}
    });

    print('📤 [CANDIDATAR] POST $url');
    print('📦 Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📥 [CANDIDATAR] Status: ${response.statusCode}');
      print('📥 [CANDIDATAR] Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao se candidatar: ${response.body}');
      }
    } catch (e) {
      print('🔥 Erro candidatarVaga: $e');
      rethrow;
    }
  }

  /// 🔹 Busca candidaturas de um voluntário específico
  Future<List<VagaInstituicao>> buscarCandidaturasDoVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$baseUrl/candidaturas/voluntario/$voluntarioId');

    print('📡 [GET] $url');

    try {
      final response = await http.get(url);

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => VagaInstituicao.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao buscar candidaturas: ${response.statusCode}');
      }
    } catch (e) {
      print('🔥 Erro buscarCandidaturasDoVoluntario: $e');
      rethrow;
    }
  }

  /// 🔹 Cria uma nova vaga vinculada a uma instituição
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

      print('📥 [CRIAR VAGA] Status: ${response.statusCode}');
      print('📥 [CRIAR VAGA] Body: ${response.body}');

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
