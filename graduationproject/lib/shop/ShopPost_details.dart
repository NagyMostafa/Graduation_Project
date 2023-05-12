import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class ShopPostDetails extends StatefulWidget {
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

  const ShopPostDetails(
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
  _ShopPostDetailsState createState() => _ShopPostDetailsState(
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

class _ShopPostDetailsState extends State<ShopPostDetails> {
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
  final String currentUserId = currentUser?.id;

  TextEditingController messageController = TextEditingController();

  _ShopPostDetailsState({
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

  custom() {
    return CustomScrollView(slivers: [
      SliverAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  color: Colors.black,
                ),
              )),
        ),
        backgroundColor: Colors.white,
        expandedHeight: MediaQuery.of(context).size.height * 40 / 100,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            image: DecorationImage(
              image: NetworkImage(
                mediaUrl,
              ),
              fit: BoxFit.cover,
            ),
          )),
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
          Text("hjdjkhjksdf"),
        ]),
      )
    ]);
  }

  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: MediaQuery.of(context).size.height * 40 / 100,
            floating: false,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 1,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        IconBroken.Arrow___Left,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      color: Colors.black,
                    ),
                  )),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  decoration: BoxDecoration(
               /* borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),*/
                image: DecorationImage(
                  image: NetworkImage(
                    mediaUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              )),
            ),
          )
        ];
      },
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5,left: 15),
                child: Container(
                  child: Text(
                    productName,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5,left: 15),
                child: Container(
                  child: Text(
                    price + "\$",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10,),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userPhoto),
                    backgroundColor: Colors.grey,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          username,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        timeago.format(timestamp.toDate()),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
             currentUserId != ownerId? ListTile(
                leading: Icon(
                  IconBroken.Message,
                  color: Colors.blue,
                  size: 35,
                ),
                title: Container(
                  width: 250,
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => sendMessage(senderId: currentUser.id,receiverId: ownerId,message: messageController.text),
                  child: Text(
                    'Send',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 30,left: 15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'description:',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: Colors.black, //fontSize: 10
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              phoneNo != "" ?
              Padding(
                padding: const EdgeInsets.only(top: 15,left: 15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone No:',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                phoneNo,
                                style: TextStyle(
                                  color: Colors.black, //fontSize: 10
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container(),
            ],
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    setState(() {
      messageController.text = defaultMessage;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nested(),
          /*custom(),*/
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
        .get().then((doc) {
          if(!doc.exists)
            {
              userRef
                  .doc(senderId)
                  .collection('chats_users')
                  .doc(receiverId)
                  .set({});
            }
    });
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
        .get().then((doc) {
      if(!doc.exists)
      {
        userRef
            .doc(receiverId)
            .collection('chats_users')
            .doc(senderId)
            .set({});
      }
    });

    messageController.clear();
  }

}
