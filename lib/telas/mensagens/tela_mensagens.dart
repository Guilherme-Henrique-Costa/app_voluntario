import 'package:flutter/material.dart';

class TelaMensagens extends StatelessWidget {
  final List<String> conversas = [
    'Instituição X',
    'Instituição Y',
    'Instituição Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagens'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: conversas.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            child: Text(conversas[index][0]),
          ),
          title: Text(conversas[index]),
          subtitle: Text('Última mensagem...'),
          onTap: () {
            Navigator.pushNamed(context, '/chat');
          },
        ),
      ),
    );
  }
}
