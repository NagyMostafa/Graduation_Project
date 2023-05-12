import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider extends ChangeNotifier {
  bool _isSigningIn;
  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }


  bool _isSigningOut;

  bool get isSigningOut => _isSigningOut;

  GoogleSignOutProvider() {
    _isSigningOut = false;
  }

  set isSigningOut(bool isSigningOut) {
    _isSigningOut = isSigningOut;
    notifyListeners();
  }

/*  Future login() async {
    try{
      googleSignIn.signIn().then((user) async{
        if(user != null) {
          isSigningIn = true;
          final googleAuth = await user.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          isSigningIn = false;
        }
        else{
          return;
        }
      });
    }
    catch (error)
    {
      print('$error');
    }


  }*/



  Future login() async {
    final googleSignIn = GoogleSignIn();
    isSigningIn = true;
    final user = await googleSignIn.signIn();
    //isSigningIn = true;
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
    isSigningIn = false;
    notifyListeners();
  }


  void logout() async{
    _isSigningOut = false;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    _isSigningOut = true;
    notifyListeners();
  }



}