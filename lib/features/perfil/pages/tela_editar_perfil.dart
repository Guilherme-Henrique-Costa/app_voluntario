import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/storage_service.dart';
import '../../../core/utils/permissao_util.dart';
import '../models/voluntario.dart';
import '../services/voluntario_service.dart';

class TelaEditarPerfil extends StatefulWidget {
  const TelaEditarPerfil({super.key});

  @override
  State<TelaEditarPerfil> createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  late Voluntario _voluntario;
  bool _carregando = true;
  File? _imagemSelecionada;
  String? _avatarSelecionado;

  // Controladores
  final _nomeController = TextEditingController();
  final _celularController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _motivacaoController = TextEditingController();
  final _comentariosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarVoluntario();
  }

  Future<void> _carregarVoluntario() async {
    final local = await StorageService.obterAtual();
    if (local != null) {
      setState(() {
        _voluntario = local;
        _preencherCampos(local);
        _carregando = false;
      });
    }
  }

  void _preencherCampos(Voluntario v) {
    _nomeController.text = v.nome ?? '';
    _celularController.text = v.celular ?? '';
    _cidadeController.text = v.cidadeUF ?? '';
    _motivacaoController.text = v.motivacao ?? '';
    _comentariosController.text = v.comentarios ?? '';
    _avatarSelecionado = v.avatarPath;
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    _voluntario
      ..nome = _nomeController.text
      ..celular = _celularController.text
      ..cidadeUF = _cidadeController.text
      ..motivacao = _motivacaoController.text
      ..comentarios = _comentariosController.text
      ..avatarPath = _avatarSelecionado;

    try {
      await VoluntarioService().atualizarVoluntario(_voluntario);
      await StorageService.salvarVoluntario(_voluntario);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ Erro ao salvar perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar alterações.')),
      );
    }
  }

  Future<void> _selecionarImagem() async {
    final permitido = await PermissaoUtil.solicitarPermissaoGaleria();
    if (!permitido) return;

    final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
        _avatarSelecionado = imagem.path;
      });
    }
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _buildImagemPerfil() {
    final path = _avatarSelecionado;
    if (path != null && path.endsWith('.json')) {
      return Lottie.asset(path, width: 80, height: 80);
    } else if (_imagemSelecionada != null) {
      return CircleAvatar(
          radius: 40, backgroundImage: FileImage(_imagemSelecionada!));
    } else if (path != null && File(path).existsSync()) {
      return CircleAvatar(radius: 40, backgroundImage: FileImage(File(path)));
    }
    return const CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, color: Colors.deepPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : Stack(
              children: [
                _background(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: _selecionarImagem,
                                child: _buildImagemPerfil(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildCampo('Nome', _nomeController),
                            _buildCampo('Celular', _celularController),
                            _buildCampo('Cidade/UF', _cidadeController),
                            _buildCampo('Motivação', _motivacaoController),
                            _buildCampo('Comentários', _comentariosController,
                                maxLines: 3),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _salvarAlteracoes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text(
                                'Salvar Alterações',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18),
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
