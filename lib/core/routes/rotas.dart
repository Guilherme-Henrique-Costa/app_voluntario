import 'package:app_voluntario/features/auth/cadastro/tela_cadastro_voluntario.dart';
import 'package:app_voluntario/features/feedback/pages/tela_feedback.dart';
import 'package:app_voluntario/features/feedback/pages/tela_lista_feedback.dart';
import 'package:app_voluntario/features/perfil/pages/tela_alterar_senha.dart';
import 'package:app_voluntario/features/recompensa/pages/tela_historico_recompensa.dart';
import 'package:flutter/material.dart';

import '../../features/auth/login/tela_login.dart';
import '../../home/tela_inicial.dart';
import '../../features/perfil/pages/tela_perfil.dart';
import '../../features/mensagens/pages/tela_chat.dart';
import '../../features/mensagens/pages/tela_mensagens.dart';
import '../../features/agenda/pages/tela_agenda.dart';
import '../../features/vagas/pages/tela_historico.dart';
import '../../features/vagas/pages/tela_vagas.dart';
import '../../features/perfil/pages/tela_editar_perfil.dart';
import '../../features/recompensa/pages/tela_recompensa.dart';
import '../../features/recompensa/pages/tela_conquistas.dart';
import 'package:app_voluntario/features/vagas/pages/tela_minhas_vagas.dart';

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
