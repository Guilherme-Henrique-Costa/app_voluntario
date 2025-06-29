import 'package:app_voluntario/servicos/vaga_instituicao_service.dart';
import 'package:flutter/material.dart';
import '../models/vaga_instituicao_model.dart';

class VagaInstituicaoProvider with ChangeNotifier {
  final VagaInstituicaoService _service = VagaInstituicaoService();
  List<VagaInstituicao> _vagas = [];
  bool _carregando = false;
  String? _erro;

  List<VagaInstituicao> get vagas => _vagas;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarVagasDisponiveis() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _vagas = await _service.listarVagasDisponiveis();
    } catch (e) {
      _erro = 'Erro ao carregar vagas';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
