import 'package:app_voluntario/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/servicos/vaga_instituicao_service.dart';
import 'package:app_voluntario/telas/vagas/tela_detalhe_vaga.dart';
import 'package:flutter/material.dart';

class TelaVagas extends StatefulWidget {
  @override
  _TelaVagasState createState() => _TelaVagasState();
}

class _TelaVagasState extends State<TelaVagas> {
  List<VagaInstituicao> vagas = [];
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarVagas();
  }

  Future<void> carregarVagas() async {
    setState(() => carregando = true);
    try {
      final lista = await VagaInstituicaoService().listarVagasDisponiveis();
      setState(() => vagas = lista);
    } catch (e) {
      debugPrint('Erro ao carregar vagas: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vagas Disponíveis',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Color.fromARGB(255, 234, 198, 248),
                    Color.fromARGB(255, 202, 168, 253),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: vagas.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final vaga = vagas[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        vaga.cargo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Local: ${vaga.localidade}'),
                          Text('Instituição: ${vaga.instituicao.nome}'),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.deepPurple,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaDetalheVaga(vaga: vaga),
                          ),
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
