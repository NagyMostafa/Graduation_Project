import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:graduationproject/providers/googlesignin.dart';
import 'package:graduationproject/pages/home.dart';



class AuthScreen extends StatefulWidget {
  static const routname = '/AuthScreen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {



  Scaffold buildAuthScreen(){
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.purple,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('GroupGram',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Signatra',
                fontSize: 90,
              ),
            ),
            GestureDetector(
              onTap:() async{
                 provider.login();
              },
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }


}
