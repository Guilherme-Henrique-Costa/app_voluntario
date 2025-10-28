import 'package:flutter/material.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:app_voluntario/core/errors/error_handler.dart';
import 'package:app_voluntario/features/recomendacoes/models/recomendacao_model.dart';
import 'package:app_voluntario/features/recomendacoes/services/recomendacao_service.dart';

class TelaInicialController extends ChangeNotifier {
  // ===================== VARIÁVEIS =====================

  String? _nomeUsuario;
  List<RecomendacaoModel> _recomendacoes = [];
  bool _carregando = false;
  String? _erro;
  bool _inicializado = false;

  // ===================== GETTERS =====================

  String? get nomeUsuario => _nomeUsuario;
  List<RecomendacaoModel> get recomendacoes => _recomendacoes;
  bool get carregando => _carregando;
  String? get erro => _erro;

  // ===================== INICIALIZAÇÃO =====================

  /// Inicializa os dados principais da tela.
  /// Garante que só será executado uma vez.
  Future<void> inicializar(BuildContext context) async {
    if (_inicializado) return;
    _inicializado = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        carregarUsuario(),
        carregarRecomendacoes(context),
      ]);
    });
  }

  // ===================== MÉTODOS PRINCIPAIS =====================

  /// Obtém o nome do usuário armazenado localmente.
  Future<void> carregarUsuario() async {
    final nome = await StorageService.getUserName();
    _nomeUsuario = nome ?? 'Voluntário';
    notifyListeners();
  }

  /// Busca recomendações personalizadas do backend.
  Future<void> carregarRecomendacoes(BuildContext context) async {
    try {
      _carregando = true;
      _erro = null;
      notifyListeners();

      final voluntario = await StorageService.obterAtual();

      if (voluntario == null || voluntario.id == null) {
        _erro = 'Usuário não encontrado.';
        notifyListeners();
        return;
      }

      debugPrint(
          '🔍 Buscando recomendações para voluntário ID: ${voluntario.id}');

      final lista =
          await RecomendacaoService().buscarRecomendacoes(voluntario.id!);

      _recomendacoes = lista;
      debugPrint('✅ Recebidas ${lista.length} recomendações');
    } catch (e, s) {
      _erro = 'Erro ao carregar recomendações.';
      debugPrint('❌ Erro em carregarRecomendacoes: $e');
      ErrorHandler.show(context, e, stack: s);
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Recarrega todos os dados (ex: usado em RefreshIndicator)
  Future<void> recarregar(BuildContext context) async {
    await Future.wait([
      carregarUsuario(),
      carregarRecomendacoes(context),
    ]);
  }

  /// Limpa mensagens de erro (ex: após sucesso)
  void limparErro() {
    _erro = null;
    notifyListeners();
  }
}
