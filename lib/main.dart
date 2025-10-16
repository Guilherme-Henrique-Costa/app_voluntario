import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/constants/storage_service.dart';
import 'core/routes/rotas.dart';
import 'features/mensagens/pages/tela_chat.dart';
import 'features/mensagens/pages/tela_mensagens.dart';
import 'features/agenda/controllers/evento_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  final voluntario = await StorageService.obterAtual();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventoController()),
      ],
      child: MyApp(isLogado: voluntario != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogado;

  const MyApp({super.key, required this.isLogado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voluntariado CEUB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: isLogado ? '/inicial' : '/login',
      routes: rotas,
      onGenerateRoute: _gerarRota,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const _PaginaErroRota(),
      ),
    );
  }

  /// Controla rotas com parâmetros dinâmicos (chat, mensagens, etc.)
  Route<dynamic>? _gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) return null;
        return MaterialPageRoute(
          builder: (_) => TelaChat(
            voluntarioId: args['voluntarioId'],
            voluntarioNome: args['voluntarioNome'],
            nomeInstituicao: args['nomeInstituicao'],
          ),
        );

      case '/mensagens':
        return MaterialPageRoute(builder: (_) => const TelaMensagens());

      default:
        final builder = rotas[settings.name];
        if (builder != null) return MaterialPageRoute(builder: builder);
        return MaterialPageRoute(
          builder: (_) => _PaginaErroRota(rota: settings.name),
        );
    }
  }
}

class _PaginaErroRota extends StatelessWidget {
  final String? rota;

  const _PaginaErroRota({this.rota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: Center(
        child: Text('Rota não encontrada: ${rota ?? "desconhecida"}'),
      ),
    );
  }
}
