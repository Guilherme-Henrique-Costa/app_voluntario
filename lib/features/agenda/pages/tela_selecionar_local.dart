import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TelaSelecionarLocal extends StatefulWidget {
  const TelaSelecionarLocal({super.key});

  @override
  State<TelaSelecionarLocal> createState() => _TelaSelecionarLocalState();
}

class _TelaSelecionarLocalState extends State<TelaSelecionarLocal> {
  final LatLng _posicaoInicial = const LatLng(-15.7942, -47.8822);
  LatLng? _localSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Local no Mapa',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _posicaoInicial,
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() => _localSelecionado = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_localSelecionado != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _localSelecionado!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          if (_localSelecionado != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Confirmar Local',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context, _localSelecionado);
                },
              ),
            ),
        ],
      ),
    );
  }
}
