import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/routes/rotas.dart';
import 'features/mensagens/pages/tela_chat.dart';
import 'features/mensagens/pages/tela_mensagens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  final voluntario = await StorageService.obterAtual();

  runApp(MyApp(isLogado: voluntario != null));
}

class MyApp extends StatelessWidget {
  final bool isLogado;

  const MyApp({required this.isLogado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voluntariado CEUB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: rotas,
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => TelaChat(
              voluntarioId: args['voluntarioId'],
              voluntarioNome: args['voluntarioNome'],
              nomeInstituicao: args['nomeInstituicao'],
            ),
          );
        }

        if (settings.name == '/mensagens') {
          return MaterialPageRoute(builder: (_) => TelaMensagens());
        }

        final builder = rotas[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Erro')),
          body: Center(child: Text('Rota não encontrada: ${settings.name}')),
        ),
      ),
    );
  }
}
