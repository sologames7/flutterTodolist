import 'package:firebase_auth/firebase_auth.dart';

class SignInModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('Identifiants invalides');
      }
    } catch (e) {
      throw Exception('Une erreur inattendue est survenue.');
    }
    return false;
  }

  Future<void> trySignIn(String email, String password, Function onSignInSuccess, Function onError) async {
    try {
      bool isSignedIn = await signIn(email, password);
      if (isSignedIn) {
        onSignInSuccess();
      }
    } catch (e) {
      onError(e);
    }
  }
}
