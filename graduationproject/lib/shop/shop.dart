import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduationproject/shop/my_products.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationproject/shop/Upload_Product.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/shop/shop_search.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/shop/shop_posts.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool isLoad = false;
  List<ShopPosts> shopPosts = [];


  getShopPosts() async {
    setState(() {
      isLoad = true;
    });
    QuerySnapshot snapshot = await shopRef
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    setState(() {
      isLoad = false;
      shopPosts = snapshot.docs.map((doc) => ShopPosts.fromDocument(doc)).toList();
    });
  }

  buildShopPosts() {
    return Column(
      children: shopPosts,
    );
  }

  final userInfo = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getShopPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Theme.of(context).accentColor,
         elevation: 0,
         actions: [
           Padding(
             padding: const EdgeInsets.only(right: 10,top: 10,bottom: 10),
             child: GestureDetector(
               onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadProduct())).then((_) {
                   getShopPosts();
                   setState(() {});
                 }
                 );
               },
               child: Container(
                 decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.5),
                   borderRadius: BorderRadius.circular(30),
                 ),
                 width: 125,
                 child:  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       child: Text('add Product',style: TextStyle(color: Colors.black),),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 8),
                       child: Icon(
                         IconBroken.Arrow___Up_Square,
                         size: 20,color: Colors.black,
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ],
         title: /*Row(
           children: [
             IconButton(
               onPressed: (){},
               icon: Icon(IconBroken.Search,color: Colors.blueAccent,size: 35,),
             ),
             Text('Shop',style: TextStyle(fontSize: 25,color: Colors.black),),
           ],
         ),*/  Text('Shop',style: TextStyle(fontSize: 25,color: Colors.black),),
         leading: IconButton(
           onPressed: (){
             Navigator.of(context).pushNamed(ShopSearch.routname);
           },
           icon: Icon(IconBroken.Search,color: Colors.blueAccent,size: 35,),
         ),
       ),
      body: !isLoad? RefreshIndicator(
        color: Colors.grey,
        onRefresh: () => getShopPosts(),
        child:!isLoad? GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15,
                    childAspectRatio: 0.78, crossAxisCount: 2),
                children: shopPosts,
        ) : Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.blue.withOpacity(0.7),
                        ),
                        strokeWidth: 3),
                  ],
                ))),
      ) :
      Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.blue.withOpacity(0.7),
                      ),
                      strokeWidth: 3),
                ],
              ))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProducts())).then((_) {
            getShopPosts();
            setState(() {});
          });
        },
        label: Text("My Products",style: TextStyle(color: Colors.blue),),
        icon: Icon(
          IconBroken.Bag,
          size: 20,
          color: Colors.blue,
        ),
      ),
    );
  }
}
