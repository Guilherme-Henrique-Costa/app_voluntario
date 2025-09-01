import 'package:flutter/material.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/vagas/models/vaga_candidatada_model.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:app_voluntario/features/vagas/services/vaga_voluntario_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class TelaDetalheVaga extends StatefulWidget {
  final dynamic vaga;

  const TelaDetalheVaga({required this.vaga, super.key});

  @override
  State<TelaDetalheVaga> createState() => _TelaDetalheVagaState();
}

class _TelaDetalheVagaState extends State<TelaDetalheVaga> {
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
    } else if (vaga.localidade != null) {
      try {
        final results = await locationFromAddress(vaga.localidade);
        if (results.isNotEmpty) {
          setState(() {
            latitude = results.first.latitude;
            longitude = results.first.longitude;
          });
        }
      } catch (e) {
        debugPrint('Erro ao geocodificar: $e');
      }
    }
  }

  Future<void> _candidatar() async {
    setState(() => _carregando = true);

    try {
      final voluntario = await StorageService.obterAtual();
      if (voluntario == null) throw Exception("Voluntário não autenticado");

      await VagasVoluntariasService().candidatar(
        vagaId: widget.vaga.id,
        voluntarioId: voluntario.id!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Candidatura enviada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar candidatura: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _abrirNoMapa(double lat, double lng) async {
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o mapa.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaga = widget.vaga;

    final cargo = vaga.cargo;
    final localidade = vaga.localidade;
    final area = vaga.area;
    final tipoVaga = vaga.tipoVaga;
    final horario = vaga.horario;
    final tempoVoluntariado = vaga.tempoVoluntariado;
    final disponibilidade = vaga.disponibilidade;
    final descricao = vaga.descricao;
    final instituicao = vaga.instituicao.nome;
    final especificacoes = vaga.especificacoes ?? [];
    final dataCandidatura =
        vaga is VagaCandidatada ? vaga.dataCandidatura : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cargo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[800],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      floatingActionButton: (latitude != null && longitude != null)
          ? FloatingActionButton.extended(
              backgroundColor: Colors.deepPurple,
              onPressed: () => _abrirNoMapa(latitude!, longitude!),
              icon: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              label: const Text(
                'Ver no mapa',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAF5FF),
              Color(0xFFE4D9FF),
              Color(0xFFD1C0FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoWithIcon(Icons.apartment, 'Instituição', instituicao),
                    _infoWithIcon(Icons.location_on, 'Localidade', localidade),
                    _infoWithIcon(Icons.work_outline, 'Área', area),
                    _infoWithIcon(
                        Icons.assignment_ind, 'Tipo de Vaga', tipoVaga),
                    _infoWithIcon(Icons.access_time, 'Horário', horario),
                    _infoWithIcon(Icons.hourglass_bottom,
                        'Tempo de Voluntariado', tempoVoluntariado),
                    _infoWithIcon(Icons.calendar_today, 'Disponibilidade',
                        disponibilidade),
                    if (dataCandidatura != null)
                      _infoWithIcon(Icons.event_available, 'Candidatado em',
                          DateFormat('dd/MM/yyyy').format(dataCandidatura)),
                    const SizedBox(height: 16),
                    const Text('Descrição:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(descricao, style: TextStyle(color: Colors.grey[800])),
                    const SizedBox(height: 16),
                    if (especificacoes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Especificações:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          ...especificacoes.map(
                            (e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.check_circle_outline,
                                  color: Colors.green),
                              title: Text(e),
                            ),
                          ),
                        ],
                      ),
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
                      )
                    ]
                  ],
                ),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      _carregando ? 'Enviando...' : 'Candidatar-se',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: _carregando ? null : _candidatar,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoWithIcon(IconData icon, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple[300]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(valor, style: const TextStyle(fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
