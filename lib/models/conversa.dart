class Conversa {
  final String nomeInstituicao;
  final String ultimaMensagem;
  final DateTime data;
  final bool lido;

  Conversa({
    required this.nomeInstituicao,
    required this.ultimaMensagem,
    required this.data,
    this.lido = false,
  });

  Map<String, dynamic> toJson() => {
        'nomeInstituicao': nomeInstituicao,
        'ultimaMensagem': ultimaMensagem,
        'data': data.toIso8601String(),
        'lido': lido,
      };

  factory Conversa.fromJson(Map<String, dynamic> json) => Conversa(
        nomeInstituicao: json['nomeInstituicao'],
        ultimaMensagem: json['ultimaMensagem'],
        data: DateTime.parse(json['data']),
        lido: json['lido'] ?? false,
      );
}
