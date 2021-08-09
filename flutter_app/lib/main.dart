import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white70),
        accentColor: kMainBlue,
        platform: TargetPlatform.iOS,
        tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Montserrat',
          ),
          bodyText2: TextStyle(
            fontFamily: 'Montserrat',
          ),
          subtitle2: TextStyle(
            fontFamily: 'Montserrat',
          ),
          headline5: TextStyle(
            fontFamily: 'Montserrat',
          ),
          headline6: TextStyle(
            fontFamily: 'Montserrat',
          ),
          button: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      home: !box.hasData('authToken')  ?  LoginPage(): HomePage(),
    );
  }
}
