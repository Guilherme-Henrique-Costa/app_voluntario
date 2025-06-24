import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/voluntario.dart';
import '../servicos/storage_service.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _carregando = false;
  String? _mensagemErro;

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() => _mensagemErro = 'Preencha todos os campos.');
      return;
    }

    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    final url = Uri.parse('http://192.168.15.10:8080/api/v1/voluntario/login');

    try {
      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'emailInstitucional': email,
          'password': senha,
        }),
      );

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        final voluntario = Voluntario.fromJson(dados);

        await StorageService.salvarVoluntario(voluntario);

        Navigator.pushReplacementNamed(context, '/inicial');
      } else {
        setState(() => _mensagemErro = 'E-mail ou senha inválidos.');
      }
    } catch (e) {
      setState(() => _mensagemErro = 'Erro de rede: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volunteer_activism, size: 100, color: Colors.white),
              SizedBox(height: 24),
              _campoTexto(_emailController, 'E-mail institucional', false),
              SizedBox(height: 16),
              _campoTexto(_senhaController, 'Senha', true),
              SizedBox(height: 16),
              if (_mensagemErro != null)
                Text(_mensagemErro!, style: TextStyle(color: Colors.redAccent)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregando ? null : _fazerLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _carregando
                    ? CircularProgressIndicator(color: Colors.deepPurple)
                    : Text('Entrar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
      TextEditingController controller, String label, bool senha) {
    return TextField(
      controller: controller,
      obscureText: senha,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white24,
      ),
    );
  }
}
