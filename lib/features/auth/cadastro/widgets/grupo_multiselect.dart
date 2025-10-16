import 'package:flutter/material.dart';

class GrupoMultiSelect extends StatelessWidget {
  final String label;
  final List<String> opcoes;
  final List<String> selecionados;

  const GrupoMultiSelect({
    super.key,
    required this.label,
    required this.opcoes,
    required this.selecionados,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: opcoes.map((op) {
            final ativo = selecionados.contains(op);

            return FilterChip(
              label: Text(
                op,
                style: TextStyle(
                  color: ativo ? Colors.deepPurple[900] : Colors.white,
                  fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: ativo,
              onSelected: (val) {
                if (val) {
                  selecionados.add(op);
                } else {
                  selecionados.remove(op);
                }
              },
              selectedColor: Colors.amber, // ✅ Cor do chip ativo
              backgroundColor: Colors.white24, // ✅ Cor do chip inativo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: ativo ? Colors.amber : Colors.white38,
                  width: 1.2,
                ),
              ),
              showCheckmark: false, // ✅ Remove o ícone ✔ interno
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
