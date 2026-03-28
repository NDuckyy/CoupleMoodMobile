import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],
  serverClientId: '1063525637223-kfv24p4kgbjl0d15g8jgb5eg4j41c9u6.apps.googleusercontent.com'
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
