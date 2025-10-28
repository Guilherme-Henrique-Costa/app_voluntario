import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_theme.dart';
import 'core/constants/storage_service.dart';
import 'core/routes/rotas.dart';
import 'features/agenda/controllers/evento_controller.dart';
import 'home/controllers/tela_inicial_controller.dart';

import 'features/mensagens/pages/tela_chat.dart';
import 'features/mensagens/pages/tela_mensagens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Define o formato de data local (ex: 12/10/2025)
  await initializeDateFormatting('pt_BR', null);

  // Verifica login salvo localmente
  final voluntario = await StorageService.obterAtual();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventoController()),
        ChangeNotifierProvider(create: (_) => TelaInicialController()),
      ],
      child: AppVoluntario(isLogado: voluntario != null),
    ),
  );
}

class AppVoluntario extends StatelessWidget {
  final bool isLogado;

  const AppVoluntario({super.key, required this.isLogado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voluntariado CEUB',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // 🎨 Aplica o tema global revisado
      initialRoute: isLogado ? Rotas.inicial : Rotas.login,
      onGenerateRoute: _gerarRota,
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const PaginaErroRota(),
      ),
      builder: (context, child) {
        // 🔧 Ajusta a densidade de clique e remove sobreposição de teclado
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child!,
        );
      },
    );
  }

  Route<dynamic>? _gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) return _erroRota(settings.name);
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
        final builder = Rotas.mapa[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }
        return _erroRota(settings.name);
    }
  }

  Route<dynamic> _erroRota(String? rota) {
    return MaterialPageRoute(
      builder: (_) => PaginaErroRota(rota: rota),
    );
  }
}

class PaginaErroRota extends StatelessWidget {
  final String? rota;

  const PaginaErroRota({super.key, this.rota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erro de Navegação'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Rota não encontrada:\n${rota ?? "desconhecida"}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
