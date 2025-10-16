import 'package:flutter/material.dart';

class GrupoCheckbox extends StatelessWidget {
  final List<String> opcoes;
  final List<String> selecionados;

  const GrupoCheckbox({
    super.key,
    required this.opcoes,
    required this.selecionados,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: opcoes.map((op) {
        return CheckboxListTile(
          title: Text(op, style: const TextStyle(color: Colors.white)),
          value: selecionados.contains(op),
          activeColor: Colors.amber,
          checkColor: Colors.deepPurple[900],
          onChanged: (val) {
            if (val == true) {
              selecionados
                ..clear()
                ..add(op);
            } else {
              selecionados.remove(op);
            }
          },
        );
      }).toList(),
    );
  }
}
