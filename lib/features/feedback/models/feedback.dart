class FeedbackModel {
  final String mensagem;
  final DateTime data;

  FeedbackModel({required this.mensagem, DateTime? data})
      : this.data = data ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'mensagem': mensagem,
        'data': data.toIso8601String(),
      };

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      mensagem: json['mensagem'],
      data: DateTime.parse(json['data']),
    );
  }
}
