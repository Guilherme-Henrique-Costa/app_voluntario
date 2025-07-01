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
  final String? token;

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
    this.token,
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
      token: json['token'],
    );
  }

  Map<String, dynamic> toJsonCompleto() {
    return {
      'id': id,
      'matricula': matricula ?? '',
      'nome': nome ?? '',
      'cpf': cpf ?? '',
      'dataNascimento':
          dataNascimento != null ? dataNascimento!.toIso8601String() : '',
      'genero': genero ?? '',
      'senha': senha ?? '',
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
    final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}\$');
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}\$');
    final idadeMinima = 16;

    final idadeValida = dataNascimento != null
        ? DateTime.now().difference(dataNascimento!).inDays ~/ 365 >=
            idadeMinima
        : false;

    return nome?.trim().isNotEmpty == true &&
        matricula?.trim().isNotEmpty == true &&
        cpf?.trim().isNotEmpty == true &&
        cpfRegex.hasMatch(cpf!) &&
        idadeValida &&
        genero?.trim().isNotEmpty == true &&
        senha != null &&
        senha!.trim().length >= 6 &&
        emailInstitucional?.trim().isNotEmpty == true &&
        emailRegex.hasMatch(emailInstitucional!) &&
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
