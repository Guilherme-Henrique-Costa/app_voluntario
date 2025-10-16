import 'package:flutter/foundation.dart';
import '../models/evento_model.dart';
import '../services/evento_api_service.dart';

/// Controller que coordena a comunicação entre a UI e o backend.
/// Ele faz chamadas à API via [EventoApiService].
class EventoController with ChangeNotifier {
  List<EventoModel> _eventos = [];
  bool _carregando = false;

  List<EventoModel> get eventos => _eventos;
  bool get carregando => _carregando;

  /// Busca todos os eventos no backend
  Future<void> carregarEventos() async {
    _carregando = true;
    notifyListeners();
    try {
      _eventos = await EventoApiService.buscarTodos();
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Adiciona um novo evento
  Future<void> adicionarEvento(EventoModel evento) async {
    await EventoApiService.salvar(evento);
    await carregarEventos(); // recarrega lista atualizada
  }

  /// Atualiza um evento existente
  Future<void> atualizarEvento(EventoModel evento) async {
    await EventoApiService.atualizar(evento);
    await carregarEventos();
  }

  /// Remove um evento pelo ID
  Future<void> removerEvento(int id) async {
    await EventoApiService.excluir(id);
    await carregarEventos();
  }
}
