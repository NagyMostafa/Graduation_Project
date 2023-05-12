import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/shop/Upload_Product.dart';
import 'package:graduationproject/shop/my_products_posts.dart';
import 'package:graduationproject/styles/icon_broken.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  bool isLoad = false;
  List<MyProductPosts> myProducts = [];

  getMyProducts() async {
    setState(() {
      isLoad = true;
    });
    QuerySnapshot snapshot =
        await shopRef.orderBy('timestamp', descending: true).get();
    setState(() {
      isLoad = false;
      myProducts =
          snapshot.docs.map((doc) {
           return MyProductPosts.fromDocument(doc);
          }).toList();
    });
  }

/*  buildShopPosts() {
    if(myProducts.isNotEmpty) {
      return Column(
        children: myProducts,
      );
    }
    else{
      return Center(child: Text("No posts"),);
    }
  }*/



  @override
  void initState() {
    getMyProducts();
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
            padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => UploadProduct()))
                    .then((_) {
                  getMyProducts();
                  setState(() {});
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 125,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'add Product',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        IconBroken.Arrow___Up_Square,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],

        title: Text(
          'My Products',
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
      ),
      body: !isLoad
          ? RefreshIndicator(
              onRefresh: () => getMyProducts(),
              color: Colors.grey,
              child: !isLoad
                  ? GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.79,
                          crossAxisCount: 2),
                      children: myProducts.where((e) => e.ownerId==currentUser.id).toList(),
                    )
                  : Container(
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
            )
          : Container(
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
    );
  }
}
