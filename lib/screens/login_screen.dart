import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../models/notifications.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void loginUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passController.text,
      );

      if (res["error"] == false) {
        context
            .read<UserProvider>()
            .setUser(await Notifications.GetUserById(res["res"].uid));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        );
      } else {
        showSnackBar(context, res["res"]);
      }
    } catch (e) {
      print("Login Error: $e");
      showSnackBar(context, "An error occurred during login");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(scrollDirection: Axis.vertical, children: [
      SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                // ignore: deprecated_member_use
                color: primaryColor,
                height: 64,
              ), // Display the Instagram logo using an SVG image.
              const SizedBox(height: 64),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress,
                obscureText: false,
              ), // Display a text input field for the email.
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _passController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
                obscureText: false,
              ), // Display a text input field for the password.
              const SizedBox(height: 64),
              InkWell(
                onTap: () => loginUser(
                    context), // Call the login method when the login button is tapped.
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log in'),
                ), // Display the login button.
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "  Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ) // Display the "Don't have an account?" message with a signup link.
            ],
          ),
        ),
      )
    ]));
  }
}
