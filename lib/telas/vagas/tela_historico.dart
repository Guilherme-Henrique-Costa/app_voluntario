import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaHistorico extends StatefulWidget {
  @override
  _TelaHistoricoState createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  String filtroStatus = 'Todos';
  String filtroInstituicao = 'Todas';
  bool ordenarPorDataAsc = false;

  final List<Map<String, dynamic>> todasAsVagas = [
    {
      'titulo': 'Distribuição de Alimentos',
      'cargo': 'Ajudante Geral',
      'localidade': 'Centro Comunitário - Brasília',
      'descricao': 'Ajuda na entrega de cestas básicas.',
      'especificacoes': ['Ser pontual', 'Capacidade física para carregar peso'],
      'data': '2025-05-10',
      'status': 'Concluído',
      'instituicao': 'Cruz Vermelha'
    },
    {
      'titulo': 'Campanha de Doação de Sangue',
      'cargo': 'Auxiliar de Triagem',
      'localidade': 'Hospital Vida - Taguatinga',
      'descricao': 'Triagem e orientação.',
      'especificacoes': ['Boa comunicação', 'Conhecimento básico em saúde'],
      'data': '2025-04-22',
      'status': 'Concluído',
      'instituicao': 'Hospital Vida'
    },
    {
      'titulo': 'Mutirão de Limpeza',
      'cargo': 'Voluntário de Limpeza',
      'localidade': 'Praça Central',
      'descricao': 'Limpeza de praça pública.',
      'especificacoes': ['Levar luvas', 'Estar disponível no sábado'],
      'data': '2025-03-15',
      'status': 'Concluído',
      'instituicao': 'Prefeitura Local'
    },
    {
      'titulo': 'Apoio em Eventos Comunitários',
      'cargo': 'Organizador de Eventos',
      'localidade': 'Quadra 301 Norte',
      'descricao': 'Organização de filas e auxílio logístico.',
      'especificacoes': ['Ser proativo', 'Boa comunicação'],
      'data': '2025-07-01',
      'status': 'Candidatado',
      'instituicao': 'Cruz Vermelha'
    },
    {
      'titulo': 'Voluntário de Comunicação',
      'cargo': 'Designer Social',
      'localidade': 'SESC Asa Sul',
      'descricao': 'Divulgação das ações e cobertura do evento.',
      'especificacoes': ['Saber usar redes sociais', 'Edição básica de imagem'],
      'data': '2025-06-15',
      'status': 'Candidatado',
      'instituicao': 'ONG Jovem Ação'
    },
  ];

  List<String> get instituicoesDisponiveis {
    final insts =
        todasAsVagas.map((e) => e['instituicao'] as String).toSet().toList();
    insts.sort();
    return ['Todas', ...insts];
  }

  List<Map<String, dynamic>> get vagasFiltradas {
    List<Map<String, dynamic>> filtradas = todasAsVagas;

    if (filtroStatus != 'Todos') {
      filtradas = filtradas.where((v) => v['status'] == filtroStatus).toList();
    }

    if (filtroInstituicao != 'Todas') {
      filtradas = filtradas
          .where((v) => v['instituicao'] == filtroInstituicao)
          .toList();
    }

    filtradas.sort((a, b) {
      DateTime dataA = DateTime.parse(a['data']);
      DateTime dataB = DateTime.parse(b['data']);
      return ordenarPorDataAsc
          ? dataA.compareTo(dataB)
          : dataB.compareTo(dataA);
    });

    return filtradas;
  }

  String formatarData(String data) {
    final parsed = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Voluntariado'),
        backgroundColor: Colors.deepPurple[900],
        actions: [
          IconButton(
            icon: Icon(
                ordenarPorDataAsc ? Icons.arrow_upward : Icons.arrow_downward),
            tooltip: 'Ordenar por data',
            onPressed: () {
              setState(() {
                ordenarPorDataAsc = !ordenarPorDataAsc;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DropdownButton<String>(
                  value: filtroStatus,
                  onChanged: (value) {
                    setState(() {
                      filtroStatus = value!;
                    });
                  },
                  items: ['Todos', 'Candidatado', 'Concluído']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: filtroInstituicao,
                  onChanged: (value) {
                    setState(() {
                      filtroInstituicao = value!;
                    });
                  },
                  items: instituicoesDisponiveis
                      .map((inst) => DropdownMenuItem(
                            value: inst,
                            child: Text(inst),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: vagasFiltradas.isEmpty
                ? Center(child: Text('Nenhuma vaga encontrada.'))
                : ListView.builder(
                    itemCount: vagasFiltradas.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final vaga = vagasFiltradas[index];
                      final especificacoes =
                          List<String>.from(vaga['especificacoes']);

                      return Card(
                        child: ListTile(
                          title: Text(vaga['titulo']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cargo: ${vaga['cargo']}'),
                              Text('Localidade: ${vaga['localidade']}'),
                              Text('Descrição: ${vaga['descricao']}'),
                              Text('Instituição: ${vaga['instituicao']}'),
                              Text('Status: ${vaga['status']}'),
                              Text('Data: ${formatarData(vaga['data'])}'),
                              SizedBox(height: 6),
                              Text('Especificações:'),
                              ...especificacoes.map((item) => Text('- $item')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
