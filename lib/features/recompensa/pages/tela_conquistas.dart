import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import '../models/conquista.dart';
import '../widgets/conquista_card.dart';
import '../widgets/filtro_status.dart';
import '../widgets/nenhuma_conquista.dart';

class TelaConquistas extends StatefulWidget {
  const TelaConquistas({super.key});

  @override
  State<TelaConquistas> createState() => _TelaConquistasState();
}

class _TelaConquistasState extends State<TelaConquistas>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  String _filtroStatus = 'Todas';

  final List<String> _categorias = ['Geral', 'Atividades', 'Eventos'];
  final List<String> _statusOpcoes = ['Todas', 'Concluídas', 'Pendentes'];

  final List<Conquista> _todasConquistas = const [
    Conquista(
      titulo: 'Primeira Missão',
      descricao: 'Complete sua primeira atividade voluntária.',
      categoria: 'Geral',
      progresso: 1.0,
      concluido: true,
    ),
    Conquista(
      titulo: '5 Atividades',
      descricao: 'Participe de 5 atividades voluntárias.',
      categoria: 'Atividades',
      progresso: 0.6,
      concluido: false,
    ),
    Conquista(
      titulo: 'Evento Especial',
      descricao: 'Contribua em um evento especial.',
      categoria: 'Eventos',
      progresso: 1.0,
      concluido: true,
    ),
  ];

  List<Conquista> get _conquistasFiltradas {
    final categoria = _categorias[_tabIndex];
    return _todasConquistas.where((c) {
      final matchCategoria = c.categoria == categoria;
      final matchStatus = switch (_filtroStatus) {
        'Concluídas' => c.concluido,
        'Pendentes' => !c.concluido,
        _ => true,
      };
      return matchCategoria && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categorias.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conquistas'),
          bottom: TabBar(
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.textLight.withOpacity(0.7),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            onTap: (index) => setState(() => _tabIndex = index),
            tabs: _categorias.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: FiltroStatus(
                valorSelecionado: _filtroStatus,
                opcoes: _statusOpcoes,
                onAlterar: (val) => setState(() => _filtroStatus = val),
              ),
            ),
            Expanded(
              child: _conquistasFiltradas.isEmpty
                  ? const NenhumaConquista()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: _conquistasFiltradas.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) => ConquistaCard(
                        conquista: _conquistasFiltradas[index],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
