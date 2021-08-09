import 'package:get/get.dart';

class UserController extends GetxController {
  dynamic currentUser;

  updateUser(val) {
    currentUser = val;
    update();
  }
}
