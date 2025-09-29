import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthFacade {
  Future<UserCredential> signIn(FirebaseAuth auth);
  Future<void> signOut();
}

class GoogleAuthFacadeIo implements GoogleAuthFacade {
  GoogleAuthFacadeIo();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserCredential> signIn(FirebaseAuth auth) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign-in cancelled');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await auth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}


