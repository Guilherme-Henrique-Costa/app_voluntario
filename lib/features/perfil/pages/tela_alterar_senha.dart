import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/voluntario_service.dart';

class TelaAlterarSenha extends StatefulWidget {
  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _novaSenhaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  final _service = VoluntarioService();
  bool _oculto = true;
  bool _carregando = false;

  Future<void> _alterarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    final resultado = await _service.redefinirSenha(
        _emailCtrl.text.trim(), _novaSenhaCtrl.text.trim());
    setState(() => _carregando = false);

    final sucesso = resultado['sucesso'] == true;
    _showSnack(resultado['mensagem'] ?? '', sucesso);
  }

  void _showSnack(String msg, bool sucesso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: sucesso ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: _background()),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _formAlterar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formAlterar() => Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.deepPurple[800],
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icon/icone_app2.svg',
                  width: 100, height: 100, color: Colors.white),
              const SizedBox(height: 24),
              _campo(_emailCtrl, 'E-mail institucional'),
              const SizedBox(height: 16),
              _campoSenha(_novaSenhaCtrl, 'Nova senha'),
              const SizedBox(height: 16),
              _campoSenha(_confirmarCtrl, 'Confirmar nova senha'),
              const SizedBox(height: 24),
              _botaoAlterar(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar ao login',
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      );

  Widget _campo(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Campo obrigatório';
        if (!v.contains('@')) return 'E-mail inválido';
        return null;
      },
      decoration: _decoracao(label),
    );
  }

  Widget _campoSenha(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      obscureText: _oculto,
      style: const TextStyle(color: Colors.white),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Campo obrigatório';
        if (label.contains('Confirmar') && v != _novaSenhaCtrl.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
      decoration: _decoracao(label, senha: true),
    );
  }

  InputDecoration _decoracao(String label, {bool senha = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white24,
      suffixIcon: senha
          ? IconButton(
              icon: Icon(_oculto ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white),
              onPressed: () => setState(() => _oculto = !_oculto),
            )
          : null,
    );
  }

  Widget _botaoAlterar() => ElevatedButton(
        onPressed: _carregando ? null : _alterarSenha,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: _carregando
            ? const CircularProgressIndicator(color: Colors.deepPurple)
            : const Text('Alterar Senha',
                style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
      );

  BoxDecoration _background() => BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
}
