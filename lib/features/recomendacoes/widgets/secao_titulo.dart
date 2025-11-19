import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

class SecaoTitulo extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Color? corIcone;
  final Color? corTexto;

  const SecaoTitulo({
    super.key,
    required this.icon,
    required this.titulo,
    this.corIcone,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: corIcone ?? AppColors.secondary,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            titulo,
            style: AppTextStyles.subtitle.copyWith(
              color: corTexto ?? AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
