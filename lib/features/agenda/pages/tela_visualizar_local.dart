import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaVisualizarLocal extends StatefulWidget {
  final double latitude;
  final double longitude;

  const TelaVisualizarLocal({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<TelaVisualizarLocal> createState() => _TelaVisualizarLocalState();
}

class _TelaVisualizarLocalState extends State<TelaVisualizarLocal> {
  String? _endereco;

  @override
  void initState() {
    super.initState();
    _obterEndereco();
  }

  Future<void> _obterEndereco() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        widget.latitude,
        widget.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() => _endereco = '${p.street}, ${p.locality}');
      }
    } catch (_) {}
  }

  Future<void> _abrirNoMaps() async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final local = LatLng(widget.latitude, widget.longitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local do Compromisso',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
        actions: [
          IconButton(
            onPressed: _abrirNoMaps,
            icon: const Icon(Icons.map),
          )
        ],
      ),
      body: Column(
        children: [
          if (_endereco != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_endereco!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: local,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: local,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
