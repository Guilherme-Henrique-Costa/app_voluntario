import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/feedback.dart';

class FeedbackService {
  static const _key = 'feedback_list';
  static final _storage = FlutterSecureStorage();

  static Future<void> salvarFeedback(FeedbackModel feedback) async {
    final dados = await _storage.read(key: _key);
    final lista =
        dados != null ? List<Map<String, dynamic>>.from(jsonDecode(dados)) : [];
    lista.add(feedback.toJson());
    await _storage.write(key: _key, value: jsonEncode(lista));
  }

  static Future<List<FeedbackModel>> listarFeedbacks() async {
    final dados = await _storage.read(key: _key);
    if (dados == null) return [];
    final lista = List<Map<String, dynamic>>.from(jsonDecode(dados));
    return lista.map((e) => FeedbackModel.fromJson(e)).toList();
  }
}
