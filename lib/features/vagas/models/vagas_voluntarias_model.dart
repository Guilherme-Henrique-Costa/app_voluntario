import 'dart:convert';
import 'vaga_instituicao_model.dart';
import '../../perfil/models/voluntario.dart';

class VagasVoluntarias {
  final int id;
  final VagaInstituicao vaga;
  final Voluntario? voluntario;
  final DateTime dataCandidatura;

  VagasVoluntarias({
    required this.id,
    required this.vaga,
    required this.dataCandidatura,
    this.voluntario,
  });

  factory VagasVoluntarias.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("JSON nulo para VagasVoluntarias");

    final vagaJson = json['vaga'];
    if (vagaJson == null) throw Exception("Vaga nula em VagasVoluntarias");

    return VagasVoluntarias(
      id: json['id'] ?? 0,
      vaga: VagaInstituicao.fromJson(vagaJson),
      voluntario: json['voluntario'] != null
          ? Voluntario.fromJson(json['voluntario'])
          : null,
      dataCandidatura: json['dataCandidatura'] != null
          ? DateTime.parse(json['dataCandidatura'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vaga': vaga.toJson(),
        'voluntario': voluntario?.toJson(),
        'dataCandidatura': dataCandidatura.toIso8601String(),
      };
}
