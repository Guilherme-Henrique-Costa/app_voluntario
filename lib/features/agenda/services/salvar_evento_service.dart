import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

/// Serviço para salvar e recuperar eventos da agenda localmente.
///
/// Usa o FlutterSecureStorage para persistência local segura.
class EventoService {
  static const _keyEventos = 'eventos_agenda';
  static final _storage = FlutterSecureStorage();

  /// Salva um novo evento na agenda.
  ///
  /// [dia] é a data do evento (usada como chave de agrupamento)
  /// [evento] é um Map com os campos: descrição, horário, status, cidade, latitude e longitude.
  Future<void> adicionarEvento(
      DateTime dia, Map<String, dynamic> evento) async {
    final dataFormatada =
        dia.toIso8601String().split('T').first; // apenas yyyy-MM-dd
    final dados = await _storage.read(key: _keyEventos);

    // Recupera os eventos existentes
    Map<String, List<Map<String, dynamic>>> agenda = {};
    if (dados != null) {
      final decoded = jsonDecode(dados);
      agenda = Map<String, List<Map<String, dynamic>>>.from(
        decoded.map((key, value) => MapEntry(
              key,
              List<Map<String, dynamic>>.from(value),
            )),
      );
    }

    // Adiciona o novo evento no dia correspondente
    agenda.putIfAbsent(dataFormatada, () => []);
    agenda[dataFormatada]!.add(evento);

    // Persiste a agenda atualizada
    await _storage.write(key: _keyEventos, value: jsonEncode(agenda));
  }

  /// Retorna todos os eventos salvos.
  Future<Map<String, List<Map<String, dynamic>>>> listarEventos() async {
    final dados = await _storage.read(key: _keyEventos);
    if (dados == null) return {};
    final decoded = jsonDecode(dados);
    return Map<String, List<Map<String, dynamic>>>.from(
      decoded.map((key, value) => MapEntry(
            key,
            List<Map<String, dynamic>>.from(value),
          )),
    );
  }

  /// Remove todos os eventos (usado para testes ou reset).
  Future<void> limparEventos() async {
    await _storage.delete(key: _keyEventos);
  }
}
