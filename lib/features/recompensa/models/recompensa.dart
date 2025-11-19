class Recompensa {
  final String titulo;
  final String descricao;
  final DateTime data;

  const Recompensa({
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  factory Recompensa.fromJson(Map<String, dynamic> json) {
    return Recompensa(
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      data: DateTime.tryParse(json['data'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
    };
  }

  Recompensa copyWith({
    String? titulo,
    String? descricao,
    DateTime? data,
  }) {
    return Recompensa(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'Recompensa(titulo: $titulo, descricao: $descricao, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recompensa &&
        other.titulo == titulo &&
        other.descricao == descricao &&
        other.data == data;
  }

  @override
  int get hashCode => Object.hash(titulo, descricao, data);
}
