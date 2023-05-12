import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';


class AddProblem extends StatefulWidget {
  @override
  _AddProblemState createState() => _AddProblemState();
}

class _AddProblemState extends State<AddProblem> {
  TextEditingController issueCaptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isUploading = false;
  final UserInformation currentuser = currentUser;
  File file;
  final ImagePicker imagepicker = ImagePicker();
  String postId = Uuid().v4();
  bool _displayCaptionValid = true;
  bool _displayLocationValid = true;
  bool islocating = false;

  String userLongitude = "";
  String userLatitude= "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Problem',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            IconBroken.Arrow___Left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          TextButton(
            onPressed:() => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),

      body: ListView(
        children: [
          isUploading? linearProgress() : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Container(
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 30,
                    backgroundImage:
                    CachedNetworkImageProvider(currentuser.photoUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      currentuser.username,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Container(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: issueCaptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Post...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          /*file != null
              ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Stack(
              children: [
                Container(
                  //height: 530,
                  //width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(file),
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10,top: 5),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        radius: 25,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 27,
                            ),
                            onPressed: () {
                              setState(() {
                                file = null;
                              });
                            },
                            color: Colors.black,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ) : Container(),
          Divider(),*/
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: ListTile(
              leading: Icon(
                IconBroken.Location,
                color: Colors.orange,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Write Your Current Location',
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
              trailing: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 20,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: islocating == false? IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      onPressed: getUserLocation,
                      color: Colors.white,
                    ) :  Container(
                      alignment: Alignment.center,
                      child:
                      SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }


  createProblemInFirestore({String location, String issueDescription}) {
    final DateTime timestamp = DateTime.now();
    issueRef
        .doc()
        .set({
      "ownerId": currentuser.id,
      "issueDescription": issueDescription,
      "location": location,
      "timestamp": timestamp,
      'situation': 'open',
      'longitude': userLongitude,
      'latitude': userLatitude,
    });
    print("$timestamp");
  }
  handleSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      issueCaptionController.text.isEmpty ? _displayCaptionValid = false
          : _displayCaptionValid = true;
      locationController.text.isEmpty ? _displayLocationValid = false
          : _displayLocationValid = true;
    });
    if(_displayCaptionValid == true && _displayLocationValid == true) {
      setState(() {
        isUploading = true;
      });
      createProblemInFirestore(
          location: locationController.text,
          issueDescription: issueCaptionController.text,
        );
      issueCaptionController.clear();
      locationController.clear();
      setState(() {
        isUploading = false;
        postId = Uuid().v4();
      });
      Navigator.of(context).pop(true);
    }
    else{
      Fluttertoast.showToast(
        msg: 'You must fill in all fields',
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        timeInSecForIosWeb: 1,
      );
    }
  }




  getUserLocation() async {
    setState(() {
      islocating = true;
    });
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    userLongitude = position.longitude.toString();
    userLatitude = position.latitude.toString();

    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
    setState(() {
      islocating = false;
    });
  }


}
