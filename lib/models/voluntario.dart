class Voluntario {
  int? id;
  String? matricula;
  String? nome;
  String? cpf;
  DateTime? dataNascimento;
  String? genero;
  String? senha;
  String? avatarPath;

  List<String>? atividadeCEUB;
  String? emailInstitucional;
  String? emailParticular;
  String? celular;
  String? cidadeUF;
  String? horario;
  String? motivacao;
  List<String>? causas;
  List<String>? habilidades;
  List<String>? disponibilidadeSemanal;
  String? comentarios;

  Voluntario({
    this.id,
    this.matricula,
    this.nome,
    this.cpf,
    this.dataNascimento,
    this.genero,
    this.senha,
    this.atividadeCEUB,
    this.emailInstitucional,
    this.emailParticular,
    this.celular,
    this.cidadeUF,
    this.horario,
    this.motivacao,
    this.causas,
    this.habilidades,
    this.disponibilidadeSemanal,
    this.comentarios,
    this.avatarPath,
  });

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      id: json['id'],
      matricula: json['matricula'],
      nome: json['nome'],
      cpf: json['cpf'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
      genero: json['genero'],
      senha: json['senha'],
      atividadeCEUB:
          (json['atividadeCEUB'] as List?)?.map((e) => e.toString()).toList(),
      emailInstitucional: json['emailInstitucional'],
      emailParticular: json['emailParticular'],
      celular: json['celular'],
      cidadeUF: json['cidadeUF'],
      horario: json['horario'],
      motivacao: json['motivacao'],
      causas: (json['causas'] as List?)?.map((e) => e.toString()).toList(),
      habilidades:
          (json['habilidades'] as List?)?.map((e) => e.toString()).toList(),
      disponibilidadeSemanal: (json['disponibilidadeSemanal'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      comentarios: json['comentarios'],
      avatarPath: json['avatarPath'],
    );
  }

  Map<String, dynamic> toJsonCompleto() {
    return {
      'id': id,
      'matricula': matricula ?? '',
      'nome': nome ?? '',
      'cpf': cpf ?? '',
      'dataNascimento': dataNascimento?.toIso8601String(),
      'genero': genero ?? '',
      'atividadeCEUB': atividadeCEUB ?? [],
      'emailInstitucional': emailInstitucional ?? '',
      'emailParticular': emailParticular ?? '',
      'celular': celular ?? '',
      'cidadeUF': cidadeUF ?? '',
      'horario': horario ?? '',
      'motivacao': motivacao ?? '',
      'causas': causas ?? [],
      'habilidades': habilidades ?? [],
      'disponibilidadeSemanal': disponibilidadeSemanal ?? [],
      'comentarios': comentarios ?? '',
      'avatarPath': avatarPath ?? '',
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome ?? '',
    };
  }

  bool validarCamposObrigatorios() {
    return nome?.trim().isNotEmpty == true &&
        matricula?.trim().isNotEmpty == true &&
        cpf?.trim().isNotEmpty == true &&
        dataNascimento != null &&
        genero?.trim().isNotEmpty == true &&
        senha?.trim().isNotEmpty == true &&
        emailInstitucional?.trim().isNotEmpty == true &&
        celular?.trim().isNotEmpty == true &&
        cidadeUF?.trim().isNotEmpty == true &&
        atividadeCEUB != null &&
        atividadeCEUB!.isNotEmpty &&
        causas != null &&
        causas!.isNotEmpty &&
        habilidades != null &&
        habilidades!.isNotEmpty &&
        disponibilidadeSemanal != null &&
        disponibilidadeSemanal!.isNotEmpty;
  }
}
