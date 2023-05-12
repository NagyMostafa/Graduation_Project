import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/shop/ShopPost_details.dart';

class MyProductPosts extends StatefulWidget {
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

  const MyProductPosts({
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

  factory MyProductPosts.fromDocument(DocumentSnapshot doc) {

      return MyProductPosts(
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
  _MyProductPostsState createState() => _MyProductPostsState(
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
      );
}

class _MyProductPostsState extends State<MyProductPosts> {
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
  bool productDeleted = false;

  _MyProductPostsState(
      {this.postId,
      this.ownerId,
      this.username,
      this.userPhoto,
      this.phoneNo,
      this.description,
      this.mediaUrl,
      this.timestamp,
      this.productName,
      this.price,
      this.defaultMessage});

  @override
  Widget build(BuildContext context) {
    if(productDeleted == false) {
        return GestureDetector(
          onLongPress: () => handleDeleteChat(context),
          onTap: () {
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
                          height: MediaQuery.of(context).size.height * 25 / 100,
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
                        style: GoogleFonts.novaRound(),
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        price + " \$", overflow: TextOverflow.ellipsis, maxLines: 1,
                        style: GoogleFonts.novaRound(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
    }
    else{
      return Container();
    }
  }



  deleteProduct() {
    shopRef
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      productDeleted = true;
    });
  }

  handleDeleteChat(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this Product?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    deleteProduct();
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
