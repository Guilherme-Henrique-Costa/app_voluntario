import 'package:flutter/foundation.dart';

/// 🧠 Modelo principal de recomendações personalizadas
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

  const RecomendacaoModel({
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

  /// 🧩 Construtor a partir do JSON retornado pela API
  factory RecomendacaoModel.fromJson(Map<String, dynamic> json) {
    return RecomendacaoModel(
      id: json['id'] ?? 0,
      cargo: json['cargo'] ?? 'Cargo não informado',
      descricao: json['descricao'] ?? 'Sem descrição disponível',
      localidade: json['localidade'] ?? 'Local não especificado',
      instituicao: json['instituicao']?['nome'] ?? 'Instituição não informada',
      tipoVaga: json['tipoVaga'] ?? 'Tipo de vaga não informado',
      area: json['area'] ?? 'Área não informada',
      disponibilidade:
          json['disponibilidade'] ?? 'Disponibilidade não informada',
      status: json['status'] ?? 'Status desconhecido',

      /// Vagas recomendadas
      vagasRecomendadas: (json['vagasRecomendadas'] as List?)
              ?.map((v) => VagaRecomendada.fromJson(v))
              .toList() ??
          [
            VagaRecomendada(
              id: json['id'] ?? 0,
              titulo: json['cargo'] ?? 'Sem título',
              causa: json['area'] ?? 'Não informada',
              localidade: json['localidade'] ?? 'Local não especificado',
            ),
          ],

      /// Recompensas próximas
      recompensasProximas: (json['recompensasProximas'] as List?)
              ?.map((r) => RecompensaProxima.fromJson(r))
              .toList() ??
          const [],

      /// Causas mais engajadas
      causasMaisEngajadas: (json['causasMaisEngajadas'] as List?)
              ?.map((c) => CausaEngajada.fromJson(c))
              .toList() ??
          const [],
    );
  }
}

/// 💼 Representa uma vaga recomendada ao voluntário
class VagaRecomendada {
  final int id;
  final String titulo;
  final String causa;
  final String localidade;

  const VagaRecomendada({
    required this.id,
    required this.titulo,
    required this.causa,
    required this.localidade,
  });

  factory VagaRecomendada.fromJson(Map<String, dynamic> json) {
    return VagaRecomendada(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sem título',
      causa: json['causa'] ?? 'Causa não informada',
      localidade: json['localidade'] ?? 'Local não especificado',
    );
  }
}

/// 🏅 Representa o progresso de uma recompensa que o voluntário está próximo de atingir
class RecompensaProxima {
  final String titulo;
  final int progresso; // 0–100

  const RecompensaProxima({
    required this.titulo,
    required this.progresso,
  });

  factory RecompensaProxima.fromJson(Map<String, dynamic> json) {
    return RecompensaProxima(
      titulo: json['titulo'] ?? 'Recompensa sem nome',
      progresso: (json['progresso'] ?? 0).clamp(0, 100),
    );
  }
}

/// ❤️ Representa uma causa na qual o voluntário mais se engajou
class CausaEngajada {
  final String causa;
  final int participacoes;

  const CausaEngajada({
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
