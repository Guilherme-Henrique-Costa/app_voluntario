import 'instituicao_model.dart';

class VagaInstituicao {
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
  final DateTime? data;
  final double? latitude;
  final double? longitude;

  const VagaInstituicao({
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
    this.data,
    this.latitude,
    this.longitude,
  });

  factory VagaInstituicao.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("JSON de VagaInstituicao é nulo");

    return VagaInstituicao(
      id: json['id'] ?? 0,
      cargo: json['cargo'] ?? '',
      localidade: json['localidade'] ?? '',
      descricao: json['descricao'] ?? '',
      especificacoes: (json['especificacoes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tipoVaga: json['tipoVaga'] ?? '',
      area: json['area'] ?? '',
      horario: json['horario'] ?? '',
      tempoVoluntariado: json['tempoVoluntariado'] ?? '',
      disponibilidade: json['disponibilidade'] ?? '',
      instituicao: json['instituicao'] != null
          ? Instituicao.fromJson(json['instituicao'])
          : Instituicao(id: 0, nome: ''),
      data: json['data'] != null
          ? DateTime.tryParse(json['data'])
          : (json['dataCandidatura'] != null
              ? DateTime.tryParse(json['dataCandidatura'])
              : null),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
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
        'data': data?.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
      };
}
