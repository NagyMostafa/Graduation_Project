import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class CreateAccount  {
  String username;
  GlobalKey <FormState> formKey = GlobalKey();

  Widget buildDialog(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Set Up Your Profile',
              style: TextStyle(color: Colors.blueAccent, fontSize: 25),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Create a Username',
                      style: TextStyle(
                          fontSize: 15,color: Colors.blue
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12),
                    child: Container(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          maxLength: 12,
                          cursorColor: Colors.black,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: 'username....',
                          ),
                          onSaved: (val) => username = val,
                          autovalidate: true,
                          validator: (val) {
                            if (val.isEmpty || val.trim().length < 5) {
                              return 'username must be at least 5 character';
                            } else if(val.trim().length > 12){
                              return 'usernamse is to long';
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Approve'),
                onPressed: () => submit(ctx),
              ),
            ],
          );
        });
  }


  submit(BuildContext ctx){
    final isValid = formKey.currentState.validate();
    FocusScope.of(ctx).unfocus();
    if(isValid)
    {
      formKey.currentState.save();
      Fluttertoast.showToast(
        msg: 'Welcome $username',
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        timeInSecForIosWeb: 1,
      );
      Navigator.of(ctx).pop();
      saveUsername(username.trim());

    }else{
      Fluttertoast.showToast(
        msg: 'Please Put a right Username',
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        timeInSecForIosWeb: 1,
      );
    }
  }
  saveUsername(String username){
    final userInfo = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('Users');
    userRef.doc(userInfo.uid).update({
      "username": username,
    });
  }
}
