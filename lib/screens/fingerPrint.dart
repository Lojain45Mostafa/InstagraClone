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
      backgroundColor: Color(0xFF192359),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Text(
                "Use fingerprint to login",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Divider(color: Colors.white60),
              SizedBox(
                height: 28,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  bool auth = await Authentication.authentication();
                  print("Can authenticate $auth");
                  if (auth) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                },
                icon: Icon(Icons.fingerprint),
                label: Text("Authenticate"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
