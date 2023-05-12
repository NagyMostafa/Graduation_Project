import 'package:flutter/material.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/post/post.dart';
import 'package:graduationproject/widgets/progress.dart';


class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef
          .doc(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(userId);
          print(postId);
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  'Post',
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
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
