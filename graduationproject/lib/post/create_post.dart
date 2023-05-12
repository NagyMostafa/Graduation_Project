import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;



class CreatePost extends StatefulWidget {
  static const routname = '/CreateProduct';
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isUploading = false;
  final UserInformation currentuser = currentUser;
  File file;
  final ImagePicker imagepicker = ImagePicker();
  String postId = Uuid().v4();
  bool _displayCaptionValid = true;
  bool islocating = false;


  handleTakePhoto() async {
    Navigator.of(context).pop();
    PickedFile pickedImage = await imagepicker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  handleChooseFromGallery() async {
    Navigator.of(context).pop();
    PickedFile pickedImage =
    await imagepicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Choose Post photo"),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Photo with Camera"), onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Post',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            IconBroken.Arrow___Left,
            size: 30,
          ),
          onPressed: () {
            clearImage();
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
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Post...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          file != null
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
          Divider(),
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
          /*Container(
            height: 100,
            width: 200,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, // background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
              ),
              onPressed: () {
                print('user location');
              },
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                "Use Current Location",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )*/
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => selectImage(context),
        label: Text('Upload Photo',
            style: TextStyle(
              color: Colors.white,
            )),
        icon: Icon(
          IconBroken.Arrow___Up_Square,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }
  Future<String> uploadImage(imageFile) async {
     var uploadTask = storageRef.child("post_$postId.jpg");
     await uploadTask.putFile(imageFile);
     String downloadUrl = await uploadTask.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({String mediaUrl, String location, String description,String photoId}) {
    final DateTime timestamp = DateTime.now();
    postsRef
        .doc()
        .set({
      "photoId": photoId,
      "ownerId": currentuser.id,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "likes": {},
    });
    print("$timestamp");
  }

  handleSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      captionController.text.isEmpty ? _displayCaptionValid = false
          : _displayCaptionValid = true;
    });
    if(_displayCaptionValid == true) {
      setState(() {
        isUploading = true;
      });
      if(file != null) {
        await compressImage();
        String mediaUrl = await uploadImage(file);
        createPostInFirestore(
          mediaUrl: mediaUrl,
          location: locationController.text,
          description: captionController.text,
          photoId: postId,
        );
      }
      else{
        createPostInFirestore(
          mediaUrl: null,
          location: locationController.text,
          description: captionController.text,
          photoId: null,
        );
      }
      captionController.clear();
      locationController.clear();
      setState(() {
        file = null;
        isUploading = false;
        postId = Uuid().v4();
      });
      Navigator.of(context).pop(true);
    }
    else{
      Fluttertoast.showToast(
        msg: 'You must write a post',
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
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, '
        '${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
    setState(() {
      islocating = false;
    });
  }





}
