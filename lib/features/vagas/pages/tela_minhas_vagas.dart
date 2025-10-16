import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/storage_service.dart';
import '../../agenda/pages/tela_visualizar_local.dart';
import '../../agenda/services/salvar_evento_service.dart';
import '../models/vaga_candidatada_model.dart';
import '../pages/tela_detalhe_vaga.dart';
import '../services/candidatura_service.dart';

class TelaMinhasVagas extends StatefulWidget {
  const TelaMinhasVagas({super.key});

  @override
  State<TelaMinhasVagas> createState() => _TelaMinhasVagasState();
}

class _TelaMinhasVagasState extends State<TelaMinhasVagas> {
  final _service = CandidaturaService();
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

      final lista =
          await _service.buscarCandidaturasDoVoluntario(voluntario.id!);

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
            backgroundColor: Colors.red),
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
              child: const Text('Não')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sim')),
        ],
      ),
    );

    if (confirmacao != true) return;

    final voluntario = await StorageService.obterAtual();
    if (voluntario == null) return;

    final sucesso = await _service.cancelarCandidatura(idVaga, voluntario.id!);

    if (!mounted) return;

    if (sucesso) {
      setState(() => _vagas.removeWhere((v) => v.id == idVaga));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Candidatura cancelada.'),
            backgroundColor: Colors.orange),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao cancelar candidatura.'),
            backgroundColor: Colors.red),
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
                  colors: [Colors.white, Color(0xFFEAC6F8), Color(0xFFCAA8FD)],
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
                                switch (valor) {
                                  case 'agenda':
                                    await _adicionarNaAgenda(vaga);
                                    break;
                                  case 'mapa':
                                    if (vaga.latitude != null &&
                                        vaga.longitude != null) {
                                      if (!mounted) return;
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Coordenadas não disponíveis para esta vaga.'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                    break;
                                  case 'cancelar':
                                    await _cancelarCandidatura(vaga.id);
                                    break;
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'agenda',
                                  child: Row(children: [
                                    Icon(Icons.calendar_today, size: 18),
                                    SizedBox(width: 8),
                                    Text('Adicionar à agenda')
                                  ]),
                                ),
                                PopupMenuItem(
                                  value: 'mapa',
                                  child: Row(children: [
                                    Icon(Icons.map, size: 18),
                                    SizedBox(width: 8),
                                    Text('Ver no mapa')
                                  ]),
                                ),
                                PopupMenuItem(
                                  value: 'cancelar',
                                  child: Row(children: [
                                    Icon(Icons.cancel, size: 18),
                                    SizedBox(width: 8),
                                    Text('Cancelar candidatura')
                                  ]),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          TelaDetalheVaga(vaga: vaga)));
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
