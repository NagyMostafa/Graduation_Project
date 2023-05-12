import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:graduationproject/widgets/progress.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  const Comments({this.postId, this.postOwnerId, this.postMediaUrl});

  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class CommentsState extends State<Comments> {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  TextEditingController commentController = TextEditingController();

  CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  String str = "";

  handleChange(query) {
    str = query;
    if (query.isEmpty ||
        query == "\n" ||
        query == "\n\n" ||
        query == "\n\n\n") {
      setState(() {
        str = "";
      });
    } else {
      setState(() {
        str = query;
      });
    }
    print(str);
  }

  buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .doc(postId)
            .collection('comments')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        title: Text(
          'Comments',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              commentController.clear();
            });
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(child: buildComments()),
          //Divider(),
          ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                backgroundImage:
                    CachedNetworkImageProvider(currentUser.photoUrl),
              ),
              title: Container(
                width: 300,
                child: TextField(
                  textAlign: TextAlign.justify,
                  onChanged: handleChange,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 1,
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a Comment....',
                    border: InputBorder.none,
                  ),
                ),
              ),
              trailing: str != ""
                  ? TextButton(
                      onPressed: addComment,
                      child: Text(
                        'Post',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 20),
                      ),
                    )
                  : TextButton(
                      onPressed: null,
                      child: Text(
                        'Post',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    )),
        ],
      ),
    );
  }



  addComment() {
    final DateTime timestamp = DateTime.now();
    commentsRef.doc(postId).collection('comments').add({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
      "postId": postId,
      "postOwnerId" : postOwnerId,
    });
    bool isNotPostOwner = postOwnerId != currentUser.id;
    print("$postOwnerId");
    if (isNotPostOwner) {
      activityFeedRef.doc(postOwnerId).collection('feedItems').add({
        "type": "comment",
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "commentData": commentController.text,
        "userId": currentUser.id,
        "ownerId": postOwnerId,
        "postId": postId,
        "mediaUrl": postMediaUrl,
        "timestamp": timestamp,
      });
    }
    commentController.clear();
    setState(() {
      str = "";
    });
    print(str);
    print("$timestamp");
  }




}

class Comment extends StatelessWidget {
  final String commentId;
  final String postId;
  final String username;
  final String userId;
  final String avatarUrl;
  final String postOwnerId;
  final String comment;
  final Timestamp timestamp;
  bool commentDeleted = false;
  final String currentUserId = currentUser?.id;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
    this.commentId,
    this.postId,
    this.postOwnerId,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      commentId: doc.id,
      postId: doc['postId'],
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
      postOwnerId: doc['postOwnerId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(commentDeleted == false) {
      return ListTile(
        onLongPress: currentUserId == userId
            ? () => handleDeleteChat(context, commentId, postId)
            : () {},
        title: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => showProfile(context, profileId: userId),
                  child: Text(
                    username,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  comment,
                )),
              ],
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () => showProfile(context, profileId: userId),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 15,
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
        ),
        subtitle: Text(
          timeago.format(timestamp.toDate()),
          style: TextStyle(fontSize: 10),
        ),
      );
    }
    else
      {
        return Container();
      }
    /*return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(avatarUrl),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => showProfile(context, profileId: userId),
                            child: Text(username,textAlign: TextAlign.start,style: TextStyle(
                              color: Colors.black,fontSize: 15
                    ),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(comment,)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(timeago.format(timestamp.toDate()),style: TextStyle(fontSize: 10),),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );*/
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



  deleteComment({String commentId,String postId}) async{
    commentsRef
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    }).then((_) {
      commentDeleted = true;
    });
    if(currentUserId != postOwnerId)
      {
        QuerySnapshot activityFeedSnapshot = await activityFeedRef
            .doc(postOwnerId)
            .collection("feedItems")
            .where('commentId', isEqualTo: commentId)
            .get();
        activityFeedSnapshot.docs.forEach((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      }
  }
  handleDeleteChat(BuildContext parentContext, String commentId,String postId) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this Comment?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    deleteComment(commentId: commentId,postId: postId);
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

}
