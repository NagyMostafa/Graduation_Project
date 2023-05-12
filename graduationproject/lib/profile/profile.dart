import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/helping_issues/user_issue_posts.dart';
import 'package:provider/provider.dart';
import 'package:graduationproject/profile/followers_list.dart';
import 'package:graduationproject/profile/following_list.dart';
import 'package:graduationproject/providers/googlesignin.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/post/create_post.dart';
import 'package:graduationproject/profile/edit_profile.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/post/post.dart';
import 'package:graduationproject/widgets/progress.dart';



class Profile extends StatefulWidget {
  final String profileID;
  const Profile({this.profileID});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserID = currentUser?.id;
  UserInformation user;
  //final userInfo = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  bool isLoad = false;
  bool isFollowing = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];
  List<String> userId =[];

  getUser() async{
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot  doc = await userRef.doc(widget.profileID).get();
    user = UserInformation.fromDocument(doc);
    setState(() {
      isLoading = false;
    });
  }
  /*getProfilePosts()  async{
    setState(() {
      isLoad = true;
    });
    QuerySnapshot snapshot = await postsRef
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoad = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }*/
  getProfilePosts()  {
    setState(() {
      userId.add(widget.profileID);
    });
    return FutureBuilder(
      future: postsRef
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (context,snapshot){
        if (snapshot.hasData) {
          posts.clear();
          Post post;
          snapshot.data.docs.forEach((doc) {
            post = Post.fromDocument(doc);
            posts.add(post);
          });
          posts = posts.where((element) => userId.contains(element.ownerId) ).toList();
          return Column(
            children: posts,
          );

        }
        else{
          return circularProgress();
        }
      },
    );
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileID)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileID)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  @override
  void initState() {
    getUser();
    //getProfilePosts();
    getFollowers();
    getFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        actions: [
          CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.5),
              radius: 17,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    IconBroken.Calendar,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserIssuePosts()
                    ));
                  },
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                radius: 17,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      IconBroken.Plus,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePost())).then((_) {
                        getUser();
                        setState(() {});
                      }
                      );
                    },
                    color: Colors.black,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 10),
            child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                radius: 17,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      IconBroken.Logout,
                      size: 20,
                    ),
                    onPressed: () {
                      Provider.of<GoogleSignInProvider>(context, listen: false).logout();
                    },
                    color: Colors.black,
                  ),
                )),
          ),
        ],
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),

      body:!isLoading ? RefreshIndicator(
        onRefresh: () =>  getUser(),
        color: Colors.grey,
        child: !isLoading  ? ListView(
          children: [
            buildProfileHeader(),
            Divider(height: 0.0,),
            getProfilePosts(),
          ],
        ) : Container(
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
                        strokeWidth: 3),
                  ],
                ))),
      ) :
      Container(
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
                      strokeWidth: 3),
                ],
              ))),
    );
  }

  buildProfilePosts() {
        return Column(
          children: posts,
        );
  }

  buildProfilePosts2() {
    return StreamBuilder(
      stream: postsRef
          .doc(widget.profileID)
          .collection('userPosts')
          .orderBy('timestamp', descending: true).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Text("");
        }
        List<Post> posts = [];
        snapshot.data.docs.forEach((doc) {
          posts.add(Post.fromDocument(doc));
        });
        return Column(
          children: posts,
        );
      },
    );
  }


  buildProfileHeader(){
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*buildCountColumn('Posts', postCount),
                    buildCountColumn('Followers', followerCount),
                    buildCountColumn('Following', followingCount),*/
                    //buildCountColumnPosts(postCount),
                    buildCountColumnFollowers(followerCount),
                    buildCountColumnFollowing(followingCount),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              user.username,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              user.displayName,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          user.bio != ''
              ? Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 2.0),
              child: Text(
                user.bio,
              ),
            ),
          )
              : Container(),
          Row(
            children: [
              Row(
                children: [
                  buildProfileButton(),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

/* buildProfileHeader() {
    return  FutureBuilder(
        future: userRef.doc(widget.profileID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ) {
            return Center(child: circularProgress());
          } else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: circularProgress());
          } else {
             user = UserInformation.fromDocument(snapshot.data);
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl),
                        backgroundColor: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildCountColumn('Posts', 0),
                            buildCountColumn('Followers', 0),
                            buildCountColumn('Following', 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      user.username,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      user.displayName,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  user.bio != ''
                      ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text(
                              user.bio,
                            ),
                          ),
                      )
                      : Container(),
                  Row(
                    children: [
                      Row(
                        children: [
                          buildProfileButton(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        });
  }*/

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
  buildCountColumnPosts(int count) {
    return Container(
      height: 80,
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              "Posts",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
  buildCountColumnFollowers(int count) {
    return TextButton(
      style:  TextButton.styleFrom(
        primary: Colors.black54,
      ),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowersList(userId: currentUserID,))).then((_) {
          getFollowers();
          getFollowing();
          //setState(() {});
        });
      },
      child: Container(
        height: 80,
        width: 80,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                "Followers",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  buildCountColumnFollowing(int count) {
    return TextButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowingList(userId: currentUserID,))).then((_) {
          getFollowing();
          getFollowers();
          //setState(() {});
        });
      },
      style:  TextButton.styleFrom(
        primary: Colors.black54,
      ),
      child: Container(
        height: 80,
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                "Following",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  buildProfileButton() {
    bool isProfileOwner = currentUserID == widget.profileID;
    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function : editProfile);
    }
  }

  buildButton({String text, Function function}) {
    Orientation orientation = MediaQuery.of(context).orientation;
   return Padding(
     padding: const EdgeInsets.only(top: 10),
     child: Row(
       children: [
         Container(
              //height: 30,
              width:orientation == Orientation.portrait? MediaQuery.of(context).size.width * 0.91 : MediaQuery.of(context).size.width * 0.95,
              child: ElevatedButton(
                onPressed: () => function(),
                child: Text(
                  text,
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              ),
       ],
     ),
   );
  }

  editProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile(currentUserID: user.id,))).then((_) {
      getUser();
      //setState(() {});
    }
    );
  }
}
