import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/helping_issues/add_problem.dart';
import 'package:graduationproject/helping_issues/issue_post.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class TimelineIssues extends StatefulWidget {

  @override
  _TimelineIssuesState createState() => _TimelineIssuesState();
}

class _TimelineIssuesState extends State<TimelineIssues> {
  bool isLoading = false;
  List<IssuePost> posts;

  getIssuePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot =
        await issueRef.orderBy('timestamp', descending: true).get();
    setState(() {
      isLoading = false;
      posts = snapshot.docs.map((doc) => IssuePost.fromDocument(doc)).toList();
    });
  }

  @override
  void initState() {
    getIssuePosts();
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
                    .push(MaterialPageRoute(builder: (context) => AddProblem(),)).then((_) {
                  getIssuePosts();
                  setState(() {});});
              })
        ],
        title: Text(
          'Problems',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: isLoading ? Container(
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
        onRefresh:() => getIssuePosts(),
        color: Colors.grey,
            child: !isLoading ? ListView(
                children: posts,
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
          ),
    );
  }
}
