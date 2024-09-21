import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissioncontrolle extends GetxController {
  //permission()
  var gotPermission = false;

  Future<void> getPermission() async {
    if (await Permission.storage.request().isGranted &&
        await Permission.accessMediaLocation.request().isGranted &&
        await Permission.manageExternalStorage.request().isGranted) {
      gotPermission = true;
      update();
    } else {
      await Permission.storage.request().then((value) {
        if (value.isGranted) {
          gotPermission = true;
          update();
        }
      });
    }
  }

  @override
  void onInit() {
    getPermission();
    super.onInit();
  }
}
