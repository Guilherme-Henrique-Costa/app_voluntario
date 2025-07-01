import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mensagem_model.dart';
import '../../servicos/chat_api_service.dart';
import '../../servicos/storage_service.dart';

class TelaChat extends StatefulWidget {
  final int voluntarioId;
  final String voluntarioNome;
  final String nomeInstituicao;

  const TelaChat({
    super.key,
    required this.voluntarioId,
    required this.voluntarioNome,
    required this.nomeInstituicao,
  });

  @override
  State<TelaChat> createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  List<Mensagem> mensagens = [];
  final TextEditingController _mensagemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    carregarMensagens();
    _timer = Timer.periodic(Duration(seconds: 5), (_) => carregarMensagens());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> carregarMensagens() async {
    final lista =
        await ChatApiService.buscarMensagensPorVoluntario(widget.voluntarioId);
    setState(() => mensagens = lista);

    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<void> enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) return;

    final novaMensagem = Mensagem(
      texto: texto,
      ehUsuario: false,
      data: DateTime.now(),
      voluntarioId: widget.voluntarioId,
      voluntarioNome: widget.voluntarioNome,
    );

    await ChatApiService.enviarMensagem(novaMensagem);
    _mensagemController.clear();
    await carregarMensagens();
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeInstituicao),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: mensagens.isEmpty
                  ? Center(child: Text('Nenhuma mensagem.'))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(10),
                      reverse: false,
                      itemCount: mensagens.length,
                      itemBuilder: (context, index) {
                        final m = mensagens[index];
                        final isMe = !m.ehUsuario;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            constraints: BoxConstraints(maxWidth: 250),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.deepPurple[100]
                                  : Colors.amber[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.texto, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat('HH:mm').format(m.data),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.deepPurple[700]),
                    onPressed: enviarMensagem,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
