import 'package:permission_handler/permission_handler.dart';

/// Utilitário responsável por solicitar permissões do sistema (Câmera, Galeria, etc.)
class PermissaoUtil {
  /// Solicita permissão para uso da câmera.
  static Future<bool> solicitarPermissaoCamera() async {
    return _solicitarPermissao(Permission.camera);
  }

  /// Solicita permissão para acesso à galeria (fotos).
  static Future<bool> solicitarPermissaoGaleria() async {
    // Em algumas versões do Android/iOS, a permissão correta pode ser [Permission.storage]
    // Caso enfrente problemas, substitua Permission.photos por Permission.storage.
    return _solicitarPermissao(Permission.photos);
  }

  /// Método privado para reutilizar a lógica de requisição de permissões.
  static Future<bool> _solicitarPermissao(Permission permissao) async {
    var status = await permissao.status;
    if (!status.isGranted) {
      status = await permissao.request();
    }
    return status.isGranted;
  }
}
