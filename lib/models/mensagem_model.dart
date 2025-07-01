class Mensagem {
  final String texto;
  final bool ehUsuario;
  final DateTime data;
  final int voluntarioId;
  final String voluntarioNome;

  Mensagem({
    required this.texto,
    required this.ehUsuario,
    required this.data,
    required this.voluntarioId,
    required this.voluntarioNome,
  });

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    return Mensagem(
      texto: json['mensagemVoluntario'] ?? '',
      ehUsuario: json['ehUsuario'] ?? false,
      data: DateTime.parse(json['dataHora']),
      voluntarioId: json['voluntario']['id'],
      voluntarioNome: json['voluntarioNome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensagemVoluntario': texto,
      'ehUsuario': ehUsuario,
      'dataHora': data.toIso8601String(),
      'voluntario': {'id': voluntarioId},
      'voluntarioNome': voluntarioNome,
    };
  }
}
