import 'instituicao_model.dart';

class VagaCandidatada {
  final int id;
  final String cargo;
  final String localidade;
  final String descricao;
  final List<String> especificacoes;
  final String tipoVaga;
  final String area;
  final String horario;
  final String tempoVoluntariado;
  final String disponibilidade;
  final Instituicao instituicao;
  final DateTime? dataCandidatura;
  final double? latitude;
  final double? longitude;
  final String? cidade;
  final String? status;

  const VagaCandidatada({
    required this.id,
    required this.cargo,
    required this.localidade,
    required this.descricao,
    required this.especificacoes,
    required this.tipoVaga,
    required this.area,
    required this.horario,
    required this.tempoVoluntariado,
    required this.disponibilidade,
    required this.instituicao,
    this.dataCandidatura,
    this.latitude,
    this.longitude,
    this.cidade,
    this.status,
  });

  factory VagaCandidatada.fromJson(Map<String, dynamic> json) {
    return VagaCandidatada(
      id: json['id'] ?? 0,
      cargo: json['cargo'] ?? '',
      localidade: json['localidade'] ?? '',
      descricao: json['descricao'] ?? '',
      especificacoes: List<String>.from(json['especificacoes'] ?? const []),
      tipoVaga: json['tipoVaga'] ?? '',
      area: json['area'] ?? '',
      horario: json['horario'] ?? '',
      tempoVoluntariado: json['tempoVoluntariado'] ?? '',
      disponibilidade: json['disponibilidade'] ?? '',
      instituicao: json['instituicao'] != null
          ? Instituicao.fromJson(json['instituicao'])
          : Instituicao(
              id: json['instituicaoId'] ?? 0,
              nome: json['instituicaoNome'] ?? ''),
      dataCandidatura: json['dataCandidatura'] != null
          ? DateTime.tryParse(json['dataCandidatura'])
          : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      cidade: json['cidade'],
      status: json['status'] ??
          json['situacao'] ??
          json['estado'] ??
          'Desconhecido',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cargo': cargo,
        'localidade': localidade,
        'descricao': descricao,
        'especificacoes': especificacoes,
        'tipoVaga': tipoVaga,
        'area': area,
        'horario': horario,
        'tempoVoluntariado': tempoVoluntariado,
        'disponibilidade': disponibilidade,
        'instituicao': instituicao.toJson(),
        'dataCandidatura': dataCandidatura?.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'cidade': cidade,
        'status': status,
      };
}
