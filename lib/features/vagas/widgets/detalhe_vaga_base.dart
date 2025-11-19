import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_theme.dart';

class DetalheVagaBase extends StatelessWidget {
  final String cargo;
  final String instituicao;
  final String localidade;
  final String area;
  final String tipoVaga;
  final String horario;
  final String tempoVoluntariado;
  final String disponibilidade;
  final String descricao;
  final List<String> especificacoes;
  final DateTime? dataCandidatura;
  final double? latitude;
  final double? longitude;

  const DetalheVagaBase({
    super.key,
    required this.cargo,
    required this.instituicao,
    required this.localidade,
    required this.area,
    required this.tipoVaga,
    required this.horario,
    required this.tempoVoluntariado,
    required this.disponibilidade,
    required this.descricao,
    required this.especificacoes,
    this.dataCandidatura,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardInfo(context, [
              _info('Instituição', instituicao, Icons.apartment),
              _info('Localidade', localidade, Icons.location_on),
              _info('Área', area, Icons.work_outline),
              _info('Tipo de Vaga', tipoVaga, Icons.assignment_ind),
              _info('Horário', horario, Icons.access_time),
              _info('Tempo de Voluntariado', tempoVoluntariado,
                  Icons.hourglass_bottom),
              _info('Disponibilidade', disponibilidade, Icons.calendar_today),
              if (dataCandidatura != null)
                _info(
                  'Candidatado em',
                  DateFormat('dd/MM/yyyy').format(dataCandidatura!),
                  Icons.event_available,
                ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Descrição:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(descricao),
              const SizedBox(height: AppSpacing.md),
              if (especificacoes.isNotEmpty) ...[
                const Text(
                  'Especificações:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...especificacoes.map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline,
                        color: Colors.green),
                    title: Text(e),
                  ),
                ),
              ],
              if (latitude != null && longitude != null) ...[
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Localização no mapa:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
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
                          userAgentPackageName: 'com.example.app_voluntario',
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
            ]),
          ],
        ),
      ),
    );
  }

  Widget _cardInfo(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _info(String titulo, String valor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.6)),
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
          ),
        ],
      ),
    );
  }
}
