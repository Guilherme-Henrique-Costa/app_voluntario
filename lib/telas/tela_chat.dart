import 'package:flutter/material.dart';

class TelaChat extends StatefulWidget {
  @override
  _TelaChatState createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  final List<String> mensagens = [
    'Olá! Gostaria de saber mais sobre a vaga.',
    'Claro! A vaga é para apoio em eventos.',
    'Ótimo, tenho interesse!',
  ];

  final TextEditingController mensagemController = TextEditingController();

  void enviarMensagem() {
    final texto = mensagemController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        mensagens.add(texto);
        mensagemController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - Instituição X'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, index) => Align(
                alignment: index % 2 == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.grey[300]
                        : Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(mensagens[index]),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mensagemController,
                    decoration:
                        InputDecoration(hintText: 'Digite sua mensagem...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: enviarMensagem,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
