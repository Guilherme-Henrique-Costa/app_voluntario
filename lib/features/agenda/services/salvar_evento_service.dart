import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EventoService {
  static const _chaveEventos = 'eventos_agenda';

  static Future<Map<DateTime, List<Map<String, dynamic>>>>
      carregarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chaveEventos);
    if (jsonString == null) return {};

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((dataStr, listaEventos) {
      final data = DateTime.parse(dataStr);
      final eventos = (listaEventos as List).cast<Map<String, dynamic>>();
      return MapEntry(data, eventos);
    });
  }

  static Future<void> salvarEventos(
      Map<DateTime, List<Map<String, dynamic>>> eventos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap =
        eventos.map((data, lista) => MapEntry(data.toIso8601String(), lista));
    final jsonString = json.encode(jsonMap);
    await prefs.setString(_chaveEventos, jsonString);
  }

  Future<void> adicionarEvento(
      DateTime dia, Map<String, dynamic> evento) async {
    final eventos = await EventoService.carregarEventos();
    eventos.putIfAbsent(dia, () => []);
    eventos[dia]!.add(evento);
    await EventoService.salvarEventos(eventos);
  }

  Future<void> deletarEvento(DateTime dia, int index) async {
    final eventos = await EventoService.carregarEventos();
    if (eventos.containsKey(dia)) {
      eventos[dia]!.removeAt(index);
      if (eventos[dia]!.isEmpty) {
        eventos.remove(dia);
      }
      await EventoService.salvarEventos(eventos);
    }
  }
}
