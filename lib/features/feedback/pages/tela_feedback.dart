import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class TelaFeedback extends StatefulWidget {
  const TelaFeedback({super.key});

  @override
  State<TelaFeedback> createState() => _TelaFeedbackState();
}

class _TelaFeedbackState extends State<TelaFeedback> {
  final _formKey = GlobalKey<FormState>();
  final _mensagemController = TextEditingController();
  bool _enviando = false;

  Future<void> _enviarFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    final feedback = FeedbackModel(mensagem: _mensagemController.text.trim());
    await FeedbackService.salvarFeedback(feedback);

    setState(() => _enviando = false);
    _mensagemController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback enviado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Enviar Feedback',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple[800],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Envie um feedback sobre sua experiência ou sugestões de melhoria. '
                      'Seu comentário será enviado para a instituição responsável.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mensagemController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Digite seu feedback...',
                        labelStyle: const TextStyle(color: Colors.white),
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
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _enviando ? null : _enviarFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _enviando
                            ? const CircularProgressIndicator(
                                color: Colors.deepPurple)
                            : const Text('Enviar',
                                style: TextStyle(fontSize: 18)),
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
