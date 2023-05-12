import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graduationproject/helping_issues/timeline_issues.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/activity_feed.dart';
import 'package:graduationproject/pages/create_account.dart';
import 'package:graduationproject/profile/profile.dart';
import 'package:graduationproject/pages/search.dart';
import 'package:graduationproject/shop/shop.dart';
import 'package:graduationproject/pages/timeline.dart';
import 'package:graduationproject/styles/icon_broken.dart';



UserInformation currentUser;
final Reference storageRef = FirebaseStorage.instance.ref();
final postsRef = FirebaseFirestore.instance.collection('Posts');
final userRef = FirebaseFirestore.instance.collection('Users');
final commentsRef = FirebaseFirestore.instance.collection('Comments');
final activityFeedRef = FirebaseFirestore.instance.collection('Feed');
final followersRef = FirebaseFirestore.instance.collection('Followers');
final followingRef = FirebaseFirestore.instance.collection('Following');
final activityFeedCountRef = FirebaseFirestore.instance.collection('FeedCount');
final shopRef = FirebaseFirestore.instance.collection('ShopPosts');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final issueRef = FirebaseFirestore.instance.collection('issues');

class Home extends StatefulWidget {
  static const routname = '/Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DateTime timestamp = DateTime.now();
  bool isLoading = true;
  final userInfo = FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> formKey = GlobalKey();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  int currentIndex = 0;

  getActivityFeedSimelotensouly() {
    return activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .snapshots();
  }

/*
  Future<int> getActivityFeedCount()async{
    var FeedCount = 0 ;
   var querySnapshot = await activityFeedRef.doc(currentUser.id)
        .collection('feedItems').get();
   FeedCount = querySnapshot.docs.length;
   return FeedCount;
  }*/

  void onTap(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  var dialog = CreateAccount();

  /*checkExist() async{
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
    currentUser = new UserInformation.fromDocument(doc);
    print(currentUser);
    print('${currentUser.email}');
    setState(() {
      isLoading = false;
    });
  }*/

  _checkExist() async {
    final userInfo = FirebaseAuth.instance.currentUser;
    //final userRef = FirebaseFirestore.instance.collection('Users');

    bool existed;

    DocumentSnapshot doc = await userRef.doc(userInfo.uid).get();
    if (!doc.exists) {
      setState(() {
        existed = false;
      });
      activityFeedCountRef.doc(userInfo.uid).set({
        'activityFeedCount': 0,
      }, SetOptions(merge: true));
      dialog.buildDialog(context);
      userRef.doc(userInfo.uid).set({
        "id": userInfo.uid,
        "username": '',
        "photoUrl": userInfo.photoURL,
        "email": userInfo.email,
        "displayName": userInfo.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      doc = await userRef.doc(userInfo.uid).get();
      currentUser = new UserInformation.fromDocument(doc);
    } else {
      setState(() {
        existed = true;
      });
      doc = await userRef.doc(userInfo.uid).get();
      currentUser = new UserInformation.fromDocument(doc);
    }
    print(currentUser);
    print('${currentUser.email}');
    setState(() {
      isLoading = false;
    });
  }

/*  void initState() {
    setState(() {
      isLoading = true;
    });
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
  }*/

  int count;

  @override
  void initState() {
    // TODO: implement initState

    _checkExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*activityFeedCountRef
        .doc(userInfo.uid)
        .get()
        .then((value) => count = value['activityFeedCount']);*/

    List<Widget> widgetOptions = [
      Timeline(
        profileID: currentUser?.id,
      ),
      Search(),
      Shop(),
      TimelineIssues(),
      Profile(
        profileID: currentUser?.id,
      ),
    ];

    return Scaffold(
      body: !isLoading
          ? widgetOptions[currentIndex]
          : Container(
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
                    ),
                    strokeWidth: 3,
                  ),
                ],
              ))),
      bottomNavigationBar: !isLoading
          ? BottomNavigationBar(
              elevation: 0,
              currentIndex: currentIndex,
              //backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: currentIndex == 0
                        ? Icon(
                            IconBroken.Home,
                            size: 27,
                          )
                        : Icon(
                            IconBroken.Home,
                            size: 27,
                          ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      IconBroken.Search,
                      size: 27,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: currentIndex == 2
                        ? Icon(
                            IconBroken.Bag_2,
                            size: 27,
                          )
                        : Icon(
                            IconBroken.Bag_2,
                            size: 27,
                          ),
                    label: ''),
                /*count == null
                    ? BottomNavigationBarItem(
                        icon: CircularProgressIndicator(), label: "")
                    : BottomNavigationBarItem(
                        icon: currentIndex == 3
                            ? Icon(
                          IconBroken.Heart,
                                size: 27,
                              )
                            : Stack(children: [
                                Icon(
                                  IconBroken.Heart,
                                  size: 27,
                                ),
                                if (count != null)
                                  StreamBuilder<dynamic>(
                                      stream: getActivityFeedSimelotensouly(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data.size > count) {
                                          return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.3, left: 18.8),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                radius: 4,
                                              ));
                                        }
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.3, left: 18.8),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.white.withOpacity(0),
                                              radius: 4,
                                            ));
                                      })
                                else
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.3, left: 18.8),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.white.withOpacity(0),
                                        radius: 4,
                                      )),
                              ]),
                        label: ''),*/
                BottomNavigationBarItem(
                  icon: currentIndex == 3
                      ? Icon(
                          IconBroken.Calendar,
                          size: 27,
                        )
                      : Icon(
                          IconBroken.Calendar,
                          size: 27,
                        ),
                  label: ""
                ),
                BottomNavigationBarItem(
                    icon: currentIndex == 4
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                  currentUser.photoUrl),
                              radius: 12,
                            ))
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(
                                currentUser.photoUrl),
                            radius: 13,
                          ),
                    label: ''),
              ],
              //selectedItemColor: Colors.white,
              fixedColor: Colors.blue,
              unselectedItemColor: Colors.black54,
              onTap: onTap,
            )
          : null,
    );
  }
}
