import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Un compte existe déjà pour cet email.');
      }
    } catch (e) {
      throw Exception('Une erreur inattendue est survenue.');
    }

    return false;
  }

  Future<void> trySignUp(String email, String password, Function onSignUpSuccess, Function onError) async {
    try {
      bool isSignedUp = await signUp(email, password);
      if (isSignedUp) {
        onSignUpSuccess();
      }
    } catch (e) {
      onError(e);
    }
  }

  void processSignUp(BuildContext context, String email, String password) async {
    if (email.isEmpty || !email.contains('@') || password.isEmpty) {
      return;
    }

    trySignUp(
      email,
      password,
          () => Navigator.of(context).pushReplacementNamed('/todo_list'),
          (e) {
      },
    );
  }


}
