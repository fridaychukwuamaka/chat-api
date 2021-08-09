import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/providers/auth.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  GetStorage box = GetStorage();

  singUp() async {
    AuthProvider authProvider = AuthProvider();
    Map<String, String> userDetail = {
      "username": _usernameController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text
    };
    try {
      Response response = await authProvider.SignUpUser(userDetail);
      if (response.statusCode == 200) {
        print(response.headers["x-auth-token"]);
        var authToken =  response.headers["x-auth-token"];
        box.write('authToken', authToken);
          print('$authToken njjg fgj fj');

        Get.to(HomePage());
        Get.snackbar(
          'Message',
          'Wellcome ${_usernameController.text}!!!',
          backgroundColor: kMainBlue,
          margin: EdgeInsets.zero,
          borderRadius: 0,
        );
      } else {
        Get.snackbar('Message', response.body,
            backgroundColor: kMainBlue,
            margin: EdgeInsets.zero,
            borderRadius: 0);
        print('${response.body}njjg fgj fj');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Enter your credentials to continue',
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InputWidget(
              label: 'Username',
              controller: _usernameController,
              maxLines: 1,
              isObsured: false,
              hint: 'Jane Doe',
            ),
            SizedBox(
              height: 30,
            ),
            InputWidget(
              label: 'Phone',
              maxLines: 1,
              controller: _phoneController,
              isObsured: false,
              keyboardType: TextInputType.phone,
              hint: '+1234563895',
            ),
            SizedBox(
              height: 30,
            ),
            InputWidget(
              label: 'Password',
              maxLines: 1,
              isObsured: true,
              controller: _passwordController,
              hint: 'password',
            ),
            SizedBox(
              height: 10,
            ),
            Text.rich(
              TextSpan(
                  text: 'By continuing you agree to our ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.8,
                    color: Color(0xFF7C7C7C),
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: kMainBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C7C7C),
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: TextStyle(
                        // color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 30,
            ),
            AppButton(
              label: 'Sign Up',
              onPressed: singUp,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: kMainBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _registerFormKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

/*  @override
  void initState() {
    super.initState();

    const delay = const Duration(seconds: 3);
    Future.delayed(delay, () => onTimerFinished());
  }

 Future initfbAuth() async {
  auth = await FirebaseAuth.instance;
 } */

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Form(
        key: _registerFormKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 200.0,
              height: 100.0,
              child: Text(
                'REGISTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _fullnameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.person,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.lock_open,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.phone),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: InkWell(
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
