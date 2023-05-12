import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:graduationproject/providers/googlesignin.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/authscreen.dart';
import 'package:graduationproject/pages/create_account.dart';
import 'dart:ui' as ui;
import 'package:graduationproject/pages/home.dart';





class MainSplashScreen extends StatefulWidget {

  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  UserInformation user;
  final userRef = FirebaseFirestore.instance.collection('Users');
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userInfo = FirebaseAuth.instance.currentUser;
  var dialog = CreateAccount();
  final DateTime timestamp = DateTime.now();


  checkExist()async{
    final userInfo = FirebaseAuth.instance.currentUser;
    //final userRef = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot doc = await userRef.doc(userInfo.uid).get();
    if(!doc.exists){
      if(this.mounted == true) {
        dialog.buildDialog(context);
      }
      userRef.doc(userInfo.uid).set({
        "id": userInfo.uid,
        "username": '',
        "photoUrl": userInfo.photoURL,
        "email": userInfo.email,
        "displayName": userInfo.displayName,
        "bio": "",
        "timestamp": timestamp
      });

    }
    doc = await userRef.doc(userInfo.uid).get();
    user = new UserInformation.fromDocument(doc);
    print(user);
    print('${user.email}');
  }

  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        checkExist();
        print('User signed in!: $account');
      } else {
        return null;
      }
    }, onError: (err) {
      print('Error signing in: $err');
    });
    googleSignIn.signInSilently();
    print("Done");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context,listen: true);
    return SplashScreen(
      seconds: 2,
      useLoader: false,
      backgroundColor: Theme.of(context).accentColor,
      image: Image.asset('assets/images/groupgram.png'),
      photoSize: 60,
      navigateAfterSeconds: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (provider.isSigningIn) {
            return buildCircular('logging in...');
          } else if (snapshot.hasData) {
            return Home();
          } else {
            return AuthScreen();
          }
        },
      ),
      loadingText: Text(
        'from\nMSK GROUP',
        style: TextStyle(
            fontSize: 15,
            foreground: Paint()
              ..shader = ui.Gradient.linear(
                const Offset(25, 70),
                const Offset(120, 50),
                <Color>[
                  Colors.red,
                  Colors.orange,
                ],
              )),
        textAlign: TextAlign.center,
      ),
    );
  }

  Scaffold buildCircular(String message) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.grey.withOpacity(0.6),
                      ),
                      strokeWidth: 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(message),
                  )
                ],
              ))),
    );
  }
}
