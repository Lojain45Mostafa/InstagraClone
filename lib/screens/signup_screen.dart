<<<<<<< HEAD
import 'dart:convert';
=======
>>>>>>> 052c88e60d63c206e7d88e217d4f30aab143c6b7
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/text_field_input.dart';
<<<<<<< HEAD
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // bast5demha 34an a3rf ast5dem File el fel image picker aslun el import da byst5dem 34an el I/O operation w menhom el files
=======
>>>>>>> 052c88e60d63c206e7d88e217d4f30aab143c6b7

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

  // Define a global key for the form
  final _formKey = GlobalKey<FormState>();

  late String _selectedImage; // Store the selected image path
  //The use of late allows the variable to be accessed without the need for an explicit initialization value at the point of declaration.

  @override
  void initState() {
    super.initState();
    _selectedImage = '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

<<<<<<< HEAD
  bool containsUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]')); // Regular Expression
  }

=======
>>>>>>> 052c88e60d63c206e7d88e217d4f30aab143c6b7
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
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
<<<<<<< HEAD
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: Colors.white, // Adjust the color
                  height: 64,
                ),
                const SizedBox(height: 64),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: _selectedImage.isNotEmpty
                          ? FileImage(File(_selectedImage))
                          : AssetImage('assets/test.jpg')
                              as ImageProvider<Object>,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text,
                  isPass: true,
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
                          BorderRadius.circular(8), // Set the border radius
=======
                // Positioned(
                //   bottom: -10,
                //   left: 80,
                //   child: IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.add_a_photo,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 24),
            //textfield for username
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Enter your username",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            //textfield for email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            //textfield for password
            TextFieldInput(
              textEditingController: _passController,
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(height: 24),
            //textfield for bio
            TextFieldInput(
              textEditingController: _bioController,
              hintText: "Enter your bio",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            InkWell(
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
                    color: blueColor),
                child: const Text('Sign Up'),
              ),
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
                  child: const Text("Already Have an Account?"),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "  Log in",
                      style: TextStyle(fontWeight: FontWeight.bold),
>>>>>>> 052c88e60d63c206e7d88e217d4f30aab143c6b7
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
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
                          BorderRadius.circular(8), // Set the border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
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
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, handle sign-up logic
                    }
                  },
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
                      color: Colors.blue, // Adjust the color
                    ),
                    child: const Text('Sign Up'),
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
                        // Navigate to the login screen
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
    );
  }
}
