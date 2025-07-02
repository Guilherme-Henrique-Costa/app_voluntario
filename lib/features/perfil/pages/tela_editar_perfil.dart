import 'dart:io';
import 'package:app_voluntario/features/perfil/services/voluntario_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../models/voluntario.dart';
import '../../../core/constants/storage_service.dart';
import '../../../core/utils/permissao_util.dart';

class TelaEditarPerfil extends StatefulWidget {
  final int? voluntarioId;

  const TelaEditarPerfil({Key? key, this.voluntarioId}) : super(key: key);

  @override
  _TelaEditarPerfilState createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final celularController = TextEditingController();
  final cidadeController = TextEditingController();
  final motivacaoController = TextEditingController();
  final comentariosController = TextEditingController();
  final matriculaController = TextEditingController();
  final cpfController = TextEditingController();
  final generoController = TextEditingController();
  final emailController = TextEditingController();
  final horarioController = TextEditingController();
  final nascimentoController = TextEditingController();
  final atividadeController = TextEditingController();
  final causasController = TextEditingController();
  final habilidadesController = TextEditingController();
  final disponibilidadeController = TextEditingController();

  File? _imagemSelecionada;
  String? _avatarSelecionado;
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
    try {
      Voluntario? v;

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

      setState(() {
        voluntario = v;

        nomeController.text = v?.nome ?? '';
        celularController.text = v?.celular ?? '';
        cidadeController.text = v?.cidadeUF ?? '';
        motivacaoController.text = v?.motivacao ?? '';
        comentariosController.text = v?.comentarios ?? '';
        matriculaController.text = v?.matricula ?? '';
        cpfController.text = v?.cpf ?? '';
        generoController.text = v?.genero ?? '';
        emailController.text = v?.emailInstitucional ?? '';
        horarioController.text = v?.horario ?? '';
        nascimentoController.text =
            v?.dataNascimento?.toIso8601String().split('T')[0] ?? '';
        atividadeController.text = v?.atividadeCEUB?.join(', ') ?? '';
        causasController.text = v?.causas?.join(', ') ?? '';
        habilidadesController.text = v?.habilidades?.join(', ') ?? '';
        disponibilidadeController.text =
            v?.disponibilidadeSemanal?.join(', ') ?? '';

        _avatarSelecionado = v?.avatarPath;
        if (_avatarSelecionado != null &&
            _avatarSelecionado!.contains('assets')) {
          _imagemSelecionada = File(_avatarSelecionado!);
        }
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (voluntario == null) return;

    voluntario!.nome = nomeController.text;
    voluntario!.celular = celularController.text;
    voluntario!.cidadeUF = cidadeController.text;
    voluntario!.motivacao = motivacaoController.text;
    voluntario!.comentarios = comentariosController.text;
    voluntario!.matricula = matriculaController.text;
    voluntario!.cpf = cpfController.text;
    voluntario!.genero = generoController.text;
    voluntario!.emailInstitucional = emailController.text;
    voluntario!.horario = horarioController.text;
    voluntario!.dataNascimento = DateTime.tryParse(nascimentoController.text);
    voluntario!.atividadeCEUB =
        atividadeController.text.split(',').map((e) => e.trim()).toList();
    voluntario!.causas =
        causasController.text.split(',').map((e) => e.trim()).toList();
    voluntario!.habilidades =
        habilidadesController.text.split(',').map((e) => e.trim()).toList();
    voluntario!.disponibilidadeSemanal =
        disponibilidadeController.text.split(',').map((e) => e.trim()).toList();
    voluntario!.avatarPath = _avatarSelecionado;

    try {
      await VoluntarioService().atualizarVoluntario(voluntario!);
      await StorageService.salvarVoluntario(voluntario!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados atualizados com sucesso')));
    } catch (e) {
      print('Erro ao salvar alterações: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar alterações')));
    }
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildImagemPerfil() {
    final path = _avatarSelecionado;
    return GestureDetector(
      onTap: _mostrarEscolhaImagem,
      child: path != null && path.endsWith('.json')
          ? SizedBox(height: 80, width: 80, child: Lottie.asset(path))
          : CircleAvatar(
              radius: 40,
              backgroundImage: _imagemSelecionada != null
                  ? FileImage(_imagemSelecionada!)
                  : (path != null && path.contains('assets'))
                      ? AssetImage(path) as ImageProvider
                      : null,
              child: path == null
                  ? Icon(Icons.person, size: 40, color: Colors.deepPurple)
                  : null,
            ),
    );
  }

  void _mostrarEscolhaImagem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Escolha sua imagem de perfil',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.deepPurple),
                  onPressed: () async {
                    Navigator.pop(context);
                    final permitido =
                        await PermissaoUtil.solicitarPermissaoCamera();
                    if (permitido) {
                      final img = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          preferredCameraDevice: CameraDevice.front);
                      if (img != null) {
                        final file = File(img.path);
                        if (await file.exists()) {
                          setState(() {
                            _imagemSelecionada = file;
                            _avatarSelecionado = img.path;
                          });
                        }
                      }
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo, color: Colors.deepPurple),
                  onPressed: () async {
                    Navigator.pop(context);
                    final permitido =
                        await PermissaoUtil.solicitarPermissaoGaleria();
                    if (permitido) {
                      final img = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        final file = File(img.path);
                        if (await file.exists()) {
                          setState(() {
                            _imagemSelecionada = file;
                            _avatarSelecionado = img.path;
                          });
                        }
                      }
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.pop(context);
                    _mostrarAvatares();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAvatares() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Escolha um Avatar'),
        content: SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: avatares.map((path) {
              return GestureDetector(
                onTap: () {
                  _selecionarAvatar(path);
                  Navigator.pop(ctx);
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _avatarSelecionado == path
                          ? Colors.amber
                          : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: path.endsWith('.json')
                      ? Lottie.asset(path)
                      : CircleAvatar(backgroundImage: AssetImage(path)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _selecionarAvatar(String caminho) {
    setState(() {
      _avatarSelecionado = caminho;
      _imagemSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Editar Perfil', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
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
              child: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    children: [
                      Center(child: _buildImagemPerfil()),
                      SizedBox(height: 30),
                      _buildCampo('Nome', nomeController),
                      _buildCampo('Matrícula', matriculaController),
                      _buildCampo('CPF', cpfController),
                      _buildCampo(
                          'Nascimento (YYYY-MM-DD)', nascimentoController),
                      _buildCampo('Gênero', generoController),
                      _buildCampo('E-mail', emailController),
                      _buildCampo('Celular', celularController),
                      _buildCampo('Cidade/UF', cidadeController),
                      _buildCampo('Motivação', motivacaoController),
                      _buildCampo('Horário', horarioController),
                      _buildCampo('Atividades (separadas por vírgula)',
                          atividadeController),
                      _buildCampo(
                          'Causas (separadas por vírgula)', causasController),
                      _buildCampo('Habilidades (separadas por vírgula)',
                          habilidadesController),
                      _buildCampo('Disponibilidade (separadas por vírgula)',
                          disponibilidadeController),
                      _buildCampo('Comentários', comentariosController,
                          maxLines: 3),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text('Salvar Alterações',
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 18)),
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
}
