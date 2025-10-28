import 'package:flutter/material.dart';
import 'package:app_voluntario/core/constants/app_theme.dart';
import 'package:app_voluntario/core/errors/app_exception.dart';

class ErrorHandler {
  static void show(
    BuildContext context,
    dynamic error, {
    StackTrace? stack,
    bool useDialog = false,
  }) {
    final String message = _getErrorMessage(error);
    log(error, stack);

    if (useDialog) {
      _showDialog(context, message);
    } else {
      _showSnackBar(context, message);
    }
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text('Erro', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Falha de conexão: ${error.message}';
    } else if (error is AuthException) {
      return 'Erro de autenticação: ${error.message}';
    } else if (error is PermissionException) {
      return 'Permissão negada: ${error.message}';
    } else if (error is AppException) {
      return error.message;
    } else {
      return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }

  static void log(dynamic error, [StackTrace? stack]) {
    debugPrint('❌ ERRO: $error');
    if (stack != null) debugPrint(stack.toString());
  }
}
