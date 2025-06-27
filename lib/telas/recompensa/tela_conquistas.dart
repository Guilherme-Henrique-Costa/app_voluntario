import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Conquista {
  final String titulo;
  final String categoria;
  final int progresso; // de 0 a 100
  final String descricao;

  Conquista({
    required this.titulo,
    required this.categoria,
    required this.progresso,
    required this.descricao,
  });
}

class TelaConquistas extends StatefulWidget {
  @override
  _TelaConquistasState createState() => _TelaConquistasState();
}

class _TelaConquistasState extends State<TelaConquistas>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  String _filtroStatus = 'Todas';

  final List<Map<String, dynamic>> conquistas = [
    {
      'titulo': 'Primeira Missão',
      'descricao': 'Complete sua primeira atividade voluntária.',
      'categoria': 'Geral',
      'concluido': true,
      'progresso': 1.0
    },
    {
      'titulo': '5 Atividades',
      'descricao': 'Participe de 5 atividades voluntárias.',
      'categoria': 'Atividades',
      'concluido': false,
      'progresso': 0.6
    },
    {
      'titulo': 'Evento Especial',
      'descricao': 'Contribua em um evento especial.',
      'categoria': 'Eventos',
      'concluido': true,
      'progresso': 1.0
    },
  ];

  List<String> categorias = ['Geral', 'Atividades', 'Eventos'];
  List<String> status = ['Todas', 'Concluídas', 'Pendentes'];

  List<Map<String, dynamic>> get conquistasFiltradas {
    final categoria = categorias[_tabIndex];
    return conquistas.where((c) {
      final statusMatch = _filtroStatus == 'Todas' ||
          (_filtroStatus == 'Concluídas' && c['concluido']) ||
          (_filtroStatus == 'Pendentes' && !c['concluido']);
      return c['categoria'] == categoria && statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categorias.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Conquistas'),
          backgroundColor: Colors.deepPurple[900],
          bottom: TabBar(
            onTap: (index) => setState(() => _tabIndex = index),
            tabs: categorias.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Text('Filtrar por status: ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _filtroStatus,
                    items: status
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _filtroStatus = val!;
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: conquistasFiltradas.isEmpty
                  ? Center(child: Text('Nenhuma conquista encontrada.'))
                  : ListView.builder(
                      itemCount: conquistasFiltradas.length,
                      itemBuilder: (context, index) {
                        final c = conquistasFiltradas[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: c['concluido']
                                ? Lottie.asset(
                                    'assets/animations/confetti.json',
                                    width: 50,
                                    height: 50,
                                    repeat: false,
                                  )
                                : Icon(Icons.star_border, size: 40),
                            title: Text(c['titulo'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['descricao']),
                                SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: c['progresso'],
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.deepPurple),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${(c['progresso'] * 100).toInt()}% concluído',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
