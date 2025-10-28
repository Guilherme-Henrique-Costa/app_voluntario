import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class DialogUtils {
  /// Diálogo de confirmação (OK / Cancelar)
  static Future<bool> showConfirm(
    BuildContext context,
    String message, {
    String title = 'Confirmação',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Mostra um alerta simples
  static Future<void> showInfo(BuildContext context, String message,
      {String title = 'Informação'}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra um alerta de erro
  static Future<void> showError(BuildContext context, String message,
      {String title = 'Erro'}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: AppTextStyles.title.copyWith(color: AppColors.error)),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /// Mostra um indicador de carregamento modal
  static void showLoading(BuildContext context,
      {String text = 'Carregando...'}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(text, style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }

  /// Fecha o diálogo de carregamento
  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
