import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/conversa.dart';
import '../../servicos/conversa_service.dart';
import '../../servicos/storage_service.dart';
import 'tela_chat.dart';

class TelaMensagens extends StatefulWidget {
  const TelaMensagens({Key? key}) : super(key: key);

  @override
  State<TelaMensagens> createState() => _TelaMensagensState();
}

class _TelaMensagensState extends State<TelaMensagens> {
  List<Conversa> conversas = [];
  int? voluntarioId;
  String? voluntarioNome;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    carregarVoluntario();
    _refreshTimer =
        Timer.periodic(Duration(seconds: 10), (_) => carregarConversas());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> carregarVoluntario() async {
    final voluntario = await StorageService.obterAtual();

    if (voluntario == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      voluntarioId = voluntario.id;
      voluntarioNome = voluntario.nome;
    });

    carregarConversas();
  }

  Future<void> carregarConversas() async {
    final lista = await ConversaService.listarConversas();
    setState(() => conversas = lista);
  }

  @override
  Widget build(BuildContext context) {
    if (voluntarioId == null || voluntarioNome == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mensagens'),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagens', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: conversas.isEmpty
          ? Center(
              child: Text(
                'Nenhuma conversa recente.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: conversas.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (_, i) {
                final c = conversas[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple[100],
                      child: Text(
                        c.nomeInstituicao[0].toUpperCase(),
                        style: TextStyle(color: Colors.deepPurple[900]),
                      ),
                    ),
                    title: Text(
                      c.nomeInstituicao,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(c.ultimaMensagem),
                    trailing: Text(
                      DateFormat('HH:mm').format(c.data),
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {
                          'voluntarioId': voluntarioId!,
                          'voluntarioNome': voluntarioNome!,
                          'nomeInstituicao': c.nomeInstituicao,
                        },
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: {
              'voluntarioId': voluntarioId!,
              'voluntarioNome': voluntarioNome!,
              'nomeInstituicao': 'Nova Instituição'
            },
          );
        },
        backgroundColor: Colors.deepPurple[900],
        child: Icon(Icons.message, color: Colors.white),
        tooltip: 'Nova conversa',
      ),
    );
  }
}
