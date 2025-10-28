import 'package:permission_handler/permission_handler.dart';

class PermissaoUtil {
  /// Solicita permissão para uso da câmera.
  static Future<bool> solicitarPermissaoCamera() async {
    return _solicitarPermissao(Permission.camera);
  }

  /// Solicita permissão para acesso à galeria (fotos).
  ///
  /// Observação:
  /// - No Android, pode ser necessário usar [Permission.storage]
  /// - No iOS, o correto é [Permission.photos]
  static Future<bool> solicitarPermissaoGaleria() async {
    return _solicitarPermissao(Permission.photos);
  }

  /// Solicita permissão para localização (GPS).
  static Future<bool> solicitarPermissaoLocalizacao() async {
    return _solicitarPermissao(Permission.locationWhenInUse);
  }

  /// Método privado genérico que realiza a lógica de requisição de permissão.
  static Future<bool> _solicitarPermissao(Permission permissao) async {
    var status = await permissao.status;

    // Se a permissão ainda não foi concedida, solicita ao usuário
    if (!status.isGranted) {
      status = await permissao.request();
    }

    // Retorna verdadeiro se a permissão foi concedida
    return status.isGranted;
  }
}
