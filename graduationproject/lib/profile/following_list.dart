import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class FollowingList extends StatefulWidget {
  final userId;
  const FollowingList({this.userId});

  @override
  _FollowingListState createState() => _FollowingListState(
        userId: this.userId,
      );
}

class _FollowingListState extends State<FollowingList> {
  final String userId;
  bool isLoading = true;
  _FollowingListState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Following List',
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
                    print(sh.data);
                    if (!sh.hasData) {
                      return Center();
                    } else {
                      UserInformation user;
                         user = UserInformation.fromDocument(sh.data);
                      return TextButton(
                        style:  TextButton.styleFrom(
                          primary: Colors.black54,
                        ),
                        onPressed: () => showProfile(context, profileId: user.id),
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
                                  padding: const EdgeInsets.only(left: 10,top: 13),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.username,textAlign: TextAlign.start,style: TextStyle(
                                          color: Colors.black
                                      ),),
                                      Text(user.displayName, style: TextStyle(
                                        color: Colors.grey,
                                      ),),
                                    ],
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

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(profileID: profileId,),
      ),
    );
  }
}
