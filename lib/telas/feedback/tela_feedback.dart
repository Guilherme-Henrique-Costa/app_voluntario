import 'package:app_voluntario/models/feedback.dart';
import 'package:app_voluntario/servicos/feedback_service.dart';
import 'package:flutter/material.dart';

class TelaFeedback extends StatefulWidget {
  @override
  _TelaFeedbackState createState() => _TelaFeedbackState();
}

class _TelaFeedbackState extends State<TelaFeedback> {
  final _formKey = GlobalKey<FormState>();
  final _mensagemController = TextEditingController();

  Future<void> _enviarFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      final feedback = FeedbackModel(mensagem: _mensagemController.text.trim());
      await FeedbackService.salvarFeedback(feedback);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback enviado com sucesso!')),
      );

      _mensagemController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Enviar Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple[800],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Essa tela é para você enviar um feedback sobre o seu trabalho voluntário, experiências ou sugestões de melhoria, direcionado para a instituição responsável.',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _mensagemController,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Digite seu feedback...',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.deepPurple[600],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Escreva ao menos 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _enviarFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Enviar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
