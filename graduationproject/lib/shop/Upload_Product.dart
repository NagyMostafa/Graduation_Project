import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:image/image.dart' as Im;
import 'package:graduationproject/widgets/progress.dart';
import 'package:uuid/uuid.dart';


class UploadProduct extends StatefulWidget {
  static const routname = '/UploadProduct';

  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {

  final UserInformation currentuser = currentUser;
  File file;
  final ImagePicker imagepicker = ImagePicker();
  String postId = Uuid().v4();
  TextEditingController captionController = TextEditingController();
  TextEditingController phoneNOController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  bool _displayCaptionValid = true;
  bool _displaypriceValid = true;
  bool _displayProductNameValid = true;
  bool isUploading = false;

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
            title: Text("Choose Product photo"),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Product',
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
            onPressed: () => handleSubmit(),
            child: Text(
              'Upload',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
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
          ListTile(
            leading: Icon(
               IconBroken.Edit,
              color: Colors.blueAccent,
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: 'Write product name',
                  border: InputBorder.none,
                ),
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
                    hintText: 'Write a Description...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          file != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                )
              : Container(),
          Divider(),
          ListTile(
            leading: Icon(
              IconBroken.Call,
              color: Colors.green,
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: phoneNOController,
                decoration: InputDecoration(
                  hintText: 'Write Your phone number (optional)',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Colors.green,
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Write product price \$',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          /*ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35,
            ),
            title: Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Write Your Current Location',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
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
          Icons.upload_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }





  createShopProductInFirestore({String mediaUrl,String phoneNumber,String description,String productName,String price}) {
    final DateTime timestamp = DateTime.now();
    shopRef
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": currentuser.id,
      "username": currentuser.username,
      "userPhoto" : currentuser.photoUrl,
      "phoneNo" : phoneNumber,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": timestamp,
      "productName" : productName,
      "price" : price,
      "defaultMessage" : "Is this item still available?" +productName,
    });
    print("$timestamp");
  }





  handleSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      captionController.text.isEmpty ? _displayCaptionValid = false
          : _displayCaptionValid = true;
      priceController.text.isEmpty ? _displaypriceValid = false
          : _displaypriceValid = true;
      productNameController.text.isEmpty ? _displayProductNameValid = false
          : _displayProductNameValid = true;
    });
    if(_displayCaptionValid == true && file != null && _displaypriceValid == true && _displayProductNameValid == true) {
      setState(() {
        isUploading = true;
      });
        await compressImage();
        String mediaUrl = await uploadImage(file);
      createShopProductInFirestore(
          mediaUrl: mediaUrl,
          phoneNumber: phoneNOController.text,
          description: captionController.text,
          productName: productNameController.text,
          price: priceController.text,
        );
      captionController.clear();
      phoneNOController.clear();
      productNameController.clear();
      priceController.clear();
      setState(() {
        file = null;
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




}
