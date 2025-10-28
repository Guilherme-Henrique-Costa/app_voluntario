class RecomendacaoModel {
  final int id;
  final String cargo;
  final String descricao;
  final String localidade;
  final String instituicao;
  final String tipoVaga;
  final String area;
  final String disponibilidade;
  final String status;
  final List<VagaRecomendada> vagasRecomendadas;
  final List<RecompensaProxima> recompensasProximas;
  final List<CausaEngajada> causasMaisEngajadas;

  RecomendacaoModel({
    required this.id,
    required this.cargo,
    required this.descricao,
    required this.localidade,
    required this.instituicao,
    required this.tipoVaga,
    required this.area,
    required this.disponibilidade,
    required this.status,
    required this.vagasRecomendadas,
    required this.recompensasProximas,
    required this.causasMaisEngajadas,
  });

  factory RecomendacaoModel.fromJson(Map<String, dynamic> json) {
    return RecomendacaoModel(
      id: json['id'] ?? 0,
      cargo: json['cargo'] ?? '',
      descricao: json['descricao'] ?? '',
      localidade: json['localidade'] ?? '',
      instituicao: json['instituicao'] != null
          ? json['instituicao']['nome'] ?? ''
          : 'Instituição não informada',
      tipoVaga: json['tipoVaga'] ?? '',
      area: json['area'] ?? '',
      disponibilidade: json['disponibilidade'] ?? '',
      status: json['status'] ?? '',
      vagasRecomendadas: [
        VagaRecomendada(
          id: json['id'] ?? 0,
          titulo: json['cargo'] ?? 'Sem título',
          causa: json['area'] ?? 'Não informada',
          localidade: json['localidade'] ?? 'Local não especificado',
        )
      ],
      recompensasProximas: const [],
      causasMaisEngajadas: const [],
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
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sem título',
      causa: json['causa'] ?? 'Não informada',
      localidade: json['localidade'] ?? 'Local não especificado',
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
      titulo: json['titulo'] ?? 'Recompensa sem nome',
      progresso: json['progresso'] ?? 0,
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
      causa: json['causa'] ?? 'Causa desconhecida',
      participacoes: json['participacoes'] ?? 0,
    );
  }
}
