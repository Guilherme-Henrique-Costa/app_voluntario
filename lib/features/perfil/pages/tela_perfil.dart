import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/storage_service.dart';
import '../models/voluntario.dart';
import '../services/voluntario_service.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  Voluntario? _voluntario;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarVoluntario();
  }

  Future<void> _carregarVoluntario() async {
    try {
      final local = await StorageService.obterAtual();
      if (local?.id != null) {
        final dados = await VoluntarioService().buscarPorId(local!.id!);
        setState(() {
          _voluntario = dados ?? local;
          _carregando = false;
        });
      }
    } catch (e) {
      print('❌ Erro ao carregar perfil: $e');
      setState(() => _carregando = false);
    }
  }

  Future<void> _logout() async {
    await StorageService.removerAtual();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildCampoInfo(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label: ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Expanded(
              child: Text(
                valor?.isNotEmpty == true ? valor! : 'Não informado',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagemPerfil() {
    final path = _voluntario?.avatarPath;
    try {
      if (path != null && path.endsWith('.json')) {
        return Lottie.asset(path, width: 100, height: 100, repeat: true);
      } else if (path != null && File(path).existsSync()) {
        return CircleAvatar(radius: 50, backgroundImage: FileImage(File(path)));
      } else if (path != null && path.contains('assets')) {
        return CircleAvatar(radius: 50, backgroundImage: AssetImage(path));
      }
    } catch (_) {}
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 50, color: Colors.deepPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Editar Perfil',
            onPressed: () {
              Navigator.pushNamed(context, '/editar_perfil');
            },
          ),
        ],
      ),
      body: _carregando
          ? _loadingWidget()
          : Stack(
              children: [
                _background(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildImagemPerfil(),
                        const SizedBox(height: 10),
                        Text(
                          _voluntario?.nome ?? 'Voluntário',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCampoInfo(
                                      'Matrícula', _voluntario?.matricula),
                                  _buildCampoInfo('CPF', _voluntario?.cpf),
                                  _buildCampoInfo('E-mail',
                                      _voluntario?.emailInstitucional),
                                  _buildCampoInfo(
                                      'Celular', _voluntario?.celular),
                                  _buildCampoInfo(
                                      'Cidade/UF', _voluntario?.cidadeUF),
                                  _buildCampoInfo(
                                      'Gênero', _voluntario?.genero),
                                  _buildCampoInfo('Motivação',
                                      _voluntario?.motivacao ?? ''),
                                  _buildCampoInfo('Habilidades',
                                      _voluntario?.habilidades?.join(', ')),
                                  _buildCampoInfo('Causas',
                                      _voluntario?.causas?.join(', ')),
                                  _buildCampoInfo(
                                      'Disponibilidade',
                                      _voluntario?.disponibilidadeSemanal
                                          ?.join(', ')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.exit_to_app,
                              color: Colors.deepPurple),
                          label: const Text(
                            'Sair',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(
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

  Widget _loadingWidget() => Center(
        child: Lottie.asset('assets/animations/loading.json',
            width: 100, height: 100),
      );

  Widget _background() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade300,
              Colors.deepPurple.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
}
