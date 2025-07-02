import 'package:flutter/material.dart';
import '../models/voluntario.dart';

class VoluntarioProvider with ChangeNotifier {
  Voluntario? _voluntario;

  Voluntario? get voluntario => _voluntario;

  void setVoluntario(Voluntario v) {
    _voluntario = v;
    notifyListeners();
  }

  void logout() {
    _voluntario = null;
    notifyListeners();
  }
}
