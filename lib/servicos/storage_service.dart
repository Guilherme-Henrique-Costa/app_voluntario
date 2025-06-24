import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/voluntario.dart';

class StorageService {
  static const String _key = 'voluntario_logado';
  static const _storage = FlutterSecureStorage();

  static Future<void> salvarVoluntario(Voluntario voluntario) async {
    final json = jsonEncode(voluntario.toJson());
    await _storage.write(key: _key, value: json);
  }

  static Future<Voluntario?> obterVoluntario() async {
    final json = await _storage.read(key: _key);
    if (json != null) {
      return Voluntario.fromJson(jsonDecode(json));
    }
    return null;
  }

  static Future<void> removerVoluntario() async {
    await _storage.delete(key: _key);
  }
}
