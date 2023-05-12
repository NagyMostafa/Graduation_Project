import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/chat_content/chat_details.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class StartChat extends StatefulWidget {
  final userId;

  const StartChat({ this.userId});

  @override
  _StartChatState createState() => _StartChatState(userId: this.userId);
}

class _StartChatState extends State<StartChat> {
  final String userId;
  bool isLoading = true;
  _StartChatState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Chat SomeOne',
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
      body: StreamBuilder(
        stream: followingRef.doc(userId).collection('userFollowing').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: circularProgress());
          }  else {
            List<String> followingList = [];
            snapshot.data.docs.forEach((e) {
              followingList.add(e.id.toString());
            });
            return ListView(
              children: followingList.map((e) {
                return StreamBuilder(
                  stream: userRef.doc(e.toString()).snapshots(),
                  builder: (context, sh) {
                    //print(sh.data);
                    if (!sh.hasData) {
                      return Center();
                    } else {
                      UserInformation user;
                      user = UserInformation.fromDocument(sh.data);
                      //print(user.id);
                      return TextButton(
                        style:  TextButton.styleFrom(
                          primary: Colors.black54,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatDetails(receiver: user,)));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child:  Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                                  radius: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    user.username,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),

                        ),
                      );
                    }
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
