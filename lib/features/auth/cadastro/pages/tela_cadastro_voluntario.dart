import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../controllers/cadastro_controller.dart';
import '../widgets/campo_texto.dart';
import '../widgets/campo_senha.dart';
import '../widgets/campo_multilinha.dart';
import '../widgets/grupo_checkbox.dart';
import '../widgets/grupo_multiselect.dart';

class TelaCadastroVoluntario extends StatefulWidget {
  @override
  State<TelaCadastroVoluntario> createState() => _TelaCadastroVoluntarioState();
}

class _TelaCadastroVoluntarioState extends State<TelaCadastroVoluntario> {
  final _controller = CadastroController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _controller.formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tituloPrincipal("Cadastro de Voluntário"),
                      const SizedBox(height: 24),
                      _tituloSessao("Informações Pessoais"),
                      CampoTexto(
                          label: "Matrícula",
                          controller: _controller.matriculaController,
                          mask: MaskTextInputFormatter(mask: '########')),
                      CampoTexto(
                          label: "Nome Completo",
                          controller: _controller.nomeController),
                      CampoTexto(
                          label: "CPF",
                          controller: _controller.cpfController,
                          mask: MaskTextInputFormatter(mask: '###.###.###-##')),
                      _controller.campoData(context),
                      _controller.campoGenero(),
                      CampoSenha(
                          label: "Senha",
                          controller: _controller.senhaController),
                      _tituloSessao("Contato"),
                      CampoTexto(
                          label: "E-mail Institucional",
                          controller: _controller.emailInstController,
                          keyboardType: TextInputType.emailAddress),
                      CampoTexto(
                        label: "E-mail Particular (opcional)",
                        controller: _controller.emailPartController,
                        keyboardType: TextInputType.emailAddress,
                        obrigatorio: false,
                      ),
                      CampoTexto(
                          label: "Celular",
                          controller: _controller.celularController,
                          mask:
                              MaskTextInputFormatter(mask: '(##) #####-####')),
                      _tituloSessao("Residência"),
                      CampoTexto(
                          label: "Cidade e UF",
                          controller: _controller.cidadeController),
                      _tituloSessao("Atividade no CEUB"),
                      GrupoCheckbox(opcoes: [
                        "Aluno",
                        "Professor",
                        "Colaborador",
                        "Egresso"
                      ], selecionados: _controller.atividades),
                      _tituloSessao("Disponibilidade"),
                      GrupoMultiSelect(
                        label: "Dias disponíveis",
                        opcoes: _controller.opcoesDisponibilidade,
                        selecionados: _controller.disponibilidade,
                      ),
                      _controller.campoHorario(context),
                      _tituloSessao("Motivação"),
                      CampoMultilinha(
                          label: "Por que deseja ser voluntário?",
                          controller: _controller.motivacaoController),
                      _tituloSessao("Causas e Habilidades"),
                      GrupoMultiSelect(
                          label: "Causas",
                          opcoes: _controller.opcoesCausas,
                          selecionados: _controller.causas),
                      GrupoMultiSelect(
                          label: "Habilidades",
                          opcoes: _controller.opcoesHabilidades,
                          selecionados: _controller.habilidades),
                      _tituloSessao("Comentários"),
                      CampoMultilinha(
                          label: "Comentários adicionais",
                          controller: _controller.comentariosController),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _controller.enviarCadastro(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            "Cadastrar",
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 18),
                          ),
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

  Widget _tituloSessao(String texto) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(texto,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      );

  Widget _tituloPrincipal(String texto) => Center(
        child: Text(
          texto,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );

  Widget _backgroundGradient() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
}
