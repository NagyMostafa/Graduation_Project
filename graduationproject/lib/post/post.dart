import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/profile/profile.dart';
import 'package:graduationproject/post/comments.dart';
import 'package:graduationproject/pages/home.dart' ;
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/custom_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:graduationproject/widgets/progress.dart';


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String location;
  final String photoId;
  final String description;
  final String mediaUrl;
  final Timestamp timestamp;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.timestamp,
    this.photoId,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc.id,
      photoId: doc['photoId'],
      ownerId: doc['ownerId'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      timestamp: doc['timestamp'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;

    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        photoId: this.photoId,
        ownerId: this.ownerId,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        timestamp: this.timestamp,
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String photoId;
  final String ownerId;
  final String location;
  final String description;
  final String mediaUrl;
  final Timestamp timestamp;
  bool removed = false;
  int likeCount;
  Map likes;
  bool isliked = true;
  bool showHeart = false;

  _PostState({
    this.postId,
    this.photoId,
    this.ownerId,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
    this.timestamp,
  });

  HandleLikePost() {
    bool _isliked = likes[currentUserId] == true;
    postsRef
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        if (_isliked) {
          postsRef.doc(postId).set({
            'likes': {'$currentUserId': false}
          }, SetOptions(merge: true));
          removeLikeFromActivityFeed();
          setState(() {
            likeCount -= 1;
            isliked = false;
            likes[currentUserId] = false;
          });
        } else if (!_isliked) {
          postsRef.doc(postId).set({
            'likes': {'$currentUserId': true}
          }, SetOptions(merge: true));
          addLikeToActivityFeed();
          setState(() {
            likeCount += 1;
            isliked = true;
            likes[currentUserId] = true;
          });
        }
      }
      else
      {
        buildWarningDialog(context);
      }
    });
  }

  HandleLikePost_onDoubleTap() {
    bool _isliked = likes[currentUserId] == true;
    postsRef.doc(postId).get().then((doc) {
      if (doc.exists) {
        if (!_isliked) {
          postsRef.doc(postId).set({
            'likes': {'$currentUserId': true}
          }, SetOptions(merge: true));
          addLikeToActivityFeed();
          setState(() {
            likeCount += 1;
            isliked = true;
            likes[currentUserId] = true;
            showHeart = true;
          });
          Timer(Duration(milliseconds: 500), () {
            setState(() {
              showHeart = false;
            });
          });
        } else {
          setState(() {
            showHeart = true;
          });
          Timer(Duration(milliseconds: 500), () {
            setState(() {
              showHeart = false;
            });
          });
        }
      } else {
        buildWarningDialog(context);
      }
    });
  }

  addLikeToActivityFeed() {
    final DateTime timestamp = DateTime.now();
    print(ownerId);
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef.doc(ownerId).collection("feedItems").doc(postId).set({
        "type": "like",
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "commentData": "",
        "userId": currentUserId,
        "ownerId": ownerId,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  UserInformation user;

  /*buildPostHeader() {
    return FutureBuilder(
      future: userRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        user = UserInformation.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return Column(
          children: [
            *//*SizedBox(
              height: 10,
              child: Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),*//*
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => print('showing profile'),
                    child: Text(
                      user.username,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timeago.format(timestamp.toDate()), style: TextStyle(fontSize: 10,color: Colors.grey),),
                      !location.isEmpty ? Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(location, style: TextStyle(fontSize: 10),),
                      ) : Container(),
                    ],
                  )
                ],
              ),
              trailing: isPostOwner? IconButton(
                onPressed: () => handleDeletePost(context),
                icon: Icon(Icons.more_vert),
              ) : Text(""),
            ),
          ],
        );
      },
    );
  }*/

  buildPostHeader() {

   return FutureBuilder(
      future: userRef.doc(ownerId).get(),
      builder: (context,snapshot){
        if (snapshot.hasData) {
          user = UserInformation.fromDocument(snapshot.data);
          bool isPostOwner = currentUserId == ownerId;
          return Column(
            children: [
              ListTile(
                leading: GestureDetector(
                  //onTap: () => showProfile(context,profileId: user.id),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    backgroundColor: Colors.grey,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      //onTap: () => showProfile(context,profileId: user.id),
                      child: Text(
                        user.username,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          timeago.format(timestamp.toDate()), style: TextStyle(fontSize: 10,color: Colors.grey),),
                        !location.isEmpty ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(location, style: TextStyle(fontSize: 10),),
                        ) : Container(),
                      ],
                    )
                  ],
                ),
                trailing: isPostOwner? IconButton(
                  onPressed: () => handleDeletePost(context),
                  icon: Icon(Icons.more_vert),
                ) : Text(""),
              ),
            ],
          );
        }
        return circularProgress();
      },
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    deletePost();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  deletePost() async {
    // delete post itself
    postsRef
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    if(mediaUrl != null)
    {
      storageRef.child("post_$photoId.jpg").delete();
    }
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .get();
    activityFeedSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .doc(postId)
        .collection('comments')
        .get();
    commentsSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      removed = true;
    });
  }

  buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Text(
            description,
            textDirection: TextDirection.ltr,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
            ),
          )),
        ],
      ),
    );
  }

  buildPostImage() {
    return mediaUrl != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onDoubleTap: HandleLikePost_onDoubleTap,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  //cachedNetworkImage(mediaUrl),
                  //Image.network(mediaUrl),
                  InteractiveViewer(
                    panEnabled: false,
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 2,
                    child: cachedNetworkImage(mediaUrl),
                  ),
                  showHeart
                      ? Animator(
                          duration: Duration(milliseconds: 500),
                          tween: Tween(begin: 0.8, end: 1.4),
                          //curve: Curves.easeInOutSine,
                          curve: Curves.fastOutSlowIn,
                          cycles: 0,
                          builder: (context, anim, child) => Transform.scale(
                            scale: anim.value,
                            child: Icon(
                              Icons.favorite,
                              size: 70.0,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        : Container();
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: HandleLikePost,
              child: Icon(
                isliked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () {
                postsRef
                    .doc(postId)
                    .get()
                    .then((doc) {
                  if (doc.exists) {
                    showComments(
                      context,
                      postId: postId,
                      postOwnerId: ownerId,
                      postMediaUrl: mediaUrl,
                    );
                  }
                  else
                  {
                    buildWarningDialog(context);
                  }
                });
              },
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0, bottom: 5),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    isliked = (likes[currentUserId] == true);
      if (removed == false) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildPostHeader(),
              buildDescription(),
              buildPostImage(),
              buildPostFooter(),
            ],
          ),
        );
    } else {
        return Container();
      }
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          profileID: profileId,
        ),
      ),
    );
  }
  showComments(BuildContext ctx,
      {String postId, String postOwnerId, String postMediaUrl}) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => Comments(
          postId: postId,
          postOwnerId: postOwnerId,
          postMediaUrl: postMediaUrl,
        )));
  }

  Widget buildWarningDialog(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Warning",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("This Post is not available now"),
            actions: [
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}



