import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class FiltroStatus extends StatelessWidget {
  final String valorSelecionado;
  final List<String> opcoes;
  final ValueChanged<String> onAlterar;

  const FiltroStatus({
    super.key,
    required this.valorSelecionado,
    required this.opcoes,
    required this.onAlterar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Filtrar por status:', style: AppTextStyles.subtitle),
        const SizedBox(width: AppSpacing.md),
        DropdownButton<String>(
          value: valorSelecionado,
          items: opcoes
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (val) {
            if (val != null) onAlterar(val);
          },
        ),
      ],
    );
  }
}
