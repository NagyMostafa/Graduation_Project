import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';




class PersonalInformation extends StatefulWidget {
  final String currentUserID;

  const PersonalInformation({this.currentUserID}) ;

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  bool isLoading = false;
  UserInformation user;

  getUser()async{
    setState(() {
      isLoading = true;
    });
     DocumentSnapshot doc = await userRef.doc(widget.currentUserID).get();
     user = UserInformation.fromDocument(doc);
     setState(() {
       isLoading = false;
     });
  }
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Personal Information',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        leading: IconButton(
          color: Colors.black,
          icon : Icon(IconBroken.Arrow___Left,size: 30,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading? circularProgress() : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Display Name:',style: TextStyle(
                          color: Colors.blue,fontSize: 20
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(user.displayName ,style: TextStyle(
                              color: Colors.black,//fontSize: 10
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Name:',style: TextStyle(
                            color: Colors.blue,fontSize: 20
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(user.username ,style: TextStyle(
                            color: Colors.black,//fontSize: 10
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Address:',style: TextStyle(
                            color: Colors.blue,fontSize: 20
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(user.email ,style: TextStyle(
                            color: Colors.black,//fontSize: 10
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('bio:',style: TextStyle(
                            color: Colors.blue,fontSize: 20
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(user.bio == '' ? "No data to show" : user.bio ,style: TextStyle(
                            color: Colors.black,//fontSize: 10
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
