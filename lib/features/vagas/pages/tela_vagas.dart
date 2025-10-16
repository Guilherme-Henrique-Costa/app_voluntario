import 'package:flutter/material.dart';

import '../models/vaga_instituicao_model.dart';
import '../services/vaga_instituicao_service.dart';
import 'tela_detalhe_vaga.dart';

class TelaVagas extends StatefulWidget {
  const TelaVagas({super.key});

  @override
  State<TelaVagas> createState() => _TelaVagasState();
}

class _TelaVagasState extends State<TelaVagas> {
  final _service = VagaInstituicaoService();
  List<VagaInstituicao> _vagas = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarVagas();
  }

  Future<void> _carregarVagas() async {
    setState(() => _carregando = true);
    try {
      final lista = await _service.listarVagasDisponiveis();
      setState(() => _vagas = lista);
    } catch (e) {
      debugPrint('Erro ao carregar vagas: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar vagas')),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vagas Disponíveis',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFEAC6F8), Color(0xFFCAA8FD)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: _vagas.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final vaga = _vagas[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(vaga.cargo,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Local: ${vaga.localidade}'),
                          Text('Instituição: ${vaga.instituicao.nome}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.deepPurple),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TelaDetalheVaga(vaga: vaga)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
