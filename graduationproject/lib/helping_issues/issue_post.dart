import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class IssuePost extends StatefulWidget {
  final String issueId;
  final String ownerId;
  final String issueDescription;
  final String location;
  final String situation;
  final Timestamp timestamp;
  final String longitude;
  final String latitude;

  const IssuePost({
    this.issueId,
    this.ownerId,
    this.issueDescription,
    this.location,
    this.situation,
    this.timestamp,
    this.longitude,
    this.latitude,
  });

  factory IssuePost.fromDocument(DocumentSnapshot doc) {
    return IssuePost(
      issueId: doc.id,
      ownerId: doc['ownerId'],
      situation: doc['situation'],
      location: doc['location'],
      issueDescription: doc['issueDescription'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  _IssuePostState createState() => _IssuePostState(
      issueId: this.issueId,
      ownerId: this.ownerId,
      issueDescription: this.issueDescription,
      situation: this.situation,
      timestamp: this.timestamp,
      location: this.location,
      longitude: this.longitude,
      latitude: this.latitude,
  );
}

class _IssuePostState extends State<IssuePost> {
  final String issueId;
  final String ownerId;
  final String issueDescription;
  final String location;
  final String situation;
  final Timestamp timestamp;
  final String longitude;
  final String latitude;
  final String currentUserId = currentUser?.id;
  bool myProblemRemoved = false;

  _IssuePostState({
    this.issueId,
    this.ownerId,
    this.issueDescription,
    this.location,
    this.situation,
    this.timestamp,
    this.longitude,
    this.latitude,
  });

  UserInformation user;

  buildPostHeader() {
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
            /*SizedBox(
              height: 10,
              child: Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),*/
            ListTile(
              leading: GestureDetector(
                onTap: () => showProfile(context, profileId: user.id),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  backgroundColor: Colors.grey,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showProfile(context, profileId: user.id),
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
                        timeago.format(timestamp.toDate()),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      !location.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                location,
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
              trailing: ownerId == currentUserId ? IconButton(onPressed: () {
              issueRef.doc(issueId).update({'situation':'closed'});
              setState(() {
                myProblemRemoved = true;
              });
              },icon: Icon(IconBroken.Delete),color: Colors.red,) : Text(""),
            ),
          ],
        );
      },
    );
  }
  buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Text(
            issueDescription,
            //textDirection: TextDirection.ltr,
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
  buildNavigateMap(){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => openMap(latitude, longitude),
        child: Stack(
          children: [
            Container(
              height: 85,
              child: Image.asset("assets/images/map1.jpg",),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("get direction",style: TextStyle(color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 220),
                    child: Icon(IconBroken.Location,color: Colors.green,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> openMap(latitude, longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if(situation == "open") {
      if (myProblemRemoved == false) {
        return Container(
          child: Column(
            children: [
              buildPostHeader(),
              buildDescription(),
              buildNavigateMap(),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 2,
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }
      else
        {
          return Container();
        }
    } else
      return Container();
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
