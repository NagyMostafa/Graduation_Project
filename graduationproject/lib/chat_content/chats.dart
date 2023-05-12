import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/chat_content/start_chat.dart';
import 'package:provider/provider.dart';
import 'package:graduationproject/chat_content/chat_details.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class ChatScreen extends StatefulWidget {
  static const routname = '/ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool chatDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Chat',
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
      body: chatDeleted == false
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream: userRef
                      .doc(currentUser.id)
                      .collection('chats_users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> ids = [];
                      snapshot.data.docs.forEach((element) {
                        ids.add(element.id.toString());
                      });
                      return SingleChildScrollView(
                        child: Column(
                          children: ids.map((e) {
                            print(e.toString());
                            return StreamBuilder(
                              stream: userRef.doc(e.toString()).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserInformation user;
                                  user = UserInformation.fromDocument(
                                      snapshot.data);
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black54,
                                    ),
                                    onLongPress: () => handleDeleteChat(
                                        context, currentUser.id, user.id),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ChatDetails(
                                                    receiver: user,
                                                  )));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      user.photoUrl),
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
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                          }).toList(),
                        ),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            )
          : Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StartChat(userId: currentUser.id,)));
        },
        label: Text("Start Chat!",style: TextStyle(color: Colors.blue),),
        icon: Icon(
          IconBroken.Chat,
          size: 20,
          color: Colors.blue,
        ),
      ),
    );
  }

  deleteChat(String senderId, String receiverId,) {
    userRef
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs)
        {
          doc.reference.delete();
        }
    });
    userRef
        .doc(senderId)
        .collection('chats_users')
        .doc(receiverId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      chatDeleted = true;
    });
  }
  handleDeleteChat(BuildContext parentContext, String senderId, String receiverId,) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this Chat?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    deleteChat(senderId, receiverId);
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
