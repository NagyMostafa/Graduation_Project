import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/shop/shop_posts.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class ShopSearch extends StatefulWidget {
  static const routname = '/ShopSearch';
  @override
  _ShopSearchState createState() => _ShopSearchState();
}

class _ShopSearchState extends State<ShopSearch> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultFuture;
  String searchQuery = "";
  GlobalKey <FormState> queryKey = GlobalKey();





  handleSearchProduct(String query){
    Future<QuerySnapshot> users = shopRef.orderBy("productName").startAt([query]).endAt([query + '\uf8ff']).get();
    if(users != null) {
      setState(() {
        searchResultFuture = users;
      });
    }
    queryKey.currentState.save();
  }







  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultFuture = null;
      searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final  Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResultFuture == null || searchQuery == "" ? Container() : buildSearchResult(),
    );
  }


  AppBar buildSearchField() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Center(
        child: Container(
          height: 35,
          width:orientation == Orientation.portrait? 490 : 700,
          child: Form(
            key: queryKey,
            child: TextFormField(
              controller: searchController,
              autocorrect: false,
              cursorColor: Colors.black,
              cursorWidth: 0.5,
              onSaved: (val) => searchQuery = val,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.6),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5),width: 0),
                    borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5),width: 0),
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: 'Search',

                suffixIcon: searchQuery != ""? Container(
                  width: 20,
                  //alignment: Alignment.topRight,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    child: IconButton(
                      icon: Icon(
                        IconBroken.Delete,
                        //color: Colors.black,
                      ),
                      onPressed: () => clearSearch(),
                    ),
                  ),
                ): null ,
              ),
              onFieldSubmitted: handleSearchProduct,
              onChanged: handleSearchProduct,
            ),
          ),
        ),
      ),

      leading: IconButton(
        color: Colors.black,
        icon : Icon(IconBroken.Arrow___Left,size: 30,),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
    );
  }




  buildSearchResult(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return FutureBuilder(
        future: searchResultFuture,
        builder:(context,snapShot){
          if(!snapShot.hasData)
          {
            return Center(child: circularProgress());
          }
          else{
            List<ShopPosts> shopPosts =[];
            snapShot.data.docs.forEach((doc){
              ShopPosts post = ShopPosts.fromDocument(doc);
              shopPosts.add(post);
            });
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.79, crossAxisCount: 2),
              children: shopPosts.toList(),
            );
          }
        }

    );
  }





}
