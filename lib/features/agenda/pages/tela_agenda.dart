import 'package:app_voluntario/features/agenda/pages/widgets/card_evento.dart';
import 'package:app_voluntario/features/agenda/pages/widgets/formulario_evento.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../controllers/evento_controller.dart';
import '../models/evento_model.dart';

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // carregamos os eventos ao abrir a tela
    Future.microtask(() => Provider.of<EventoController>(context, listen: false)
        .carregarEventos());
  }

  void _abrirDialogo({EventoModel? evento}) {
    showDialog(
      context: context,
      builder: (context) => FormularioEvento(
        evento: evento,
        onSalvar: (novoEvento) async {
          final controller =
              Provider.of<EventoController>(context, listen: false);

          if (evento == null) {
            // novo evento
            await controller.adicionarEvento(novoEvento);
          } else {
            // edição
            final eventoAtualizado = EventoModel(
              id: evento.id,
              descricao: novoEvento.descricao,
              horario: novoEvento.horario,
              status: novoEvento.status,
              latitude: novoEvento.latitude,
              longitude: novoEvento.longitude,
              cidade: novoEvento.cidade,
            );

            await controller.atualizarEvento(eventoAtualizado);
          }

          if (!mounted) return;
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EventoController>(context);
    final eventos = controller.eventos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _abrirDialogo(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: controller.carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: controller.carregarEventos,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    TableCalendar(
                      locale: 'pt_BR',
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2026, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                            color: Colors.deepPurple, shape: BoxShape.circle),
                        selectedDecoration: BoxDecoration(
                            color: Colors.amber, shape: BoxShape.circle),
                      ),
                    ),
                    const SizedBox(height: 16),
                    eventos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Nenhum compromisso encontrado.'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: eventos.length,
                            itemBuilder: (context, index) {
                              final evento = eventos[index];
                              return CardEvento(
                                evento: evento,
                                onEditar: () => _abrirDialogo(evento: evento),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
