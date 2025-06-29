import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/voluntario.dart';
import '../../servicos/voluntario_service.dart';

class TelaCadastroVoluntario extends StatefulWidget {
  @override
  _TelaCadastroVoluntarioState createState() => _TelaCadastroVoluntarioState();
}

class _TelaCadastroVoluntarioState extends State<TelaCadastroVoluntario> {
  final _formKey = GlobalKey<FormState>();
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _celFormatter = MaskTextInputFormatter(mask: '(##) #####-####');
  final _matriculaFormatter = MaskTextInputFormatter(mask: '########');

  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _emailInstController = TextEditingController();
  final _emailPartController = TextEditingController();
  final _celularController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _motivacaoController = TextEditingController();
  final _comentariosController = TextEditingController();

  DateTime? _dataNascimento;
  TimeOfDay? _horarioSelecionado;
  String? genero;

  List<String> atividades = [];
  List<String> causas = [];
  List<String> habilidades = [];
  List<String> disponibilidade = [];

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) setState(() => _dataNascimento = data);
  }

  Future<void> _selecionarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horario != null) setState(() => _horarioSelecionado = horario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade300,
                  Colors.deepPurple.shade900
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text("Cadastro de Voluntário",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      SizedBox(height: 24),
                      _tituloSessao("Informações Pessoais"),
                      _campoTexto("Matrícula", _matriculaController,
                          formatter: _matriculaFormatter),
                      _campoTexto("Nome Completo", _nomeController),
                      _campoTexto("CPF", _cpfController,
                          formatter: _cpfFormatter),
                      _campoData("Data de Nascimento"),
                      _tituloCampo("Gênero"),
                      Wrap(
                        children: [
                          "Feminino",
                          "Masculino",
                          "Prefiro não declarar"
                        ].map((g) {
                          return RadioListTile(
                            title:
                                Text(g, style: TextStyle(color: Colors.white)),
                            value: g,
                            groupValue: genero,
                            onChanged: (val) =>
                                setState(() => genero = val.toString()),
                          );
                        }).toList(),
                      ),
                      _campoSenha("Senha", _senhaController),
                      _tituloSessao("Contato"),
                      _campoTexto("E-mail Institucional", _emailInstController,
                          keyboardType: TextInputType.emailAddress),
                      _campoTexto(
                          "E-mail Particular (opcional)", _emailPartController,
                          keyboardType: TextInputType.emailAddress),
                      _campoTexto("Celular", _celularController,
                          formatter: _celFormatter),
                      _tituloSessao("Residência"),
                      _campoTexto("Cidade e UF", _cidadeController),
                      _tituloSessao("Atividade no CEUB"),
                      _grupoCheckbox(
                          ["Aluno", "Professor", "Colaborador", "Egresso"],
                          atividades),
                      _tituloSessao("Disponibilidade de Horário"),
                      _grupoMultiSelect(
                          "Dias disponíveis",
                          [
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
                          ],
                          disponibilidade),
                      _campoHorario("Horário preferencial"),
                      _tituloSessao("Motivação"),
                      _campoTextoMultilinha("Por que deseja ser voluntário?",
                          _motivacaoController),
                      _tituloSessao("Causas e Habilidades"),
                      _grupoMultiSelect(
                          "Causas",
                          [
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
                          ],
                          causas),
                      _grupoMultiSelect(
                          "Habilidades",
                          [
                            "Comunicação",
                            "Idiomas",
                            "Informática",
                            "Gestão",
                            "Dança/Música",
                            "Educação",
                            "Saúde/Psicologia"
                          ],
                          habilidades),
                      _tituloSessao("Comentários"),
                      _campoTextoMultilinha(
                          "Deixe seus comentários", _comentariosController),
                      _tituloSessao("Informações Complementares"),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitCadastro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(
                                horizontal: 48, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Cadastrar",
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCadastro() async {
    try {
      print('Validando formulário...');
      if (_formKey.currentState!.validate()) {
        print('Criando objeto Voluntario...');
        final voluntario = Voluntario(
          nome: _nomeController.text.trim(),
          matricula: _matriculaController.text.trim(),
          cpf: _cpfController.text.trim(),
          dataNascimento: _dataNascimento,
          genero: genero,
          senha: _senhaController.text,
          atividadeCEUB: atividades,
          emailInstitucional: _emailInstController.text.trim(),
          emailParticular: _emailPartController.text.trim(),
          celular: _celularController.text.trim(),
          cidadeUF: _cidadeController.text.trim(),
          horario: _horarioSelecionado?.format(context),
          motivacao: _motivacaoController.text,
          causas: causas,
          habilidades: habilidades,
          disponibilidadeSemanal: disponibilidade,
          comentarios: _comentariosController.text,
        );

        if (!voluntario.validarCamposObrigatorios()) {
          print('Validação interna falhou');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Preencha todos os campos obrigatórios!')),
          );
          return;
        }

        print('Chamando serviço de cadastro...');
        final sucesso =
            await VoluntarioService().cadastrarVoluntario(voluntario);
        print('Resultado da API: $sucesso');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sucesso
                ? 'Cadastro realizado com sucesso!'
                : 'Erro ao cadastrar voluntário.'),
          ),
        );

        if (sucesso && Navigator.canPop(context)) {
          print('Fechando tela com pop...');
          Navigator.pop(context);
        }
      }
    } catch (e, stacktrace) {
      print('❌ Erro no cadastro: $e');
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado ao cadastrar voluntário.')),
      );
    }
  }

  Widget _campoTexto(String label, TextEditingController controller,
      {TextInputType? keyboardType, TextInputFormatter? formatter}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        inputFormatters: formatter != null ? [formatter] : [],
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _campoSenha(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(color: Colors.white),
        validator: (value) =>
            value != null && value.length < 6 ? 'Mínimo 6 caracteres' : null,
      ),
    );
  }

  Widget _campoData(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: _selecionarData,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white24,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            controller: TextEditingController(
              text: _dataNascimento != null
                  ? "${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}"
                  : '',
            ),
            style: TextStyle(color: Colors.white),
            validator: (value) =>
                value == null || value.isEmpty ? 'Selecione uma data' : null,
          ),
        ),
      ),
    );
  }

  Widget _campoHorario(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: _selecionarHorario,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white24,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            controller: TextEditingController(
              text: _horarioSelecionado != null
                  ? _horarioSelecionado!.format(context)
                  : '',
            ),
            style: TextStyle(color: Colors.white),
            validator: (value) =>
                _horarioSelecionado == null ? 'Selecione um horário' : null,
          ),
        ),
      ),
    );
  }

  Widget _campoTextoMultilinha(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _grupoCheckbox(List<String> opcoes, List<String> selecionados) {
    return Column(
      children: opcoes.map((op) {
        return CheckboxListTile(
          title: Text(op, style: TextStyle(color: Colors.white)),
          value: selecionados.contains(op),
          onChanged: (val) {
            setState(() {
              if (val == true) {
                selecionados
                  ..clear()
                  ..add(op);
              } else {
                selecionados.remove(op);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _grupoMultiSelect(
      String label, List<String> opcoes, List<String> selecionados) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloCampo(label),
        Wrap(
          spacing: 8,
          children: opcoes.map((op) {
            final ativo = selecionados.contains(op);
            return FilterChip(
              label: Text(op),
              selected: ativo,
              onSelected: (val) {
                setState(
                    () => val ? selecionados.add(op) : selecionados.remove(op));
              },
              selectedColor: Colors.amber,
              backgroundColor: Colors.white24,
              labelStyle: TextStyle(color: Colors.black),
            );
          }).toList(),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _tituloSessao(String texto) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(texto,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      );

  Widget _tituloCampo(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(texto, style: TextStyle(color: Colors.white70)),
      );
}
