import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TelaAgenda extends StatefulWidget {
  @override
  _TelaAgendaState createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _eventos = {
    DateTime.utc(2025, 6, 10): ['Reunião com instituição'],
    DateTime.utc(2025, 6, 12): ['Visita a abrigo'],
  };

  final TextEditingController _eventoController = TextEditingController();

  List<String> _getEventosDoDia(DateTime dia) {
    return _eventos[dia] ?? [];
  }

  void _adicionarEvento(String evento) {
    final dia = _selectedDay ?? _focusedDay;
    if (evento.trim().isEmpty) return;

    setState(() {
      _eventos.putIfAbsent(dia, () => []);
      _eventos[dia]!.add(evento);
      _eventoController.clear();
    });
  }

  void _abrirDialogoAdicionarEvento() {
    _eventoController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo compromisso'),
        content: TextField(
          controller: _eventoController,
          decoration: InputDecoration(hintText: 'Digite o compromisso'),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Adicionar'),
            onPressed: () {
              _adicionarEvento(_eventoController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _abrirMenuEditarOuRemover(String textoOriginal, int index) {
    _eventoController.text = textoOriginal;

    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar'),
            onTap: () {
              Navigator.pop(context);
              _abrirDialogoEdicao(textoOriginal, index);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Remover'),
            onTap: () {
              _removerEvento(index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _abrirDialogoEdicao(String textoOriginal, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar compromisso'),
        content: TextField(
          controller: _eventoController,
          decoration: InputDecoration(hintText: 'Altere o compromisso'),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Salvar'),
            onPressed: () {
              _editarEvento(index, _eventoController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _editarEvento(int index, String novoTexto) {
    final dia = _selectedDay ?? _focusedDay;
    if (novoTexto.trim().isEmpty) return;

    setState(() {
      _eventos[dia]![index] = novoTexto;
    });
  }

  void _removerEvento(int index) {
    final dia = _selectedDay ?? _focusedDay;
    setState(() {
      _eventos[dia]!.removeAt(index);
      if (_eventos[dia]!.isEmpty) {
        _eventos.remove(dia);
      }
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
            Container(
              height: 300,
              child: eventos.isEmpty
                  ? Center(child: Text('Nenhum compromisso marcado.'))
                  : ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(Icons.event),
                        title: Text(eventos[index]),
                        onLongPress: () =>
                            _abrirMenuEditarOuRemover(eventos[index], index),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
