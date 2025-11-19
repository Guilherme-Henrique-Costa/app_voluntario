class Conquista {
  final String titulo;
  final String categoria;
  final double progresso;
  final String descricao;
  final bool concluido;

  const Conquista({
    required this.titulo,
    required this.categoria,
    required this.progresso,
    required this.descricao,
    required this.concluido,
  });

  /// Cria uma instância de [Conquista] a partir de um mapa JSON.
  factory Conquista.fromJson(Map<String, dynamic> json) {
    return Conquista(
      titulo: json['titulo'] ?? '',
      categoria: json['categoria'] ?? '',
      progresso: (json['progresso'] is num)
          ? (json['progresso'] as num).toDouble()
          : 0.0,
      descricao: json['descricao'] ?? '',
      concluido: json['concluido'] ?? false,
    );
  }

  /// Converte a instância atual em um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'progresso': progresso,
      'descricao': descricao,
      'concluido': concluido,
    };
  }

  /// Cria uma cópia da instância com novos valores opcionais.
  Conquista copyWith({
    String? titulo,
    String? categoria,
    double? progresso,
    String? descricao,
    bool? concluido,
  }) {
    return Conquista(
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      progresso: progresso ?? this.progresso,
      descricao: descricao ?? this.descricao,
      concluido: concluido ?? this.concluido,
    );
  }

  /// String formatada para logs/debug.
  @override
  String toString() {
    return 'Conquista(titulo: $titulo, categoria: $categoria, progresso: $progresso, concluido: $concluido)';
  }

  /// Compara duas conquistas pelo valor de seus atributos.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conquista &&
        other.titulo == titulo &&
        other.categoria == categoria &&
        other.progresso == progresso &&
        other.descricao == descricao &&
        other.concluido == concluido;
  }

  @override
  int get hashCode =>
      Object.hash(titulo, categoria, progresso, descricao, concluido);
}
