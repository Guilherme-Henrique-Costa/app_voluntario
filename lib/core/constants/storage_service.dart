import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../features/perfil/models/voluntario.dart';
import 'api.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const _chaveAtual = 'voluntario_atual';

  static String _chaveVoluntario(int id) => 'voluntario_$id';

  /// Salva um voluntário localmente (armazenamento seguro)
  static Future<void> salvarVoluntario(Voluntario voluntario) async {
    if (voluntario.id == null) {
      debugPrint('⚠️ ID do voluntário não pode ser nulo');
      return;
    }
    try {
      final json = jsonEncode(voluntario.toJsonCompleto());
      await _storage.write(
        key: _chaveVoluntario(voluntario.id!),
        value: json,
      );
    } catch (e) {
      debugPrint('Erro ao salvar voluntário: $e');
    }
  }

  /// Atualiza um voluntário na API
  static Future<void> atualizarVoluntarioNaAPI(Voluntario voluntario) async {
    if (voluntario.id == null) {
      throw Exception('Voluntário sem ID não pode ser atualizado');
    }

    final url = Uri.parse('$baseUrl${voluntario.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(voluntario.toJsonCompleto()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar no servidor: ${response.body}');
    }
  }

  /// Busca um voluntário salvo localmente pelo ID
  static Future<Voluntario?> obterVoluntarioPorId(int id) async {
    try {
      final json = await _storage.read(key: _chaveVoluntario(id));
      if (json == null) return null;
      return Voluntario.fromJson(jsonDecode(json));
    } catch (e) {
      debugPrint('Erro ao obter voluntário: $e');
      return null;
    }
  }

  /// Remove um voluntário local pelo ID
  static Future<void> removerVoluntarioPorId(int id) async {
    try {
      await _storage.delete(key: _chaveVoluntario(id));
    } catch (e) {
      debugPrint('Erro ao remover voluntário: $e');
    }
  }

  /// Lista todos os voluntários salvos localmente
  static Future<List<Voluntario>> listarTodosVoluntarios() async {
    final all = await _storage.readAll();
    return all.entries
        .where((e) => e.key.startsWith('voluntario_'))
        .map((e) => Voluntario.fromJson(jsonDecode(e.value)))
        .toList();
  }

  /// Limpa todos os voluntários armazenados localmente
  static Future<void> limparTodosVoluntarios() async {
    final all = await _storage.readAll();
    for (final entry in all.entries) {
      if (entry.key.startsWith('voluntario_')) {
        await _storage.delete(key: entry.key);
      }
    }
  }

  /// Define e salva o voluntário atual
  static Future<void> salvarAtual(Voluntario voluntario) async {
    if (voluntario.id == null) return;
    try {
      await _storage.write(
        key: _chaveAtual,
        value: voluntario.id.toString(),
      );
      await salvarVoluntario(voluntario);
    } catch (e) {
      debugPrint('Erro ao salvar voluntário atual: $e');
    }
  }

  /// Obtém o voluntário atual salvo
  static Future<Voluntario?> obterAtual() async {
    try {
      final id = await _storage.read(key: _chaveAtual);
      if (id == null) return null;
      return await obterVoluntarioPorId(int.parse(id));
    } catch (e) {
      debugPrint('Erro ao obter voluntário atual: $e');
      return null;
    }
  }

  /// Remove o voluntário atual
  static Future<void> removerAtual() async {
    try {
      await _storage.delete(key: _chaveAtual);
    } catch (e) {
      debugPrint('Erro ao remover voluntário atual: $e');
    }
  }

  /// Retorna apenas o ID do voluntário atual
  static Future<int?> obterIdAtual() async {
    try {
      final id = await _storage.read(key: _chaveAtual);
      return id != null ? int.tryParse(id) : null;
    } catch (e) {
      debugPrint('Erro ao obter ID do voluntário atual: $e');
      return null;
    }
  }

  /// Retorna o nome do voluntário atual
  static Future<String?> getUserName() async {
    try {
      final voluntario = await obterAtual();
      return voluntario?.nome;
    } catch (e) {
      debugPrint('Erro ao obter nome do voluntário: $e');
      return null;
    }
  }
}
