import 'package:app_voluntario/features/agenda/controllers/evento_controller.dart';
import 'package:app_voluntario/features/agenda/models/evento_model.dart';
import 'package:app_voluntario/features/agenda/pages/tela_visualizar_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CardEvento extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback onEditar;

  const CardEvento({
    super.key,
    required this.evento,
    required this.onEditar,
  });

  Future<void> _confirmarExclusao(BuildContext context) async {
    final controller = Provider.of<EventoController>(context, listen: false);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text('Tem certeza que deseja excluir "${evento.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true && evento.id != null) {
      await controller.removerEvento(evento.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído com sucesso!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com título e ações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    evento.descricao,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      tooltip: 'Editar',
                      onPressed: onEditar,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Excluir',
                      onPressed: () => _confirmarExclusao(context),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text('Horário: ${evento.horario}'),
            Text('Status: ${evento.status}'),
            if (evento.cidade != null) Text('Local: ${evento.cidade}'),

            // Exibe o mapa se houver coordenadas
            if (evento.local != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 120,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: evento.local!,
                          initialZoom: 14,
                          interactionOptions: const InteractionOptions(
                            flags: ~InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              point: evento.local!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.red),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaVisualizarLocal(
                              latitude: evento.latitude!,
                              longitude: evento.longitude!,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.map),
                        label: const Text('Ver no mapa'),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
