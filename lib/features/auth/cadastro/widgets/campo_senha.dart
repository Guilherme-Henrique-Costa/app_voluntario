import 'package:flutter/material.dart';

class CampoSenha extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CampoSenha({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (v) =>
            v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
      ),
    );
  }
}
