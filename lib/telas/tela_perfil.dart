import 'package:flutter/material.dart';
import '../models/voluntario.dart';
import '../servicos/storage_service.dart';

class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final celularController = TextEditingController();
  final emailController = TextEditingController();
  final experienciaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final voluntario = await StorageService.obterVoluntario();
    if (voluntario != null) {
      setState(() {
        nomeController.text = voluntario.nome ?? '';
        celularController.text = voluntario.celular ?? '';
        emailController.text = voluntario.emailInstitucional ?? '';
        experienciaController.text = voluntario.experiencia ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF43054e),
      appBar: AppBar(
        backgroundColor: Color(0xFF43054e),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text('+ vercar', style: TextStyle(color: Colors.white70)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 40, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Perfil do Voluntário',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildCampo('Nome', nomeController),
              _buildCampo('Celular', celularController),
              _buildCampo('E-mail', emailController),
              _buildCampo('Experiências', experienciaController, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Alterações salvas com sucesso!'),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Salvar alterações'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
