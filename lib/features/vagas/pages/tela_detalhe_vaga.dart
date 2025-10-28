import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_theme.dart';
import '../../agenda/services/salvar_evento_service.dart';
import '../models/vaga_candidatada_model.dart';
import '../models/vaga_instituicao_model.dart';
import '../services/candidatura_service.dart';
import '../widgets/detalhe_vaga_base.dart';

class TelaDetalheVaga extends StatefulWidget {
  final dynamic vaga;

  const TelaDetalheVaga({super.key, required this.vaga});

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
      } catch (e) {
        debugPrint('Erro ao localizar endereço: $e');
      }
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _candidatar() async {
    setState(() => _carregando = true);
    try {
      // TODO: substituir pelo fluxo real de voluntário logado
      await _candidaturaService.candidatar(
        vagaId: widget.vaga.id as int,
        voluntarioId: 0,
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
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaga = widget.vaga;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          vaga.cargo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      floatingActionButton: (latitude != null && longitude != null)
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () => _abrirNoMapa(latitude!, longitude!),
              icon: const Icon(Icons.map, color: Colors.white),
              label: const Text('Ver no mapa',
                  style: TextStyle(color: Colors.white)),
            )
          : null,
      body: DetalheVagaBase(
        cargo: vaga.cargo,
        instituicao: vaga.instituicao.nome,
        localidade: vaga.localidade,
        area: vaga.area,
        tipoVaga: vaga.tipoVaga,
        horario: vaga.horario,
        tempoVoluntariado: vaga.tempoVoluntariado,
        disponibilidade: vaga.disponibilidade,
        descricao: vaga.descricao,
        especificacoes: (vaga.especificacoes ?? const []).cast<String>(),
        dataCandidatura: vaga is VagaCandidatada ? vaga.dataCandidatura : null,
        latitude: latitude,
        longitude: longitude,
      ),
      bottomNavigationBar: podeCandidatar
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: _carregando ? null : _candidatar,
              ),
            )
          : null,
    );
  }
}
