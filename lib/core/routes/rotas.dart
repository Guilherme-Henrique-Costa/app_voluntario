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

// Feedback
import 'package:app_voluntario/features/feedback/pages/tela_feedback.dart';
import 'package:app_voluntario/features/feedback/pages/tela_lista_feedback.dart';

// Recomendação Inteligente
import 'package:app_voluntario/features/recomendacoes/pages/tela_recomendacoes.dart';

// Dashboard
import 'package:app_voluntario/features/dashboard/pages/tela_dashboard.dart';

// Home
import 'package:app_voluntario/home/pages/tela_inicial.dart';

class Rotas {
  // 🔑 Definições nomeadas
  static const login = '/login';
  static const cadastro = '/cadastro';

  static const inicial = '/inicial';
  static const perfil = '/perfil';
  static const editarPerfil = '/editar_perfil';
  static const alterarSenha = '/alterar_senha';

  static const agenda = '/agenda';
  static const vagas = '/vagas';
  static const minhasVagas = '/minhas_vagas';
  static const historico = '/historico';

  static const recompensa = '/recompensa';
  static const historicoRecompensas = '/historico_recompensas';
  static const conquistas = '/conquistas';

  static const feedback = '/feedback';
  static const feedbacks = '/feedbacks';

  static const dashboard = '/dashboard';
  static const recomendacoes = '/recomendacoes';

  static final Map<String, WidgetBuilder> mapa = {
    // Autenticação
    login: (_) => TelaLogin(),
    cadastro: (_) => TelaCadastroVoluntario(),

    // Inicial e Perfil
    inicial: (_) => const TelaInicial(),
    perfil: (_) => const TelaPerfil(),
    editarPerfil: (_) => const TelaEditarPerfil(),
    alterarSenha: (_) => TelaAlterarSenha(),

    // Agenda e Vagas
    agenda: (_) => const TelaAgenda(),
    vagas: (_) => const TelaVagas(),
    minhasVagas: (_) => const TelaMinhasVagas(),
    historico: (_) => TelaHistorico(),

    // Recompensas
    recompensa: (_) => TelaRecompensa(),
    historicoRecompensas: (_) => TelaHistoricoRecompensas(),
    conquistas: (_) => TelaConquistas(),

    // Feedback
    feedback: (_) => const TelaFeedback(),
    feedbacks: (_) => const TelaListaFeedbacks(),

    // Dashboard
    dashboard: (_) => const TelaDashboard(),

    // Recomendação Inteligente
    recomendacoes: (_) => const TelaRecomendacoes(),
  };

  static Route<dynamic> gerarRota(RouteSettings settings) {
    final builder = mapa[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    // Caso a rota não exista → fallback amigável
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text(
            '❌ Página não encontrada',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
