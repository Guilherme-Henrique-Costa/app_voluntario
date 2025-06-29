import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TelaAlterarSenha extends StatefulWidget {
  @override
  _TelaAlterarSenhaState createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _obscureSenha = true;
  bool _carregando = false;

  void _alterarSenha() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Senha alterada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _enviarSolicitacao() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      await Future.delayed(Duration(seconds: 2)); // Simula carregamento

      setState(() => _carregando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Instruções enviadas para seu e-mail."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade300,
                  Colors.deepPurple.shade900
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[800],
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/icone_app2.svg',
                        width: 100,
                        height: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 24),
                      _campoTexto(_emailController, 'E-mail institucional'),
                      SizedBox(height: 16),
                      _campoSenha(_novaSenhaController, 'Nova senha'),
                      SizedBox(height: 16),
                      _campoSenha(
                          _confirmarSenhaController, 'Confirmar nova senha'),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _carregando ? null : _alterarSenha,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _carregando
                            ? CircularProgressIndicator(
                                color: Colors.deepPurple)
                            : Text(
                                'Alterar Senha',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.deepPurple),
                              ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Voltar ao login
                        },
                        child: Text(
                          'Voltar ao login',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (!value.contains('@')) return 'E-mail inválido';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white24,
      ),
    );
  }

  Widget _campoSenha(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureSenha,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (label == 'Confirmar nova senha' &&
            value != _novaSenhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white24,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureSenha ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _obscureSenha = !_obscureSenha;
            });
          },
        ),
      ),
    );
  }
}
