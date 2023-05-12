import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/helping_issues/add_problem.dart';
import 'package:graduationproject/helping_issues/issue_post.dart';
import 'package:graduationproject/helping_issues/userissue_post.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class UserIssuePosts extends StatefulWidget {
  @override
  _UserIssuePostsState createState() => _UserIssuePostsState();
}

class _UserIssuePostsState extends State<UserIssuePosts> {

  bool isLoading = false;
  List<UserIssuePost> posts;

  getUserIssuePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot =
    await issueRef.orderBy('timestamp', descending: true).get();
    setState(() {
      isLoading = false;
      posts = snapshot.docs.map((doc) => UserIssuePost.fromDocument(doc)).toList();
    });
  }

  @override
  void initState() {
    getUserIssuePosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                IconBroken.Plus,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => AddProblem(),
                ))
                    .then((_) {
                  getUserIssuePosts();
                  setState(() {});
                });
              })
        ],
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            IconBroken.Arrow___Left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text(
          'My Problems',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: isLoading
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
          : ListView(
        children: posts,
      ),
    );
  }
}
