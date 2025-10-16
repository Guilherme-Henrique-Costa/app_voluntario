import 'package:flutter/material.dart';
import '../../../perfil/models/voluntario.dart';
import '../../../perfil/services/voluntario_service.dart';

class CadastroController {
  final formKey = GlobalKey<FormState>();

  // --- Controladores de texto ---
  final nomeController = TextEditingController();
  final matriculaController = TextEditingController();
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  final emailInstController = TextEditingController();
  final emailPartController = TextEditingController(); // agora opcional
  final celularController = TextEditingController();
  final cidadeController = TextEditingController();
  final motivacaoController = TextEditingController();
  final comentariosController = TextEditingController();

  // --- Campos auxiliares ---
  String? genero;
  DateTime? dataNascimento;
  TimeOfDay? horarioSelecionado;
  List<String> atividades = [];
  List<String> causas = [];
  List<String> habilidades = [];
  List<String> disponibilidade = [];

  // --- Opções fixas ---
  final opcoesDisponibilidade = const [
    "Segunda - Manhã",
    "Segunda - Tarde",
    "Segunda - Noite",
    "Terça - Manhã",
    "Terça - Tarde",
    "Terça - Noite",
    "Quarta - Manhã",
    "Quarta - Tarde",
    "Quarta - Noite",
    "Quinta - Manhã",
    "Quinta - Tarde",
    "Quinta - Noite",
    "Sexta - Manhã",
    "Sexta - Tarde",
    "Sexta - Noite",
    "Sábado - Manhã",
    "Sábado - Tarde",
    "Sábado - Noite",
    "Domingo - Manhã",
    "Domingo - Tarde",
    "Domingo - Noite"
  ];

  final opcoesCausas = const [
    "Educação",
    "Saúde",
    "Proteção Animal",
    "Meio Ambiente",
    "Idoso",
    "Pessoas com Deficiência",
    "Combate à Pobreza",
    "Defesa de Direitos",
    "Capacitação Profissional",
    "Participação Cidadã"
  ];

  final opcoesHabilidades = const [
    "Comunicação",
    "Idiomas",
    "Informática",
    "Gestão",
    "Dança/Música",
    "Educação",
    "Saúde/Psicologia"
  ];

  // ===========================================================
  // MÉTODO PRINCIPAL: ENVIO DO CADASTRO
  // ===========================================================
  Future<void> enviarCadastro(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final voluntario = Voluntario(
      nome: nomeController.text.trim(),
      matricula: matriculaController.text.trim(),
      cpf: cpfController.text.trim(),
      dataNascimento: dataNascimento,
      genero: genero,
      senha: senhaController.text.trim(),
      atividadeCEUB: atividades,
      emailInstitucional: emailInstController.text.trim(),
      emailParticular: emailPartController.text.trim().isEmpty
          ? null
          : emailPartController.text.trim(), // agora opcional
      celular: celularController.text.trim(),
      cidadeUF: cidadeController.text.trim(),
      horario: horarioSelecionado?.format(context),
      motivacao: motivacaoController.text.trim(),
      causas: causas,
      habilidades: habilidades,
      disponibilidadeSemanal: disponibilidade,
      comentarios: comentariosController.text.trim(),
    );

    final sucesso = await VoluntarioService().cadastrarVoluntario(voluntario);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Cadastro realizado com sucesso!'
              : 'Erro ao cadastrar voluntário.',
        ),
        backgroundColor: sucesso ? Colors.green : Colors.red,
      ),
    );

    if (sucesso) Navigator.pop(context);
  }

  // ===========================================================
  // CAMPOS DE FORMULÁRIO (Widgets)
  // ===========================================================

  /// Campo de seleção de gênero
  Widget campoGenero() {
    final generos = ["Feminino", "Masculino", "Prefiro não declarar"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: generos
          .map(
            (g) => RadioListTile<String>(
              title: Text(g, style: const TextStyle(color: Colors.white)),
              value: g,
              groupValue: genero,
              activeColor: Colors.amber,
              onChanged: (v) => genero = v,
            ),
          )
          .toList(),
    );
  }

  /// Campo de data de nascimento
  Widget campoData(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final data = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (data != null) dataNascimento = data;
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: dataNascimento != null
                ? "${dataNascimento!.day}/${dataNascimento!.month}/${dataNascimento!.year}"
                : '',
          ),
          decoration: const InputDecoration(
            labelText: "Data de Nascimento",
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white24,
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (_) =>
              dataNascimento == null ? 'Selecione uma data' : null,
        ),
      ),
    );
  }

  /// Campo de horário preferencial
  Widget campoHorario(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final h = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (h != null) horarioSelecionado = h;
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: horarioSelecionado?.format(context) ?? '',
          ),
          decoration: const InputDecoration(
            labelText: "Horário preferencial",
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white24,
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (_) =>
              horarioSelecionado == null ? 'Selecione um horário' : null,
        ),
      ),
    );
  }
}
