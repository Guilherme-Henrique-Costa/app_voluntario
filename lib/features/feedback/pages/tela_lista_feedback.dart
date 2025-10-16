import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class TelaListaFeedbacks extends StatefulWidget {
  const TelaListaFeedbacks({super.key});

  @override
  State<TelaListaFeedbacks> createState() => _TelaListaFeedbacksState();
}

class _TelaListaFeedbacksState extends State<TelaListaFeedbacks> {
  List<FeedbackModel> _feedbacks = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarFeedbacks();
  }

  Future<void> _carregarFeedbacks() async {
    final lista = await FeedbackService.listarFeedbacks();
    setState(() {
      _feedbacks = lista.reversed.toList();
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        title: const Text('Todos os Feedbacks',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _feedbacks.isEmpty
              ? const Center(
                  child: Text('Nenhum feedback enviado ainda.',
                      style: TextStyle(color: Colors.white70)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _feedbacks.length,
                  itemBuilder: (context, index) {
                    final f = _feedbacks[index];
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.feedback,
                            color: Colors.deepPurple),
                        title: Text(f.mensagem),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy – HH:mm').format(f.data),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
