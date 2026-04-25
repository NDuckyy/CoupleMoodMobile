import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],
  serverClientId: dotenv.env['GOOGLE_SIGN_IN']!
  );

  Future<String?> signInAndGetIdToken() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account == null) return null;

      final auth = await account.authentication;
      print("ID TOKEN: ${auth.idToken}");

      return auth.idToken;
    } catch (e) {
      debugPrint("Google Sign-In error: $e");
      return null;
    }
  }

}
