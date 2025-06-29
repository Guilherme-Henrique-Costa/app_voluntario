import 'dart:io';
import 'package:app_voluntario/servicos/voluntario_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/voluntario.dart';
import '../../servicos/storage_service.dart';

class TelaPerfil extends StatefulWidget {
  final int? voluntarioId;

  const TelaPerfil({Key? key, this.voluntarioId}) : super(key: key);

  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  Voluntario? voluntario;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    Voluntario? v;

    try {
      if (widget.voluntarioId != null) {
        v = await VoluntarioService().buscarPorId(widget.voluntarioId!);
      } else {
        final local = await StorageService.obterAtual();
        if (local?.id != null) {
          v = await VoluntarioService().buscarPorId(local!.id!);
        }
      }

      if (v == null && widget.voluntarioId != null) {
        v = await StorageService.obterVoluntarioPorId(widget.voluntarioId!);
      } else if (v == null) {
        v = await StorageService.obterAtual();
      }

      if (v != null) {
        await StorageService.salvarVoluntario(v);
      }
    } catch (e) {
      print('Erro ao carregar dados do voluntário: $e');
    }

    setState(() {
      voluntario = v;
      carregando = false;
    });
  }

  Widget _buildImagemPerfil() {
    final path = voluntario?.avatarPath;
    try {
      if (path != null) {
        if (path.endsWith('.json')) {
          return SizedBox(
            height: 90,
            width: 90,
            child: Lottie.asset(path, repeat: true),
          );
        } else if (path.contains('assets')) {
          return CircleAvatar(radius: 45, backgroundImage: AssetImage(path));
        } else if (File(path).existsSync()) {
          return CircleAvatar(
              radius: 45, backgroundImage: FileImage(File(path)));
        }
      }
    } catch (e) {
      print('Erro ao carregar avatar: \$e');
    }
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 42, color: Colors.deepPurple),
    );
  }

  Widget _buildCampoInfo(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(valor ?? 'Não informado')),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
    return Column(
      children: [
        _buildImagemPerfil(),
        SizedBox(height: 12),
        Text('Perfil do Voluntário',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ],
    );
  }

  void _logout() async {
    await StorageService.removerAtual();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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
      body: carregando
          ? Container(
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
              child: Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 100,
                  height: 100,
                ),
              ),
            )
          : Stack(
              children: [
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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListView(
                              children: [
                                _buildCabecalho(),
                                SizedBox(height: 20),
                                _buildCampoInfo('Nome', voluntario?.nome),
                                _buildCampoInfo(
                                    'Matrícula', voluntario?.matricula),
                                _buildCampoInfo('CPF', voluntario?.cpf),
                                _buildCampoInfo(
                                    'Nascimento',
                                    voluntario?.dataNascimento
                                        ?.toLocal()
                                        .toString()
                                        .split(' ')[0]),
                                _buildCampoInfo('Gênero', voluntario?.genero),
                                _buildCampoInfo(
                                    'E-mail', voluntario?.emailInstitucional),
                                _buildCampoInfo('Celular', voluntario?.celular),
                                _buildCampoInfo(
                                    'Cidade/UF', voluntario?.cidadeUF),
                                _buildCampoInfo(
                                    'Motivação', voluntario?.motivacao),
                                _buildCampoInfo('Horário', voluntario?.horario),
                                _buildCampoInfo(
                                    'Atividades',
                                    (voluntario?.atividadeCEUB
                                                ?.where(
                                                    (e) => e.trim().isNotEmpty)
                                                .toList() ??
                                            [])
                                        .join(', ')),
                                _buildCampoInfo(
                                    'Causas',
                                    (voluntario?.causas
                                                ?.where(
                                                    (e) => e.trim().isNotEmpty)
                                                .toList() ??
                                            [])
                                        .join(', ')),
                                _buildCampoInfo(
                                    'Habilidades',
                                    (voluntario?.habilidades
                                                ?.where(
                                                    (e) => e.trim().isNotEmpty)
                                                .toList() ??
                                            [])
                                        .join(', ')),
                                _buildCampoInfo(
                                    'Disponibilidade',
                                    (voluntario?.disponibilidadeSemanal
                                                ?.where(
                                                    (e) => e.trim().isNotEmpty)
                                                .toList() ??
                                            [])
                                        .join(', ')),
                                _buildCampoInfo(
                                    'Comentários', voluntario?.comentarios),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _logout,
                          icon:
                              Icon(Icons.exit_to_app, color: Colors.deepPurple),
                          label: Text('Sair',
                              style: TextStyle(color: Colors.deepPurple)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
