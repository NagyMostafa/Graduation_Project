import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/chat_content/chats.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/activity_feed.dart';
import 'package:graduationproject/post/create_post.dart';
import 'package:graduationproject/post/post.dart';
import 'package:graduationproject/post/timeline_posts.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';
import 'package:graduationproject/pages/home.dart';

class Timeline extends StatefulWidget {
  final String profileID;

  Timeline({this.profileID});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<TimeLinePosts> posts = [];

  /*getTimelinePosts(){
    Orientation orientation = MediaQuery.of(context).orientation;
    return FutureBuilder(
      future: followingRef.doc(widget.profileID).collection('userFollowing').get(),
      builder: (context , snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        else{
          List<String> followingList = [];
          snapshot.data.docs.forEach((e) {
            followingList.add(e.id.toString());
          });
          return ListView(
            children: followingList.map((e) {
              return FutureBuilder(
                future: postsRef
                    .doc(e.trim())
                    .collection('userPosts')
                    .orderBy('timestamp', descending: true)
                    .get(),
                builder: (context, snapshot){
                 if(snapshot.hasData){
                   List<Post> posts = [];
                   snapshot.data.docs.forEach((doc){
                     Post post = Post.fromDocument(doc);
                     posts.add(post);
                   });
                   return Column(
                     children: posts,
                   );
                 }
                 return Padding(
                   padding:orientation == Orientation.portrait? const EdgeInsets.only(top:  300) : const EdgeInsets.only(top:  100),
                   child: circularProgress(),
                 );
                },
              );
            }).toList(),
          );
        }
        });
  }*/
  getTimeline( List<TimeLinePosts> posts)  async{
    QuerySnapshot snapshot = await postsRef
        .orderBy('timestamp', descending: true).limit(50)
        .get();
    setState(() {
      posts = snapshot.docs.map((doc) => TimeLinePosts.fromDocument(doc)).toList();
    });
  }

  getTimelinePosts(){
    posts = [];
    return FutureBuilder(
      future: followingRef.doc(widget.profileID).collection('userFollowing').get(),
      builder: (context,snapshot){
        if(snapshot.hasData)
          {
            List<String> followingList = [];
            snapshot.data.docs.forEach((e) {
              followingList.add(e.id.toString());
            });
            return FutureBuilder(
              future: postsRef.orderBy('timestamp', descending: true).limit(50).get(),
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  posts = [];
                  TimeLinePosts post;
                  snapshot.data.docs.forEach((doc) {
                    post = TimeLinePosts.fromDocument(doc);
                    posts.add(post);
                  });
                  posts = posts
                      .where((element) =>
                  followingList.contains(element.ownerId) )
                      .toList();
                  return ListView(
                    shrinkWrap: true,
                      children: posts.map((postItem) {
                        return postItem;
                      }).toList());
                }
                return Center(
                  child: circularProgress(),
                );
              },
            );
          }
        return circularProgress();
      },
    );
  }



  @override
  Widget build(context) {
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
                    IconBroken.Plus,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CreatePost.routname);
                  },
                  color: Colors.black,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      radius: 17,
                      child: IconButton(
                            icon: Icon(
                              IconBroken.Notification,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(ActivityFeed.routname);
                            },
                            color: Colors.black,
                          ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 9,
                        child: Center(
                            child: Text(
                              '9+',
                              style: TextStyle(fontSize: 10),
                            )),
                      ),
                    )*/
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      radius: 17,
                      child: IconButton(
                            icon: Icon(
                              IconBroken.Chat,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(ChatScreen.routname);
                            },
                            color: Colors.black,
                          ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 9,
                        child: Center(
                            child: Text(
                              '9+',
                              style: TextStyle(fontSize: 10),
                            )),
                      ),
                    )*/
                  ],
                ),
              )),
        ],
        title: Text(
          'GroupGram',
          style: GoogleFonts.aladin(color: Colors.black),
        ),
      ),
      body: getTimelinePosts(),
    );
  }
}
