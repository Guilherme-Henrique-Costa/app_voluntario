class RecomendacaoModel {
  final List<VagaRecomendada> vagasRecomendadas;
  final List<RecompensaProxima> recompensasProximas;
  final List<CausaEngajada> causasMaisEngajadas;

  RecomendacaoModel({
    required this.vagasRecomendadas,
    required this.recompensasProximas,
    required this.causasMaisEngajadas,
  });

  factory RecomendacaoModel.fromJson(Map<String, dynamic> json) {
    return RecomendacaoModel(
      vagasRecomendadas: (json['vagasRecomendadas'] as List)
          .map((e) => VagaRecomendada.fromJson(e))
          .toList(),
      recompensasProximas: (json['recompensasProximas'] as List)
          .map((e) => RecompensaProxima.fromJson(e))
          .toList(),
      causasMaisEngajadas: (json['causasMaisEngajadas'] as List)
          .map((e) => CausaEngajada.fromJson(e))
          .toList(),
    );
  }
}

class VagaRecomendada {
  final int id;
  final String titulo;
  final String causa;
  final String localidade;

  VagaRecomendada({
    required this.id,
    required this.titulo,
    required this.causa,
    required this.localidade,
  });

  factory VagaRecomendada.fromJson(Map<String, dynamic> json) {
    return VagaRecomendada(
      id: json['id'],
      titulo: json['titulo'],
      causa: json['causa'],
      localidade: json['localidade'],
    );
  }
}

class RecompensaProxima {
  final String titulo;
  final int progresso; // 0 a 100

  RecompensaProxima({
    required this.titulo,
    required this.progresso,
  });

  factory RecompensaProxima.fromJson(Map<String, dynamic> json) {
    return RecompensaProxima(
      titulo: json['titulo'],
      progresso: json['progresso'],
    );
  }
}

class CausaEngajada {
  final String causa;
  final int participacoes;

  CausaEngajada({
    required this.causa,
    required this.participacoes,
  });

  factory CausaEngajada.fromJson(Map<String, dynamic> json) {
    return CausaEngajada(
      causa: json['causa'],
      participacoes: json['participacoes'],
    );
  }
}
