// lib/telas/mensagens/tela_chat.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mensagem_model.dart';
import '../../servicos/chat_api_service.dart';

class TelaChat extends StatefulWidget {
  final int voluntarioId;
  final String voluntarioNome;
  final String nomeInstituicao;

  const TelaChat({
    Key? key,
    required this.voluntarioId,
    required this.voluntarioNome,
    required this.nomeInstituicao,
  }) : super(key: key);

  @override
  _TelaChatState createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  List<Mensagem> mensagens = [];
  final TextEditingController mensagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarMensagens();
  }

  Future<void> carregarMensagens() async {
    final lista =
        await ChatApiService.buscarMensagensPorVoluntario(widget.voluntarioId);
    setState(() => mensagens = lista);
  }

  void enviarMensagem() async {
    final texto = mensagemController.text.trim();
    if (texto.isEmpty) return;

    final novaMensagem = Mensagem(
      texto: texto,
      ehUsuario: true,
      data: DateTime.now(),
      voluntarioId: widget.voluntarioId,
      voluntarioNome: widget.voluntarioNome,
    );

    setState(() => mensagens.add(novaMensagem));
    mensagemController.clear();

    await ChatApiService.enviarMensagem(novaMensagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(
          'Chat - ${widget.nomeInstituicao}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                final msg = mensagens[index];
                return Align(
                  alignment: msg.ehUsuario
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.ehUsuario
                          ? Colors.deepPurple[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.texto),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(msg.data),
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              8,
              12,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
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
