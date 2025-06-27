import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TelaVisualizarLocal extends StatelessWidget {
  final double latitude;
  final double longitude;

  const TelaVisualizarLocal({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng local = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('Local do Compromisso'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: local,
          initialZoom: 15,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all,
          ),
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
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
