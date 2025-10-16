import 'package:latlong2/latlong.dart';

/// Modelo que representa um compromisso (evento da agenda)
class EventoModel {
  final int? id;
  final String descricao;
  final String horario;
  final String status;
  final double? latitude;
  final double? longitude;
  final String? cidade;

  EventoModel({
    this.id,
    required this.descricao,
    required this.horario,
    required this.status,
    this.latitude,
    this.longitude,
    this.cidade,
  });

  /// Retorna o ponto (LatLng) se latitude/longitude estiverem disponíveis
  LatLng? get local => (latitude != null && longitude != null)
      ? LatLng(latitude!, longitude!)
      : null;

  /// Converte o modelo para JSON (para enviar à API)
  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'horario': horario,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'cidade': cidade,
      };

  /// Constrói um objeto EventoModel a partir do JSON da API
  factory EventoModel.fromJson(Map<String, dynamic> json) => EventoModel(
        id: json['id'],
        descricao: json['descricao'] ?? '',
        horario: json['horario'] ?? '',
        status: json['status'] ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        cidade: json['cidade'],
      );
}
