import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaVisualizarLocal extends StatefulWidget {
  final double latitude;
  final double longitude;

  const TelaVisualizarLocal({
    required this.latitude,
    required this.longitude,
  });

  @override
  _TelaVisualizarLocalState createState() => _TelaVisualizarLocalState();
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
        setState(() {
          _endereco = '${p.street}, ${p.subLocality}, ${p.locality}';
        });
      }
    } catch (e) {
      print('Erro ao obter endereço: $e');
    }
  }

  Future<void> _abrirGoogleMaps() async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng local = LatLng(widget.latitude, widget.longitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local do Compromisso',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'Abrir no Google Maps',
            onPressed: _abrirGoogleMaps,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_endereco != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _endereco!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: local,
                initialZoom: 15,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app_voluntario',
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
