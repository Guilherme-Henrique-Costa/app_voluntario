import 'package:permission_handler/permission_handler.dart';

class PermissaoUtil {
  static Future<bool> solicitarPermissaoCamera() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    return status.isGranted;
  }

  static Future<bool> solicitarPermissaoGaleria() async {
    var status = await Permission.photos.status;

    if (!status.isGranted) {
      status = await Permission.photos.request();
    }

    return status.isGranted;
  }
}
