import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mensagem_model.dart';
import '../../../core/constants/api.dart'; // Importa baseUrl centralizado

class ChatApiService {
  static final String _chatUrl = '$baseUrl/mensagem-voluntaria';

  static Future<List<Mensagem>> buscarMensagensPorVoluntario(
      int voluntarioId) async {
    final url = Uri.parse('$_chatUrl/voluntario/$voluntarioId/mensagens');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((json) => Mensagem.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar mensagens: ${response.statusCode}');
    }
  }

  static Future<void> enviarMensagem(Mensagem mensagem) async {
    final url = Uri.parse(_chatUrl);
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
