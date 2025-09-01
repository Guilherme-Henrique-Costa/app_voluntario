import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Conquista {
  final String titulo;
  final String categoria;
  final int progresso;
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
          title:
              const Text('Conquistas', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple[900],
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            onTap: (index) => setState(() => _tabIndex = index),
            tabs: categorias.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Text('Filtrar por status:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
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
                  ? const Center(
                      child: Text(
                        'Nenhuma conquista encontrada.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: conquistasFiltradas.length,
                      itemBuilder: (context, index) {
                        final c = conquistasFiltradas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                c['concluido']
                                    ? Lottie.asset(
                                        'assets/animations/confetti.json',
                                        width: 50,
                                        height: 50,
                                        repeat: false,
                                      )
                                    : Icon(Icons.star_border,
                                        size: 50,
                                        color: Colors.deepPurple[300]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(c['titulo'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(c['descricao']),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: c['progresso'],
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.deepPurple),
                                        minHeight: 6,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(c['progresso'] * 100).toInt()}% concluído',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
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
