/// Modelo representando um Feedback do voluntário.
/// Compatível tanto com armazenamento local quanto com backend Java.
class FeedbackModel {
  final String mensagem;
  final DateTime data;

  FeedbackModel({
    required this.mensagem,
    DateTime? data,
  }) : data = data ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'mensagem': mensagem,
        'data': data.toIso8601String(),
      };

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      mensagem: json['mensagem'] ?? '',
      data: DateTime.tryParse(json['data'] ?? '') ?? DateTime.now(),
    );
  }
}
