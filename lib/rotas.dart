import 'package:flutter/material.dart';

import 'telas/tela_login.dart';
import 'telas/tela_inicial.dart';
import 'telas/tela_perfil.dart';
import 'telas/tela_chat.dart';
import 'telas/tela_mensagens.dart';
import 'telas/tela_vagas_candidatadas.dart';
import 'telas/tela_agenda.dart';
import 'telas/tela_historico.dart';

final Map<String, WidgetBuilder> rotas = {
  '/login': (context) => TelaLogin(),
  '/inicial': (context) => TelaInicial(),
  '/perfil': (context) => TelaPerfil(),
  '/chat': (context) => TelaChat(),
  '/mensagens': (context) => TelaMensagens(),
  '/vagas_candidatadas': (context) => TelaVagasCandidatadas(),
  '/agenda': (context) => TelaAgenda(),
  '/historico': (context) => TelaHistorico(),
};
