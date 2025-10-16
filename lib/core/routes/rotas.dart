import 'package:flutter/material.dart';

// Autenticação
import 'package:app_voluntario/features/auth/login/tela_login.dart';
import 'package:app_voluntario/features/auth/cadastro/pages/tela_cadastro_voluntario.dart';

// Perfil
import 'package:app_voluntario/features/perfil/pages/tela_perfil.dart';
import 'package:app_voluntario/features/perfil/pages/tela_editar_perfil.dart';
import 'package:app_voluntario/features/perfil/pages/tela_alterar_senha.dart';

// Agenda e Vagas
import 'package:app_voluntario/features/agenda/pages/tela_agenda.dart';
import 'package:app_voluntario/features/vagas/pages/tela_vagas.dart';
import 'package:app_voluntario/features/vagas/pages/tela_minhas_vagas.dart';
import 'package:app_voluntario/features/vagas/pages/tela_historico.dart';

// Recompensas
import 'package:app_voluntario/features/recompensa/pages/tela_recompensa.dart';
import 'package:app_voluntario/features/recompensa/pages/tela_conquistas.dart';
import 'package:app_voluntario/features/recompensa/pages/tela_historico_recompensa.dart';

// Feedbacks
import 'package:app_voluntario/features/feedback/pages/tela_feedback.dart';
import 'package:app_voluntario/features/feedback/pages/tela_lista_feedback.dart';

// Recomendação Inteligente
import 'package:app_voluntario/features/recomendacoes/pages/tela_recomendacoes.dart';

// Dashboard
import 'package:app_voluntario/features/dashboard/pages/tela_dashboard.dart';

// Home
import 'package:app_voluntario/home/tela_inicial.dart';

final Map<String, WidgetBuilder> rotas = {
  // Autenticação
  '/login': (_) => TelaLogin(),
  '/cadastro': (_) => TelaCadastroVoluntario(),

  // Inicial e Perfil
  '/inicial': (_) => const TelaInicial(),
  '/perfil': (_) => const TelaPerfil(),
  '/editar_perfil': (_) => const TelaEditarPerfil(),
  '/alterar_senha': (_) => TelaAlterarSenha(),

  // Agenda e Vagas
  '/agenda': (_) => TelaAgenda(),
  '/vagas': (_) => TelaVagas(),
  '/minhas_vagas': (_) => TelaMinhasVagas(),
  '/historico': (_) => TelaHistorico(),

  // 🏆 Recompensas
  '/recompensa': (_) => TelaRecompensa(),
  '/historico_recompensas': (_) => TelaHistoricoRecompensas(),
  '/conquistas': (_) => TelaConquistas(),

  // Feedback
  '/feedback': (_) => TelaFeedback(),
  '/feedbacks': (_) => TelaListaFeedbacks(),

  // Dashboard
  '/dashboard': (_) => const TelaDashboard(),

  // Recomendações
  '/recomendacoes': (_) => TelaRecomendacoes(),
};
