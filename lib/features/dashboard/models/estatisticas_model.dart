class EstatisticasModel {
  final int totalHoras;
  final int vagasCompletadas;
  final int pontuacao;
  final List<int> evolucaoSemanal;

  EstatisticasModel({
    required this.totalHoras,
    required this.vagasCompletadas,
    required this.pontuacao,
    required this.evolucaoSemanal,
  });

  factory EstatisticasModel.fromJson(Map<String, dynamic> json) {
    return EstatisticasModel(
      totalHoras: json['totalHoras'],
      vagasCompletadas: json['vagasCompletadas'],
      pontuacao: json['pontuacao'],
      evolucaoSemanal: List<int>.from(json['evolucaoSemanal']),
    );
  }
}
