import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ✅ Campo de texto reutilizável com máscara e validação opcional
class CampoTexto extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? mask;
  final bool obrigatorio;

  const CampoTexto({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.mask,
    this.obrigatorio = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: mask != null ? [mask!] : [],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (!obrigatorio) return null;
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }
}
