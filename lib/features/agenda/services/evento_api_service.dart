import 'dart:convert';
import 'package:app_voluntario/core/constants/api.dart';
import 'package:http/http.dart' as http;
import '../models/evento_model.dart';

/// Serviço responsável por fazer requisições HTTP ao backend Java
class EventoApiService {
  static const String _endpoint = ApiEndpoints.eventos;

  /// Busca todos os eventos cadastrados
  static Future<List<EventoModel>> buscarTodos() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List lista = jsonDecode(response.body);
      return lista.map((e) => EventoModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar eventos: ${response.statusCode}');
    }
  }

  /// Busca um evento específico pelo ID
  static Future<EventoModel?> buscarPorId(int id) async {
    final response = await http.get(Uri.parse('$_endpoint/$id'));
    if (response.statusCode == 200) {
      return EventoModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Cadastra um novo evento
  static Future<void> salvar(EventoModel evento) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao salvar evento: ${response.body}');
    }
  }

  /// Atualiza um evento existente
  static Future<void> atualizar(EventoModel evento) async {
    if (evento.id == null) {
      throw Exception('ID do evento é obrigatório para atualização.');
    }

    final response = await http.put(
      Uri.parse('$_endpoint/${evento.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar evento: ${response.body}');
    }
  }

  /// Exclui um evento pelo ID
  static Future<void> excluir(int id) async {
    final response = await http.delete(Uri.parse('$_endpoint/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao excluir evento: ${response.body}');
    }
  }
}
