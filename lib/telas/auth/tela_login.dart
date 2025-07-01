import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../models/voluntario.dart';
import '../../servicos/storage_service.dart';
import '../../constants/api.dart'; // <-- URL centralizada

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscureSenha = true;
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarSnackbar('Preencha todos os campos.', Colors.red);
      return;
    }

    setState(() => _carregando = true);

    final url = Uri.parse('$voluntarioUrl/login');

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
        await StorageService.salvarAtual(voluntario);

        _mostrarSnackbar('Login realizado com sucesso!', Colors.green);

        Future.delayed(Duration(milliseconds: 400), () {
          Navigator.of(context).pushReplacementNamed('/inicial');
        });
      } else {
        _mostrarSnackbar('E-mail ou senha inválidos.', Colors.red);
      }
    } catch (e) {
      _mostrarSnackbar('Erro de rede: $e', Colors.red);
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _mostrarSnackbar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade300, Colors.deepPurple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade800,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
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
                      _campoTexto(
                          _emailController, 'E-mail institucional', false),
                      SizedBox(height: 16),
                      _campoTexto(_senhaController, 'Senha', true),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/alterar_senha');
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _carregando ? null : _fazerLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: _carregando
                            ? Lottie.asset(
                                'assets/animations/loading.json',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              )
                            : Text('Entrar', style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: Text(
                          'Não tem cadastro? Cadastre-se',
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

  Widget _campoTexto(
      TextEditingController controller, String label, bool senha) {
    return TextFormField(
      controller: controller,
      obscureText: senha ? _obscureSenha : false,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (!senha && !value.contains('@')) return 'E-mail inválido';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white24,
        suffixIcon: senha
            ? IconButton(
                icon: Icon(
                  _obscureSenha ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscureSenha = !_obscureSenha;
                  });
                },
              )
            : null,
      ),
    );
  }
}
