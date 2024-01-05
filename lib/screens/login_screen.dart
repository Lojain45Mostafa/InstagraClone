import 'package:flutter/material.dart'; // Import the Flutter material library.
import 'package:flutter_svg/flutter_svg.dart'; // Import the Flutter SVG library for working with SVG images.
import 'package:instagram/providers/user_provider.dart'; // Import a user provider for managing user-related data.
import 'package:instagram/resources/auth_methods.dart'; // Import authentication methods.
import 'package:instagram/responsive/mobile_screen_layout.dart'; // Import a responsive mobile screen layout.
import 'package:instagram/screens/feed_screen.dart'; // Import the feed screen.
import 'package:instagram/screens/signup_screen.dart'; // Import the signup screen.
import 'package:instagram/utils/colors.dart'; // Import color constants.
import 'package:instagram/utils/utils.dart'; // Import utility functions.
import 'package:instagram/widgets/text_field_input.dart'; // Import a custom text field input widget.
import 'package:provider/provider.dart'; // Import the provider package for state management.

import '../models/notifications.dart'; // Import a notifications model.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(); // Controller for handling email text input.
  final TextEditingController _passController =
      TextEditingController(); // Controller for handling password text input.
  bool _isLoading = false; // Boolean flag to track loading state.

  @override
  void dispose() {
    super.dispose();
    _emailController
        .dispose(); // Dispose of the email controller to free up resources.
    _passController
        .dispose(); // Dispose of the password controller to free up resources.
  }

  void loginUser(BuildContext context) async {
    setState(() {
      _isLoading = true; // Set loading state to true.
    });

    try {
      Map<String, dynamic> res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passController.text,
      ); // Call the login method from AuthMethods.

      if (res["error"] == false) {
        // If login is successful, set the user data using a provider and navigate to the feed screen.
        context
            .read<UserProvider>()
            .setUser(await Notifications.GetUserById(res["res"].uid));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        );
      } else {
        showSnackBar(
            context, res["res"]); // Show a snackbar with an error message.
      }
    } catch (e) {
      print("Login Error: $e");
      showSnackBar(context,
          "An error occurred during login"); // Show a snackbar for general login errors.
    } finally {
      setState(() {
        _isLoading =
            false; // Set loading state to false, whether login is successful or not.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
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
    ));
  }
}
