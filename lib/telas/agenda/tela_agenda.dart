import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tela_selecionar_local.dart';
import 'tela_visualizar_local.dart';

class TelaAgenda extends StatefulWidget {
  @override
  _TelaAgendaState createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _eventos = {};

  final _descricaoController = TextEditingController();
  final _horarioController = TextEditingController();
  String _statusSelecionado = 'Pendente';
  LatLng? _localSelecionado;
  String? _cidadeSelecionada;

  final List<String> _statusOpcoes = ['Pendente', 'Confirmado', 'Concluído'];

  List<Map<String, dynamic>> _getEventosDoDia(DateTime dia) {
    return _eventos[dia] ?? [];
  }

  void _abrirDialogoAdicionarEvento() {
    _descricaoController.clear();
    _horarioController.clear();
    _statusSelecionado = 'Pendente';
    _localSelecionado = null;
    _cidadeSelecionada = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo Compromisso'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _horarioController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Horário',
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (hora != null) {
                    _horarioController.text = hora.format(context);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                items: _statusOpcoes.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _statusSelecionado = valor!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TelaSelecionarLocal()),
                  );
                  if (resultado != null && resultado is LatLng) {
                    setState(() {
                      _localSelecionado = resultado;
                    });
                    final placemarks = await placemarkFromCoordinates(
                      resultado.latitude,
                      resultado.longitude,
                    );
                    if (placemarks.isNotEmpty) {
                      setState(() {
                        _cidadeSelecionada = placemarks.first.locality;
                      });
                    }
                  }
                },
                icon: Icon(Icons.map),
                label: Text(_localSelecionado == null
                    ? 'Selecionar Local'
                    : 'Local Selecionado'),
              ),
              if (_cidadeSelecionada != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Cidade: $_cidadeSelecionada'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _adicionarEvento();
              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _adicionarEvento() {
    final dia = _selectedDay ?? _focusedDay;
    final evento = {
      'descricao': _descricaoController.text,
      'horario': _horarioController.text,
      'status': _statusSelecionado,
      'latitude': _localSelecionado?.latitude,
      'longitude': _localSelecionado?.longitude,
      'cidade': _cidadeSelecionada,
    };

    if ((evento['descricao'] ?? '').toString().trim().isEmpty) return;

    setState(() {
      _eventos.putIfAbsent(dia, () => []);
      _eventos[dia]!.add(evento);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventos = _getEventosDoDia(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: Colors.deepPurple[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirDialogoAdicionarEvento,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            TableCalendar(
              locale: 'pt_BR',
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Colors.deepPurple, shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Compromissos do dia:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            eventos.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Nenhum compromisso marcado.'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      final evento = eventos[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(evento['descricao'] ?? '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Horário: ${evento['horario']}'),
                                Text('Status: ${evento['status']}'),
                                if (evento['cidade'] != null)
                                  Text('Local: ${evento['cidade']}'),
                                if (evento['latitude'] != null)
                                  Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Container(
                                        height: 120,
                                        child: FlutterMap(
                                          options: MapOptions(
                                            initialCenter: LatLng(
                                              evento['latitude'],
                                              evento['longitude'],
                                            ),
                                            initialZoom: 14,
                                            interactionOptions:
                                                InteractionOptions(
                                              flags: ~InteractiveFlag.all,
                                            ),
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.example.app_voluntario',
                                            ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: LatLng(
                                                      evento['latitude'],
                                                      evento['longitude']),
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(Icons.location_on,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      TelaVisualizarLocal(
                                                    latitude:
                                                        evento['latitude'],
                                                    longitude:
                                                        evento['longitude'],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.map),
                                            label: Text('Ver no mapa'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 10),
                                              textStyle:
                                                  TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                              ]),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
