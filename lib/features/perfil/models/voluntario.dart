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

  /// 🧩 Cria o objeto a partir de um JSON vindo da API
  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      id: json['id'],
      matricula: json['matricula'],
      nome: json['nome'],
      cpf: json['cpf'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.tryParse(json['dataNascimento'])
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

  /// 🔄 Converte o objeto completo para JSON
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
      'emailParticular': emailParticular ?? '', // opcional
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

  /// 🧠 JSON resumido (para uso em listas ou cache leve)
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome ?? '',
      };

  /// ✅ Validação dos campos obrigatórios
  bool validarCamposObrigatorios() {
    final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    const idadeMinima = 16;

    final idadeValida = dataNascimento != null
        ? DateTime.now().difference(dataNascimento!).inDays ~/ 365 >=
            idadeMinima
        : false;

    return _campoPreenchido(nome) &&
        _campoPreenchido(matricula) &&
        _campoPreenchido(cpf) &&
        cpfRegex.hasMatch(cpf ?? '') &&
        idadeValida &&
        _campoPreenchido(genero) &&
        _senhaValida(senha) &&
        _emailValido(emailInstitucional, emailRegex) &&
        _campoPreenchido(celular) &&
        _campoPreenchido(cidadeUF) &&
        _listaValida(atividadeCEUB) &&
        _listaValida(causas) &&
        _listaValida(habilidades) &&
        _listaValida(disponibilidadeSemanal);
  }

  /// --- 🔽 Métodos utilitários privados (ajudam a manter o código limpo) ---

  bool _campoPreenchido(String? valor) =>
      valor != null && valor.trim().isNotEmpty;

  bool _listaValida(List<String>? lista) => lista != null && lista.isNotEmpty;

  bool _emailValido(String? email, RegExp regex) =>
      _campoPreenchido(email) && regex.hasMatch(email ?? '');

  bool _senhaValida(String? senha) => senha != null && senha.trim().length >= 6;
}
