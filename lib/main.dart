import 'package:app_voluntario/servicos/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'rotas.dart';
import 'models/voluntario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  final voluntario = await StorageService.obterVoluntario();

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: rotas,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Erro')),
          body: Center(child: Text('Rota não encontrada: ${settings.name}')),
        ),
      ),
    );
  }
}
