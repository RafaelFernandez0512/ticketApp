import 'package:permission_handler/permission_handler.dart';

  Future<bool>  checkCameraPermission() async {
  var status = await Permission.camera.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    // Pedir permiso
    var result = await Permission.camera.request();
    return result.isGranted;
  } else if (status.isPermanentlyDenied) {
    // El usuario negó y marcó "No preguntar más"
    // Puedes abrir la configuración para que el usuario habilite el permiso manualmente
    await openAppSettings();
    return false;
  }
  return false;
}