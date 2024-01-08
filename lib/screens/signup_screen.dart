import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart'; //The provider package helps manage the state of your application in a clean and efficient way. Flutter applications often need to manage state, such as user authentication status, user data, or UI-related state.

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  XFile? _image;
  bool _isLoading = false;

  // Define a global key for the form
  final _formKey = GlobalKey<FormState>();

  late String _selectedImage; // Store the selected image path
  //The use of late allows the variable to be accessed without the need for an explicit initialization value at the point of declaration.

  @override
  void initState() {
    super.initState();
    _selectedImage = '';
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser(BuildContext context) async {
    // Ensure the form is valid
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> result = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passController.text,
      bio: _bioController.text,
      file: _image!,
    );

    // if string returned is success, user has been created
    if (result["res"] == "success" && result["user"] != null) {
      context.read<UserProvider>().setUser(result["user"]);
      setState(() {
        _isLoading = false;
        // Navigate to feed_screen.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        );
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, result["res"]);
    }
  }

  bool containsUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]')); // Regular Expression
  }

  selectImage() async {
    XFile im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(scrollDirection: Axis.vertical, children: [
        SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Image.asset(
                    'assets/logo(final).png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: FileImage(File(_image!.path)),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU',
                              ),
                              backgroundColor: Colors.red,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      filled: true,
                      fillColor: Colors.grey[750], // Set the background color
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // Remove the border
                        borderRadius:
                            BorderRadius.circular(12), // Set the border radius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      hintText: "Enter your passwrod",
                      filled: true,
                      fillColor: Colors.grey[750], // Set the background color
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // Remove the border
                        borderRadius:
                            BorderRadius.circular(12), // Set the border radius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password.';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters.';
                      } else if (!containsUpperCase(value) ||
                          !containsLowerCase(value)) {
                        return 'Password must contain both uppercase and lowercase characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => signUpUser(context),
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Sign Up'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        color: Colors.blue, // Adjust the color
                      ),
                      // child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an Account?"),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle adding a new chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "  Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
