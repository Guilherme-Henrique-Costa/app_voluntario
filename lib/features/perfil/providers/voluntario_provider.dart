import 'package:flutter/material.dart';
import '../models/voluntario.dart';

/// Provider global para gerenciar o estado do voluntário logado.
class VoluntarioProvider with ChangeNotifier {
  Voluntario? _voluntario;

  Voluntario? get voluntario => _voluntario;

  /// Define o voluntário atual
  void setVoluntario(Voluntario voluntario) {
    _voluntario = voluntario;
    notifyListeners();
  }

  /// Remove o voluntário da sessão
  void logout() {
    _voluntario = null;
    notifyListeners();
  }
}
