class Voluntario {
  final String? nome;
  final String? celular;
  final String? emailInstitucional;
  final String? experiencia;

  Voluntario({
    this.nome,
    this.celular,
    this.emailInstitucional,
    this.experiencia,
  });

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      nome: json['nome'],
      celular: json['celular'],
      emailInstitucional: json['emailInstitucional'],
      experiencia: json['experiencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'celular': celular,
      'emailInstitucional': emailInstitucional,
      'experiencia': experiencia,
    };
  }
}
