import 'dart:io';
import 'package:app_voluntario/utils/permissao_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../../models/voluntario.dart';
import '../../servicos/storage_service.dart';

class TelaEditarPerfil extends StatefulWidget {
  @override
  _TelaEditarPerfilState createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final celularController = TextEditingController();
  final experienciaController = TextEditingController();

  File? _imagemSelecionada;
  String? _avatarSelecionado;

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
    final voluntario = await StorageService.obterVoluntario();
    if (voluntario != null) {
      setState(() {
        nomeController.text = voluntario.nome ?? '';
        celularController.text = voluntario.celular ?? '';
        experienciaController.text = voluntario.experiencia ?? '';
        _avatarSelecionado = voluntario.avatarPath;
        if (_avatarSelecionado != null &&
            !_avatarSelecionado!.contains('assets')) {
          _imagemSelecionada = File(_avatarSelecionado!);
        }
      });
    }
  }

  Future<void> _tirarFoto() async {
    final permitido = await PermissaoUtil.solicitarPermissaoCamera();
    if (!permitido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão para usar a câmera é necessária.')),
      );
      return;
    }

    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.camera);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
        _avatarSelecionado = imagem.path;
      });
    }
  }

  Future<void> _escolherImagemGaleria() async {
    final permitido = await PermissaoUtil.solicitarPermissaoGaleria();
    if (!permitido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Permissão para acessar a galeria é necessária.')),
      );
      return;
    }

    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
        _avatarSelecionado = imagem.path;
      });
    }
  }

  void _selecionarAvatar(String caminho) {
    setState(() {
      _avatarSelecionado = caminho;
      _imagemSelecionada = null;
    });
  }

  Future<void> _salvarAlteracoes() async {
    final voluntario = await StorageService.obterVoluntario();
    if (voluntario != null) {
      voluntario.nome = nomeController.text;
      voluntario.celular = celularController.text;
      voluntario.experiencia = experienciaController.text;

      if (_avatarSelecionado != null) {
        voluntario.avatarPath = _avatarSelecionado;
      } else if (_imagemSelecionada != null) {
        voluntario.avatarPath = _imagemSelecionada!.path;
      }

      await StorageService.salvarVoluntario(voluntario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso.')),
      );

      Navigator.pop(context);
    }
  }

  void _mostrarOpcoesImagem() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
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
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.pop(context);
                        _tirarFoto();
                      },
                    ),
                    Text('Câmera'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.pop(context);
                        _escolherImagemGaleria();
                      },
                    ),
                    Text('Galeria'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.emoji_emotions, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.pop(context);
                        _mostrarAvatares();
                      },
                    ),
                    Text('Avatar'),
                  ],
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildImagemPerfil() {
    return GestureDetector(
      onTap: _mostrarOpcoesImagem,
      child: _avatarSelecionado != null && _avatarSelecionado!.endsWith('.json')
          ? SizedBox(
              height: 80,
              width: 80,
              child: Lottie.asset(_avatarSelecionado!, repeat: true),
            )
          : CircleAvatar(
              radius: 40,
              backgroundImage: _imagemSelecionada != null
                  ? FileImage(_imagemSelecionada!)
                  : (_avatarSelecionado != null &&
                          _avatarSelecionado!.contains('assets'))
                      ? AssetImage(_avatarSelecionado!) as ImageProvider
                      : null,
              child: (_avatarSelecionado == null && _imagemSelecionada == null)
                  ? Icon(Icons.person, size: 40, color: Colors.deepPurple)
                  : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF43054e),
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Color(0xFF43054e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Center(child: _buildImagemPerfil()),
              SizedBox(height: 30),
              _buildCampo('Nome', nomeController),
              _buildCampo('Celular', celularController),
              _buildCampo('Experiências', experienciaController, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
