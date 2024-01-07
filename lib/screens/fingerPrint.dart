import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/authentication.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2B2B), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.purple, Colors.red],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.fingerprint,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Waiting for fingerprint...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 70),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Authenticating using biometrics and storing the result
                    bool auth = await Authentication.authentication();
                    // Printing whether authentication is successful
                    print("Can authenticate $auth");
                    // Navigating to the LoginScreen if authentication is successful
                    if (auth) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  icon: Icon(Icons.fingerprint),
                  label: Text("Authenticate"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(
                        0xFF004080), // Change this color to your desired button color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
