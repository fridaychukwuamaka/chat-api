import 'dart:io';

Future<String> getIp() async {
  var interface = await NetworkInterface.list();
  return interface[0].addresses[0].address;
}
