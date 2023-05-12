import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/post/post_screen.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  static const routname = '/ActivityFeed';

  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  List<ActivityFeedItem> feedItems = [];
  bool islood = true;

  getActivityFeed() async {
    setState(() {
      islood = true;
    });
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    setState(() {
      feedItems = snapshot.docs
          .map((doc) => ActivityFeedItem.fromDocument(doc))
          .toList();
      islood = false;
    });
    print(currentUser.id);
  }

  confirmViewActivityFeed(count) async {
    activityFeedCountRef.doc(currentUser.id).set({
      'activityFeedCount': count,
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    getActivityFeed();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        title: Text(
          'Activity Feed',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            IconBroken.Arrow___Left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: islood
          ? Container(
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
              )))
          : RefreshIndicator(
        color: Colors.grey,
        onRefresh: () => getActivityFeed(),
            child: Container(
                child: ListView(
                  children: feedItems,
                ),
              ),
          ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  bool isFollow = false;
  final String username;
  final String userId;
  final String ownerId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.ownerId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      ownerId: doc['ownerId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          userId: ownerId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "like" || type == 'comment') {
      if (mediaUrl != null) {
        mediaPreview = GestureDetector(
          onTap: () => showPost(context),
          child: Container(
            color: Colors.black,
            height: 50.0,
            width: 50.0,
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(mediaUrl),
                    ),
                  ),
                )),
          ),
        );
      }
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = " liked your post";
    } else if (type == 'follow') {
      print('xx');
      activityItemText = " is following you";
      isFollow = true;
      print('$isFollow');
    } else if (type == 'comment') {
      activityItemText = ' commented:';
    } else {
      activityItemText = " Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return GestureDetector(
      onTap: !isFollow ? () => showPost(context) : () {},
      child: ListTile(
        /*title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$activityItemText',
                    ),
                  ]),
            ),
          ),*/
        title: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showProfile(context, profileId: userId),
                      child: Text(
                        username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '$activityItemText',
                    )
                  ],
                ),
              ],
            ),
            commentData != ""
                ? Row(
                    children: [
                      Expanded(
                          child: Text(
                        '$commentData', overflow: TextOverflow.ellipsis, maxLines: 2,
                      ))
                    ],
                  )
                : Container(),
          ],
        ),
        leading: GestureDetector(
          onTap: () => showProfile(context, profileId: userId),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
        ),
        subtitle: Text(
          timeago.format(timestamp.toDate()),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: mediaPreview,
      ),
    );
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
}
