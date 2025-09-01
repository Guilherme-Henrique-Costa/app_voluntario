import 'package:app_voluntario/features/vagas/models/vaga_candidatada_model.dart';
import 'package:app_voluntario/features/vagas/services/candidatura_service.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:app_voluntario/features/agenda/pages/tela_visualizar_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_voluntario/features/agenda/services/salvar_evento_service.dart';
import 'package:app_voluntario/features/vagas/pages/tela_detalhe_vaga.dart';
import 'dart:developer';

class TelaMinhasVagas extends StatefulWidget {
  @override
  State<TelaMinhasVagas> createState() => _TelaMinhasVagasState();
}

class _TelaMinhasVagasState extends State<TelaMinhasVagas> {
  List<VagaCandidatada> _vagas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCandidaturas();
  }

  Future<void> _carregarCandidaturas() async {
    try {
      final voluntario = await StorageService.obterAtual();
      if (voluntario == null || voluntario.id == null) {
        throw Exception('Voluntário inválido');
      }

      final response = await CandidaturaService()
          .buscarCandidaturasDoVoluntario(voluntario.id!);

      if (response is! List) {
        throw Exception("Resposta da API não é uma lista válida");
      }

      final lista = response.cast<VagaCandidatada>();

      setState(() {
        _vagas = lista;
        _carregando = false;
      });
    } catch (e, stacktrace) {
      log('Erro ao carregar vagas: $e', stackTrace: stacktrace);
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar vagas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _adicionarNaAgenda(VagaCandidatada vaga) async {
    final dia = vaga.dataCandidatura ?? DateTime.now();

    final evento = {
      'descricao': vaga.cargo,
      'horario': vaga.horario,
      'status': 'Confirmado',
      'cidade': vaga.localidade,
      'latitude': vaga.latitude,
      'longitude': vaga.longitude,
    };

    await EventoService().adicionarEvento(dia, evento);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adicionado à agenda!')),
    );
  }

  Future<void> _cancelarCandidatura(int idVaga) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar cancelamento'),
        content: const Text('Deseja realmente cancelar sua candidatura?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmacao != true) return;

    final voluntario = await StorageService.obterAtual();
    if (voluntario == null) return;

    final sucesso =
        await CandidaturaService().cancelarCandidatura(idVaga, voluntario.id!);

    if (sucesso) {
      setState(() {
        _vagas.removeWhere((v) => v.id == idVaga);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Candidatura cancelada.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cancelar candidatura.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Minhas Vagas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _carregando
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
              child: _vagas.isEmpty
                  ? const Center(
                      child:
                          Text('Você ainda não se candidatou a nenhuma vaga.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _vagas.length,
                      itemBuilder: (context, index) {
                        final vaga = _vagas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(vaga.cargo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Instituição: ${vaga.instituicao.nome}'),
                                Text('Local: ${vaga.localidade}'),
                                if (vaga.dataCandidatura != null)
                                  Text(
                                      'Candidatado em: ${DateFormat('dd/MM/yyyy').format(vaga.dataCandidatura!)}'),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (valor) async {
                                if (valor == 'agenda') {
                                  await _adicionarNaAgenda(vaga);
                                } else if (valor == 'cancelar') {
                                  await _cancelarCandidatura(vaga.id);
                                } else if (valor == 'mapa') {
                                  if (vaga.latitude != null &&
                                      vaga.longitude != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TelaVisualizarLocal(
                                          latitude: vaga.latitude!,
                                          longitude: vaga.longitude!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Coordenadas não disponíveis para esta vaga.'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'agenda',
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 18),
                                      SizedBox(width: 8),
                                      Text('Adicionar à agenda')
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'mapa',
                                  child: Row(
                                    children: [
                                      Icon(Icons.map, size: 18),
                                      SizedBox(width: 8),
                                      Text('Ver no mapa')
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'cancelar',
                                  child: Row(
                                    children: [
                                      Icon(Icons.cancel, size: 18),
                                      SizedBox(width: 8),
                                      Text('Cancelar candidatura')
                                    ],
                                  ),
                                ),
                              ],
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
