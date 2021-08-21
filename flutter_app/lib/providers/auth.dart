import 'package:flutter_app/constant.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

class AuthProvider extends GetConnect {
  Future<Response> SignUpUser(Map data) =>
      post('$kAddress/api/user/register', data);

  Future<Response> currentUser() => get(
        '$kAddress/api/user',
        headers: {
          "x-auth-token": box.read('authToken'),
        },
      );

  Future<Response> friends() => get(
        '$kAddress/api/user/friends',
        headers: {
          "x-auth-token": box.read('authToken'),
        },
      );

  Future<Response> createGroup(Map data) => post(
        '$kAddress/api/group',
        data,
        headers: {
          "x-auth-token": box.read('authToken'),
        },
      );

  Future<Response> registeredGroup() => get(
        '$kAddress/api/group/registered-group',
        headers: {
          "x-auth-token": box.read('authToken'),
        },
      );

  Future<Response> Login(Map data) => post('$kAddress/api/auth/', data);
}
