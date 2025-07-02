import 'package:app_voluntario/features/feedback/models/feedback.dart';
import 'package:app_voluntario/features/feedback/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaListaFeedbacks extends StatefulWidget {
  @override
  _TelaListaFeedbacksState createState() => _TelaListaFeedbacksState();
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
        title: Text(
          'Todos os Feedbacks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _carregando
          ? Center(child: CircularProgressIndicator(color: Colors.amber))
          : _feedbacks.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum feedback enviado ainda.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _feedbacks.length,
                  itemBuilder: (context, index) {
                    final f = _feedbacks[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: ListTile(
                        leading:
                            Icon(Icons.feedback, color: Colors.deepPurple[800]),
                        title: Text(f.mensagem),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy – HH:mm').format(f.data),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
