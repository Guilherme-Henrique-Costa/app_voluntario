import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/feedback_model.dart';

/// Serviço responsável por salvar e listar feedbacks localmente.
/// Posteriormente pode ser adaptado para integrar ao backend Java.
class FeedbackService {
  static const _key = 'feedback_list';
  static final _storage = FlutterSecureStorage();

  /// Salva um novo feedback na lista local
  static Future<void> salvarFeedback(FeedbackModel feedback) async {
    final dados = await _storage.read(key: _key);
    final lista = dados != null
        ? List<Map<String, dynamic>>.from(jsonDecode(dados))
        : <Map<String, dynamic>>[];

    lista.add(feedback.toJson());
    await _storage.write(key: _key, value: jsonEncode(lista));
  }

  /// Lista todos os feedbacks armazenados localmente
  static Future<List<FeedbackModel>> listarFeedbacks() async {
    final dados = await _storage.read(key: _key);
    if (dados == null) return [];
    final lista = List<Map<String, dynamic>>.from(jsonDecode(dados));
    return lista.map((e) => FeedbackModel.fromJson(e)).toList();
  }
}
