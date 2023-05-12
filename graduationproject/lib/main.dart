import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graduationproject/pages/activity_feed.dart';
import 'package:provider/provider.dart';
import 'package:graduationproject/chat_content/chats.dart';
import 'package:graduationproject/providers/googlesignin.dart';
import 'package:graduationproject/shop/Upload_Product.dart';
import 'package:graduationproject/pages/authscreen.dart';
import 'package:graduationproject/post/create_post.dart';
import 'package:graduationproject/pages/mainsplashscreen.dart';
import 'package:graduationproject/shop/shop_search.dart';
import 'pages/home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await GoogleSignIn().disconnect();
  //FirebaseAuth.instance.signOut();
  runApp(ChangeNotifierProvider(
      create: (_) => GoogleSignInProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
        canvasColor: Colors.white,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (provider.isSigningIn == true) {
            return buildCircular('logging in...');
          } else if(provider.isSigningOut == false)
            {
              return buildCircular('logging out...');
            } else if (snapshot.hasData) {
            return Home();
          } else {
            return AuthScreen();
          }
        },
      ),
      initialRoute: '/',
      routes: {
        Home.routname: (_) => Home(),
        AuthScreen.routname: (_) => AuthScreen(),
        '/MainSplahScreen' : (_) => MainSplashScreen(),
        UploadProduct.routname : (_) => UploadProduct(),
        CreatePost.routname :(_) => CreatePost(),
        ShopSearch.routname : (_) => ShopSearch(),
        ChatScreen.routname : (_) => ChatScreen(),
        ActivityFeed.routname : (_) => ActivityFeed(),
      },
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
                        Colors.blue.withOpacity(0.7),
                      ),strokeWidth: 3,),
                  /*Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(message),
                  )*/
                ],
              ))),
    );
  }


}
