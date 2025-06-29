// lib/servicos/chat_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mensagem_model.dart';

class ChatApiService {
  static const String baseUrl =
      'http://192.168.15.5:8080/api/v1/mensagem-voluntaria';

  static Future<List<Mensagem>> buscarMensagensPorVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$baseUrl/voluntario/$voluntarioId/mensagens');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((json) => Mensagem.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar mensagens: ${response.statusCode}');
    }
  }

  static Future<void> enviarMensagem(Mensagem mensagem) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mensagem.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao enviar mensagem: ${response.statusCode}');
    }
  }
}
