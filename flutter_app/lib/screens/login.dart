import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/sign_up.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  GetStorage box = GetStorage();

  String emailError;
  String passwordError;

  login() async {
    AuthProvider authProvider = AuthProvider();
    Map<String, String> userDetail = {
      "phone": _phoneController.text,
      "password": _passwordController.text
    };

    print(userDetail);

    try {
      Response response = await authProvider.Login(userDetail);

      if (response.statusCode == 200) {
        Get.snackbar('Message', 'Welcome!!!',
            backgroundColor: kMainBlue,
            margin: EdgeInsets.zero,
            borderRadius: 0);
        Get.to(HomePage());

        box.write('authToken', response.body);
      } else {
        Get.snackbar('Message', response.body,
            backgroundColor: kMainBlue,
            margin: EdgeInsets.zero,
            borderRadius: 0);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 55,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Log In',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Enter your emails and password',
            style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          InputWidget(
            label: 'Phone',
            controller: _phoneController,
            errorText: emailError,
            maxLines: 1,
            isObsured: false,
            hint: '+23242323431',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(
            height: 30,
          ),
          InputWidget(
            label: 'Password',
            errorText: passwordError,
            maxLines: 1,
            isObsured: true,
            controller: _passwordController,
            hint: 'password',
          ),
          SizedBox(
            height: 50,
          ),
          AppButton(
            label: 'Log In',
            onPressed: login,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    // color: .primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Get.to(SignUpPage());
                },
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class InputWidget extends StatelessWidget {
  InputWidget({
    Key key,
    @required this.label,
    @required this.hint,
    this.errorText,
    @required this.maxLines,
    @required this.isObsured,
    this.keyboardType,
    @required this.controller,
  }) : super(key: key);

  final String label;
  final String hint;
  String errorText = '';
  final TextInputType keyboardType;
  final int maxLines;
  final bool isObsured;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        TextField(
          obscureText: isObsured,
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hint,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    // color: AppColors.primaryColor,
                    )),
            border: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xFFE2E2E2),
            )),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
