import 'package:app_voluntario/features/agenda/models/evento_model.dart';
import 'package:app_voluntario/features/agenda/pages/tela_selecionar_local.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class FormularioEvento extends StatefulWidget {
  final EventoModel? evento;
  final ValueChanged<EventoModel> onSalvar;

  const FormularioEvento({
    super.key,
    this.evento,
    required this.onSalvar,
  });

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  final _descricaoController = TextEditingController();
  final _horarioController = TextEditingController();
  final List<String> _statusOpcoes = ['Pendente', 'Confirmado', 'Concluído'];
  String _statusSelecionado = 'Pendente';
  LatLng? _localSelecionado;
  String? _cidadeSelecionada;

  @override
  void initState() {
    super.initState();
    final evento = widget.evento;
    if (evento != null) {
      _descricaoController.text = evento.descricao;
      _horarioController.text = evento.horario;
      _statusSelecionado = evento.status;
      _localSelecionado = evento.local;
      _cidadeSelecionada = evento.cidade;
    }
  }

  Future<void> _selecionarLocal() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaSelecionarLocal()),
    );
    if (resultado != null && resultado is LatLng) {
      final placemarks = await placemarkFromCoordinates(
        resultado.latitude,
        resultado.longitude,
      );
      setState(() {
        _localSelecionado = resultado;
        _cidadeSelecionada =
            placemarks.isNotEmpty ? placemarks.first.locality : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.evento == null ? 'Novo Compromisso' : 'Editar Compromisso'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextFormField(
              controller: _horarioController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Horário',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                final hora = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (hora != null)
                  _horarioController.text = hora.format(context);
              },
            ),
            DropdownButtonFormField<String>(
              value: _statusSelecionado,
              items: _statusOpcoes
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _statusSelecionado = v!),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _selecionarLocal,
              icon: const Icon(Icons.map),
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_descricaoController.text.isEmpty ||
                _horarioController.text.isEmpty) return;
            final evento = EventoModel(
              descricao: _descricaoController.text,
              horario: _horarioController.text,
              status: _statusSelecionado,
              latitude: _localSelecionado?.latitude,
              longitude: _localSelecionado?.longitude,
              cidade: _cidadeSelecionada,
            );
            widget.onSalvar(evento);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
