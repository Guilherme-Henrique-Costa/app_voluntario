// lib/servicos/conversa_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/conversa.dart';
import '../../../core/constants/storage_service.dart';
import '../../../core/constants/api.dart'; // Import baseUrl

class ConversaService {
  static final String _conversaUrl = '$baseUrl/mensagem-voluntaria';

  static Future<List<Conversa>> listarConversas() async {
    final voluntario = await StorageService.obterAtual();
    if (voluntario == null || voluntario.id == null) {
      throw Exception('Voluntário não logado ou sem ID');
    }

    final url =
        Uri.parse('$_conversaUrl/voluntario/${voluntario.id}/conversas');
    final token = voluntario.token;

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((json) => Conversa.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar conversas: ${response.statusCode}');
    }
  }

  static Future<void> salvarConversaLocal(Conversa c) async {
    const _key = 'lista_conversas';
    const _storage = FlutterSecureStorage();

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
    const _key = 'lista_conversas';
    const _storage = FlutterSecureStorage();

    final dados = await _storage.read(key: _key);
    if (dados == null) return [];
    final json = jsonDecode(dados) as List;
    return json.map((e) => Conversa.fromJson(e)).toList();
  }
}
