import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class FollowersList extends StatefulWidget {
  final userId;

  const FollowersList({this.userId}) ;
  @override
  _FollowersListState createState() => _FollowersListState(userId: this.userId,);
}

class _FollowersListState extends State<FollowersList> {
  final String userId;

  _FollowersListState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Followers List',
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
        stream: followersRef.doc(userId).collection('userFollowers').snapshots(),
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
                    if (!sh.hasData) {
                      return Center();
                    } else {
                      print(sh.data);
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
