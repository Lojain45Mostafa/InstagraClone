// Importing the local_auth package to handle biometric authentication
import 'package:local_auth/local_auth.dart';

// Creating a class named Authentication to encapsulate the authentication logic
class Authentication {
  // Initializing a static instance of LocalAuthentication
  static final _auth = LocalAuthentication();

  // A method to check if the device can authenticate using biometrics
  static Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  // A method to perform authentication using biometrics
  static Future<bool> authentication() async {
    try {
      // Checking if the device supports biometric authentication
      if (!await canAuthenticate()) return false;

      // Initiating the biometric authentication process with a localized reason
      return await _auth.authenticate(localizedReason: "get to the app");
    } catch (e) {
      // Handling any errors that may occur during authentication
      print("error $e");
      return false;
    }
  }
}
