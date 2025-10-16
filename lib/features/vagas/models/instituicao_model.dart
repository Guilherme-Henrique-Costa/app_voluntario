class Instituicao {
  final int id;
  final String nome;

  const Instituicao({
    required this.id,
    required this.nome,
  });

  factory Instituicao.fromJson(Map<String, dynamic> json) {
    return Instituicao(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
      };

  @override
  String toString() => 'Instituicao(id: $id, nome: $nome)';
}
