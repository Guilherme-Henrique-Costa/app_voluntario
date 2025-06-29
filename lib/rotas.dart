import 'package:app_voluntario/cadastro/tela_cadastro_voluntario.dart';
import 'package:app_voluntario/telas/feedback/tela_feedback.dart';
import 'package:app_voluntario/telas/feedback/tela_lista_feedback.dart';
import 'package:app_voluntario/telas/perfil/tela_alterar_senha.dart';
import 'package:app_voluntario/telas/recompensa/tela_historico_recompensa.dart';
import 'package:flutter/material.dart';

import 'telas/auth/tela_login.dart';
import 'telas/home/tela_inicial.dart';
import 'telas/perfil/tela_perfil.dart';
import 'telas/mensagens/tela_chat.dart';
import 'telas/mensagens/tela_mensagens.dart';
import 'telas/agenda/tela_agenda.dart';
import 'telas/vagas/tela_historico.dart';
import 'telas/vagas/tela_vagas.dart';
import 'telas/perfil/tela_editar_perfil.dart';
import 'telas/recompensa/tela_recompensa.dart';
import 'telas/recompensa/tela_conquistas.dart';
import 'package:app_voluntario/telas/vagas/tela_minhas_vagas.dart';

final Map<String, WidgetBuilder> rotas = {
  '/login': (context) => TelaLogin(),
  '/inicial': (context) => TelaInicial(),
  '/perfil': (context) => const TelaPerfil(),
  '/agenda': (context) => TelaAgenda(),
  '/historico': (context) => TelaHistorico(),
  '/vagas': (context) => TelaVagas(),
  '/recompensa': (context) => TelaRecompensa(),
  '/historico_recompensas': (context) => TelaHistoricoRecompensas(),
  '/conquistas': (context) => TelaConquistas(),
  '/editar_perfil': (context) => TelaEditarPerfil(),
  '/cadastro': (context) => TelaCadastroVoluntario(),
  '/alterar_senha': (context) => TelaAlterarSenha(),
  '/feedback': (context) => TelaFeedback(),
  '/feedbacks': (context) => TelaListaFeedbacks(),
  '/minhas_vagas': (context) => TelaMinhasVagas(),
};
