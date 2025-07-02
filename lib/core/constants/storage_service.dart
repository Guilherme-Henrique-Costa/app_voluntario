import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../features/perfil/models/voluntario.dart';
import 'api.dart'; // Import da URL base

class StorageService {
  static const _storage = FlutterSecureStorage();
  static String _chaveVoluntario(String id) => 'voluntario_$id';
  static const _chaveAtual = 'voluntario_atual';

  static Future<void> salvarVoluntario(Voluntario voluntario) async {
    try {
      if (voluntario.id == null) {
        throw Exception('ID do voluntário não pode ser nulo');
      }
      final json = jsonEncode(voluntario.toJsonCompleto());
      await _storage.write(
        key: _chaveVoluntario(voluntario.id.toString()),
        value: json,
      );
    } catch (e) {
      print('Erro ao salvar voluntário: $e');
    }
  }

  static Future<void> atualizarVoluntarioNaAPI(Voluntario voluntario) async {
    if (voluntario.id == null) {
      throw Exception('Voluntário sem ID não pode ser atualizado');
    }
    final url = Uri.parse('$baseUrl${voluntario.id}');
    final body = jsonEncode(voluntario.toJsonCompleto());

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao atualizar voluntário no servidor: ${response.body}');
    }
  }

  static Future<Voluntario?> obterVoluntarioPorId(int id) async {
    try {
      final json = await _storage.read(key: _chaveVoluntario(id.toString()));
      if (json != null) {
        return Voluntario.fromJson(jsonDecode(json));
      }
    } catch (e) {
      print('Erro ao obter voluntário: $e');
    }
    return null;
  }

  static Future<void> removerVoluntarioPorId(int id) async {
    try {
      await _storage.delete(key: _chaveVoluntario(id.toString()));
    } catch (e) {
      print('Erro ao remover voluntário: $e');
    }
  }

  static Future<List<Voluntario>> listarTodosVoluntarios() async {
    final all = await _storage.readAll();
    return all.entries
        .where((entry) => entry.key.startsWith('voluntario_'))
        .map((entry) => Voluntario.fromJson(jsonDecode(entry.value)))
        .toList();
  }

  static Future<void> limparTodosVoluntarios() async {
    final all = await _storage.readAll();
    for (final entry in all.entries) {
      if (entry.key.startsWith('voluntario_')) {
        await _storage.delete(key: entry.key);
      }
    }
  }

  static Future<void> salvarAtual(Voluntario voluntario) async {
    try {
      if (voluntario.id != null) {
        await _storage.write(
          key: _chaveAtual,
          value: voluntario.id.toString(),
        );
        await salvarVoluntario(voluntario);
      }
    } catch (e) {
      print('Erro ao salvar voluntário atual: $e');
    }
  }

  static Future<Voluntario?> obterAtual() async {
    try {
      final id = await _storage.read(key: _chaveAtual);
      if (id != null) {
        return await obterVoluntarioPorId(int.parse(id));
      }
    } catch (e) {
      print('Erro ao obter voluntário atual: $e');
    }
    return null;
  }

  static Future<void> removerAtual() async {
    try {
      await _storage.delete(key: _chaveAtual);
    } catch (e) {
      print('Erro ao remover voluntário atual: $e');
    }
  }

  static Future<int?> obterIdAtual() async {
    try {
      final id = await _storage.read(key: _chaveAtual);
      return id != null ? int.tryParse(id) : null;
    } catch (e) {
      print('Erro ao obter ID do voluntário atual: $e');
      return null;
    }
  }
}
