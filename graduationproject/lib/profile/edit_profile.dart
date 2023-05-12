import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/personal_information.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class EditProfile extends StatefulWidget {
  final String currentUserID;
  const EditProfile({this.currentUserID}) ;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
bool isLoading = false;
UserInformation user;
bool _displayNameValid = true;
bool _bioValid = true;
bool _userNameValid = true;

bool isUploaded = false;


TextEditingController displayNameController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController bioController = TextEditingController();


getUser() async{
  setState(() {
    isLoading = true;
  });

  DocumentSnapshot  doc = await userRef.doc(widget.currentUserID).get();
  user = UserInformation.fromDocument(doc);
    displayNameController.text = user.displayName;
    usernameController.text = user.username;
    bioController.text = user.bio;
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
          'Edit Profile',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        actions: [
          !isUploaded? IconButton(
            icon: Icon(IconBroken.Edit,color: Colors.blue,size: 30,),
            onPressed: () {
              updateProfileData();
            },
          ): Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              alignment: Alignment.center,
              child:
              SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.blue,
                  ),
                ),
                height: 20.0,
                width: 20.0,
              ),
            ),
          ),
        ],
        leading: IconButton(
          color: Colors.red,
         icon : Icon(Icons.clear,size: 30,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading? circularProgress() : ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16,bottom: 8),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildDisplayNameField(),
                    buildUsernameField(),
                    buildBoiNameField(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 120),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalInformation(currentUserID: user.id,)),);
                            },
                            child: Text('Personal Information',style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                            ),),
                          ),
                        ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

updateProfileData() {
  setState(() {
    displayNameController.text.trim().length < 3 ||
        displayNameController.text.isEmpty
        ? _displayNameValid = false
        : _displayNameValid = true;
    bioController.text.trim().length > 100
        ? _bioValid = false
        : _bioValid = true;
    usernameController.text.trim().length < 5 || usernameController.text.trim().length > 12 || usernameController.text.trim().isEmpty?
       _userNameValid = false : _userNameValid = true ;
  });

  if (_displayNameValid && _bioValid && _userNameValid) {
    setState(() {
      isUploaded = true;
    });
    userRef.doc(widget.currentUserID).update({
      "displayName": displayNameController.text,
      "bio": bioController.text,
      "username" : usernameController.text,
    }).then((_) {
      if(this.mounted) {
          setState(() {
            isUploaded = false;
          });
        }
      Navigator.of(context).pop(true);
        Fluttertoast.showToast(
        msg: 'Profile Updated',
          textColor: Colors.white,
          backgroundColor: Colors.grey,
        timeInSecForIosWeb: 1,
      );
    });
  }
}

  buildDisplayNameField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text('Display Name',style: TextStyle(
          color: Colors.grey,
        ),),
      ),
      TextField(
        controller: displayNameController,
        decoration: InputDecoration(
          hintText: 'Update Display Name',
          errorText: _displayNameValid ? null : "Display Name too short",
        ),
      ),
    ],
  );
  }

  buildUsernameField() {
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text('User Name',style: TextStyle(
            color: Colors.grey,
          ),),
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
              hintText: 'Update User Name',
              errorText: _userNameValid? null : "The name must be at least 5 or more characters long The most 12 characters",
          ),
        ),
      ],
    );
  }

  buildBoiNameField() {
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text('Bio',style: TextStyle(
            color: Colors.grey,
          ),),
        ),
        TextField(
          controller: bioController,
          maxLines: null,
          //style: TextStyle(),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Update Bio',
            errorText: _bioValid ? null : "Bio too long",
          ),
        ),
      ],
    );
  }




}
