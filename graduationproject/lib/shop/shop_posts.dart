import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/shop/ShopPost_details.dart';

class ShopPosts extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String userPhoto;
  final String phoneNo;
  final String description;
  final String mediaUrl;
  final Timestamp timestamp;
  final String productName;
  final String price;
  final String defaultMessage;

  const ShopPosts({
    this.postId,
    this.ownerId,
    this.username,
    this.userPhoto,
    this.phoneNo,
    this.description,
    this.mediaUrl,
    this.timestamp,
    this.productName,
    this.price,
    this.defaultMessage,
  });

  factory ShopPosts.fromDocument(DocumentSnapshot doc) {
    return ShopPosts(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      userPhoto: doc['userPhoto'],
      phoneNo: doc['phoneNo'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      timestamp: doc['timestamp'],
      productName: doc['productName'],
      price: doc['price'],
      defaultMessage: doc['defaultMessage'],
    );
  }

  @override
  _ShopPostsState createState() => _ShopPostsState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        userPhoto: this.userPhoto,
        phoneNo: this.phoneNo,
        description: this.description,
        mediaUrl: this.mediaUrl,
        timestamp: this.timestamp,
        productName: this.productName,
        price: this.price,
        defaultMessage: this.defaultMessage,
      );
}

class _ShopPostsState extends State<ShopPosts> {
  final String postId;
  final String ownerId;
  final String username;
  final String userPhoto;
  final String phoneNo;
  final String description;
  final String mediaUrl;
  final Timestamp timestamp;
  final String productName;
  final String price;
  final String defaultMessage;
  final String currentUserID = currentUser?.id;


  _ShopPostsState({
    this.postId,
    this.ownerId,
    this.username,
    this.userPhoto,
    this.phoneNo,
    this.description,
    this.mediaUrl,
    this.timestamp,
    this.productName,
    this.price,
    this.defaultMessage,
  });

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      onTap: () {
        shopRef
            .doc(postId)
            .get()
            .then((doc) {
          if (doc.exists) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShopPostDetails(
                  postId: postId,
                  ownerId: ownerId,
                  username: username,
                  userPhoto: userPhoto,
                  phoneNo: phoneNo,
                  description: description,
                  mediaUrl: mediaUrl,
                  timestamp: timestamp,
                  productName: productName,
                  price: price,
                  defaultMessage: this.defaultMessage,
                )));
          }
          else{
            buildWarningDialog(context);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(userPhoto),
                    radius: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(username),
                ),
              ],
            ),
            Center(
              child: mediaUrl != null
                  ? Container(

                      padding: EdgeInsets.all(5),
                      height:orientation == Orientation.portrait? MediaQuery.of(context).size.height * 25 / 100 : MediaQuery.of(context).size.height * 60 / 100,
                      //width: MediaQuery.of(context).size.width * 40 / 100,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              scale: 1,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                mediaUrl,
                              ))),
                    )
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.grey.withOpacity(0.7),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80,
                  child: Text(
                    productName, overflow: TextOverflow.ellipsis, maxLines: 1,softWrap: false,
                    style: GoogleFonts.novaRound(color: Colors.black),
                  ),
                ),
                Container(
                  width: 50,
                  child: Text(
                    price + " \$", overflow: TextOverflow.ellipsis, maxLines: 1,
                    style: GoogleFonts.novaRound(color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildWarningDialog(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Warning",style: TextStyle(color: Colors.red),),
            content: Text("This item is not available now"),
            actions: [
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
