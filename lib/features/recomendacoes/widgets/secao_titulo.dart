import 'package:flutter/material.dart';

class SecaoTitulo extends StatelessWidget {
  final String titulo;

  const SecaoTitulo(this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.amber,
      ),
    );
  }
}
