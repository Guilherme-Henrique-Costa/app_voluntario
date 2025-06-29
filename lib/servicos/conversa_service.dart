// lib/servicos/conversa_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/conversa.dart';
import 'storage_service.dart';

class ConversaService {
  static const String _baseUrl =
      'http://192.168.15.5:8080/api/v1/mensagem-voluntaria';

  static Future<List<Conversa>> listarConversas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario == null || voluntario.id == null) {
      throw Exception('Voluntário não logado ou sem ID');
    }

    final url = Uri.parse('$_baseUrl/voluntario/${voluntario.id}/conversas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((json) => Conversa.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar conversas: ${response.statusCode}');
    }
  }

  static Future<void> salvarConversaLocal(Conversa c) async {
    final _key = 'lista_conversas';
    final _storage = const FlutterSecureStorage();

    final dados = await _storage.read(key: _key);
    List<Conversa> lista = [];

    if (dados != null) {
      final json = jsonDecode(dados) as List;
      lista = json.map((e) => Conversa.fromJson(e)).toList();
    }

    lista.removeWhere((item) => item.nomeInstituicao == c.nomeInstituicao);
    lista.insert(0, c);

    await _storage.write(
      key: _key,
      value: jsonEncode(lista.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<Conversa>> listarConversasLocal() async {
    final _key = 'lista_conversas';
    final _storage = const FlutterSecureStorage();

    final dados = await _storage.read(key: _key);
    if (dados == null) return [];
    final json = jsonDecode(dados) as List;
    return json.map((e) => Conversa.fromJson(e)).toList();
  }
}
