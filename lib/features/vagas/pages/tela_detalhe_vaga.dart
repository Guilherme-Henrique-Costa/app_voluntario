import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../agenda/services/salvar_evento_service.dart';
import '../models/vaga_candidatada_model.dart';
import '../models/vaga_instituicao_model.dart';
import '../services/candidatura_service.dart';

class TelaDetalheVaga extends StatefulWidget {
  final dynamic vaga; // aceita VagaInstituicao ou VagaCandidatada

  const TelaDetalheVaga({required this.vaga, super.key});

  @override
  State<TelaDetalheVaga> createState() => _TelaDetalheVagaState();
}

class _TelaDetalheVagaState extends State<TelaDetalheVaga> {
  final _candidaturaService = CandidaturaService();
  bool _carregando = false;
  double? latitude;
  double? longitude;

  bool get podeCandidatar => widget.vaga is VagaInstituicao;

  @override
  void initState() {
    super.initState();
    _inicializarLocalizacao();
  }

  Future<void> _inicializarLocalizacao() async {
    final vaga = widget.vaga;
    if (vaga.latitude != null && vaga.longitude != null) {
      setState(() {
        latitude = vaga.latitude;
        longitude = vaga.longitude;
      });
    } else if (vaga.localidade != null && vaga.localidade is String) {
      try {
        final results = await locationFromAddress(vaga.localidade as String);
        if (results.isNotEmpty) {
          setState(() {
            latitude = results.first.latitude;
            longitude = results.first.longitude;
          });
        }
      } catch (_) {}
    }
  }

  Future<void> _abrirNoMapa(double lat, double lng) async {
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Não foi possível abrir o mapa.'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _candidatar() async {
    setState(() => _carregando = true);
    try {
      // aqui você provavelmente recupera o voluntário logado via StorageService;
      // para manter o exemplo isolado, estou partindo do pressuposto de que
      // a tela que chama esta já impediu navegação sem login.
      // Substitua conforme seu fluxo.
      // final voluntario = await StorageService.obterAtual();
      // await _candidaturaService.candidatar(vagaId: widget.vaga.id, voluntarioId: voluntario.id!);

      // Exemplo genérico (substitua pelo código acima):
      await _candidaturaService.candidatar(
          vagaId: widget.vaga.id as int, voluntarioId: 0);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Candidatura enviada com sucesso!'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao enviar candidatura: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaga = widget.vaga;

    final String cargo = vaga.cargo;
    final String localidade = vaga.localidade;
    final String area = vaga.area;
    final String tipoVaga = vaga.tipoVaga;
    final String horario = vaga.horario;
    final String tempoVoluntariado = vaga.tempoVoluntariado;
    final String disponibilidade = vaga.disponibilidade;
    final String descricao = vaga.descricao;
    final String instituicao = vaga.instituicao.nome;
    final List<String> especificacoes =
        (vaga.especificacoes ?? const []).cast<String>();
    final DateTime? dataCandidatura =
        vaga is VagaCandidatada ? vaga.dataCandidatura : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(cargo, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[800],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      floatingActionButton: (latitude != null && longitude != null)
          ? FloatingActionButton.extended(
              backgroundColor: Colors.deepPurple,
              onPressed: () => _abrirNoMapa(latitude!, longitude!),
              icon: const Icon(Icons.map, color: Colors.white),
              label: const Text('Ver no mapa',
                  style: TextStyle(color: Colors.white)),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFE4D9FF), Color(0xFFD1C0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardInfo(
                children: [
                  _info('Instituição', instituicao, Icons.apartment),
                  _info('Localidade', localidade, Icons.location_on),
                  _info('Área', area, Icons.work_outline),
                  _info('Tipo de Vaga', tipoVaga, Icons.assignment_ind),
                  _info('Horário', horario, Icons.access_time),
                  _info('Tempo de Voluntariado', tempoVoluntariado,
                      Icons.hourglass_bottom),
                  _info(
                      'Disponibilidade', disponibilidade, Icons.calendar_today),
                  if (dataCandidatura != null)
                    _info(
                        'Candidatado em',
                        DateFormat('dd/MM/yyyy').format(dataCandidatura),
                        Icons.event_available),
                  const SizedBox(height: 16),
                  const Text('Descrição:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(descricao),
                  const SizedBox(height: 16),
                  if (especificacoes.isNotEmpty) ...[
                    const Text('Especificações:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    ...especificacoes.map((e) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_circle_outline,
                              color: Colors.green),
                          title: Text(e),
                        )),
                  ],
                  if (latitude != null && longitude != null) ...[
                    const SizedBox(height: 20),
                    const Text('Localização no mapa:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(latitude!, longitude!),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.app_voluntario',
                            ),
                            MarkerLayer(markers: [
                              Marker(
                                point: LatLng(latitude!, longitude!),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_pin,
                                    size: 40, color: Colors.red),
                              )
                            ])
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              if (podeCandidatar)
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send, color: Colors.white),
                    label: Text(_carregando ? 'Enviando...' : 'Candidatar-se',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: _carregando ? null : _candidatar,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardInfo({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _info(String titulo, String valor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple[300]),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(valor, style: const TextStyle(fontSize: 14)),
            ]),
          ),
        ],
      ),
    );
  }
}
