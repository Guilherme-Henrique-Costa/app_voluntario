import 'dart:convert';

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

  VagaInstituicao({
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
  });

  factory VagaInstituicao.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("JSON de VagaInstituicao está nulo");
    }

    return VagaInstituicao(
      id: json['id'] ?? 0,
      cargo: json['cargo'] ?? '',
      localidade: json['localidade'] ?? '',
      descricao: json['descricao'] ?? '',
      especificacoes: (json['especificacoes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}

class Instituicao {
  final int id;
  final String nome;

  Instituicao({required this.id, required this.nome});

  factory Instituicao.fromJson(Map<String, dynamic> json) {
    return Instituicao(
      id: json['id'],
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
