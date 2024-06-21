
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<String?> openQRScanner() async {
  var cameraStatus = await Permission.camera.status;
  if (cameraStatus.isGranted) {
    String? qr = await scanner.scan();
    return qr;
  } else {
    var isGrant = await Permission.camera.request();
    if (isGrant.isGranted) {
      String? qr = await scanner.scan();
      return qr;
    }
  }
}
