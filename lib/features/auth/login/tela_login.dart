import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../core/constants/api.dart';
import '../../../core/constants/storage_service.dart';
import '../../perfil/models/voluntario.dart';

class TelaLogin extends StatefulWidget {
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _obscureSenha = true;
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    final url = Uri.parse('${ApiEndpoints.voluntarios}/login');

    try {
      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'emailInstitucional': _emailController.text.trim(),
          'password': _senhaController.text.trim(),
        }),
      );

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        final voluntario = Voluntario.fromJson(dados);

        await StorageService.salvarVoluntario(voluntario);
        await StorageService.salvarAtual(voluntario);

        _mostrarSnack('Login realizado com sucesso!', Colors.green);
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.of(context).pushReplacementNamed('/inicial');
        });
      } else {
        _mostrarSnack('E-mail ou senha inválidos.', Colors.red);
      }
    } catch (e) {
      _mostrarSnack('Erro de rede: $e', Colors.red);
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _mostrarSnack(String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: cor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _fundoGradiente(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: _cardLogin(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundoGradiente() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  Widget _cardLogin() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade800,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
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
            const SizedBox(height: 24),
            _campoTexto(_emailController, 'E-mail institucional', false),
            const SizedBox(height: 16),
            _campoTexto(_senhaController, 'Senha', true),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/alterar_senha'),
                child: const Text('Esqueci minha senha',
                    style: TextStyle(color: Colors.white70)),
              ),
            ),
            const SizedBox(height: 8),
            _botaoEntrar(),
            const SizedBox(height: 12),
            _linkCadastro(),
          ],
        ),
      );

  Widget _campoTexto(TextEditingController ctrl, String label, bool senha) {
    return TextFormField(
      controller: ctrl,
      obscureText: senha ? _obscureSenha : false,
      style: const TextStyle(color: Colors.white),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Campo obrigatório';
        if (!senha && !v.contains('@')) return 'E-mail inválido';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white24,
        suffixIcon: senha
            ? IconButton(
                icon: Icon(
                  _obscureSenha ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
              )
            : null,
      ),
    );
  }

  Widget _botaoEntrar() => ElevatedButton(
        onPressed: _carregando ? null : _fazerLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
        child: _carregando
            ? Lottie.asset('assets/animations/loading.json',
                width: 50, height: 50)
            : const Text('Entrar',
                style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
      );

  Widget _linkCadastro() => TextButton(
        onPressed: () => Navigator.pushNamed(context, '/cadastro'),
        child: const Text('Não tem cadastro? Cadastre-se',
            style: TextStyle(color: Colors.white70)),
      );
}
