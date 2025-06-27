class Voluntario {
  int? id;
  String? nome;
  String? celular;
  String? emailInstitucional;
  String? experiencia;
  String? avatarPath;

  Voluntario({
    this.nome,
    this.celular,
    this.emailInstitucional,
    this.experiencia,
    this.avatarPath,
  });

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      nome: json['nome'],
      celular: json['celular'],
      emailInstitucional: json['emailInstitucional'],
      experiencia: json['experiencia'],
      avatarPath: json['avatarPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'celular': celular,
      'emailInstitucional': emailInstitucional,
      'experiencia': experiencia,
      'avatarPath': avatarPath,
    };
  }
}
