import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/voluntario.dart';
import '../../servicos/storage_service.dart';

class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  Voluntario? voluntario;

  final List<String> avatares = [
    'assets/animations/avatar1.json',
    'assets/animations/avatar2.json',
  ];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final v = await StorageService.obterVoluntario();
    setState(() {
      voluntario = v;
    });
  }

  Widget _buildImagemPerfil() {
    final path = voluntario?.avatarPath;
    if (path != null) {
      if (path.endsWith('.json')) {
        return SizedBox(
          height: 80,
          width: 80,
          child: Lottie.asset(path, repeat: true),
        );
      } else if (path.contains('assets')) {
        return CircleAvatar(radius: 40, backgroundImage: AssetImage(path));
      } else {
        return CircleAvatar(radius: 40, backgroundImage: FileImage(File(path)));
      }
    }
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
    );
  }

  Widget _buildCampoInfo(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Expanded(
              child: Text(
                valor ?? 'Não informado',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF43054e),
      appBar: AppBar(
        backgroundColor: Color(0xFF43054e),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            tooltip: 'Editar Perfil',
            onPressed: () {
              Navigator.pushNamed(context, '/editar_perfil');
            },
          ),
        ],
      ),
      body: voluntario == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Column(
                    children: [
                      _buildImagemPerfil(),
                      SizedBox(height: 12),
                      Text(
                        'Perfil do Voluntário',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildCampoInfo('Nome', voluntario?.nome),
                  _buildCampoInfo('Celular', voluntario?.celular),
                  _buildCampoInfo('E-mail', voluntario?.emailInstitucional),
                  _buildCampoInfo('Experiências', voluntario?.experiencia),
                ],
              ),
            ),
    );
  }
}
