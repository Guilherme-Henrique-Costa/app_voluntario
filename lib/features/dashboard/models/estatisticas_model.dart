/// Modelo de dados das estatísticas do voluntário.
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
      totalHoras: json['totalHoras'] ?? 0,
      vagasCompletadas: json['vagasCompletadas'] ?? 0,
      pontuacao: json['pontuacao'] ?? 0,
      evolucaoSemanal:
          (json['evolucaoSemanal'] as List?)?.map((e) => e as int).toList() ??
              [],
    );
  }
}
