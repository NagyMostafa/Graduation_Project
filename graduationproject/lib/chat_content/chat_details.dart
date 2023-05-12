import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/message.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class ChatDetails extends StatelessWidget {
  final UserInformation receiver;

  ChatDetails({this.receiver});

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(receiver.photoUrl),
              radius: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                receiver.username,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            IconBroken.Arrow___Left,
            size: 30,
          ),
          onPressed: () {
            messageController.clear();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: userRef
                  .doc(currentUser.id)
                  .collection('chats')
                  .doc(receiver.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(receiver.id);
                  List<MessageInformation> messages = [];
                  snapshot.data.docs.forEach((doc){
                  MessageInformation message = MessageInformation.fromDocument(doc);
                  messages.add(message);
                });
                  return Expanded(
                    child: ListView(
                      children: messages.map((msg) {
                        if(msg.senderId == currentUser.id)
                          {
                            return BubbleNormal(
                              text: msg.message,
                              isSender: true,
                              color: Color(0xFFE8E8EE),
                              tail: true,
                            );
                          } else {
                          return BubbleNormal(
                            text: msg.message,
                            isSender: false,
                            color: Color(0xFF80DEEA),
                            tail: true,
                          );
                        }
                      }).toList(),
                    ),
                  );
                }
                return Container();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'type your message here ...',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  color: Colors.blue,
                  child: MaterialButton(
                    onPressed: () => sendMessage(
                        senderId: currentUser.id,
                        receiverId: receiver.id,
                        message: messageController.text),
                    minWidth: 1.0,
                    child: Icon(
                      IconBroken.Send,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),

 /*           Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300],
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextFormField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'type your message here ...',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () => sendMessage(
                          senderId: currentUser.id,
                          receiverId: receiver.id,
                          message: messageController.text),
                      minWidth: 1.0,
                      child: Icon(
                        IconBroken.Send,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )*/
          ],
        ),
      ),
    );
  }

  sendMessage({String senderId, String receiverId, String message}) {
    final DateTime timestamp = DateTime.now();
    userRef
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    });
    userRef
        .doc(senderId)
        .collection('chats_users')
        .doc(receiverId)
        .set({});

    userRef
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    });

    userRef
        .doc(receiverId)
        .collection('chats_users')
        .doc(senderId)
        .set({});

    messageController.clear();
  }

}
