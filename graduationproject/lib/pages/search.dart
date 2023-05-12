import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduationproject/models/user.dart';
import 'package:graduationproject/pages/activity_feed.dart';
import 'package:graduationproject/pages/home.dart';
import 'package:graduationproject/profile/profilescreen.dart';
import 'package:graduationproject/styles/icon_broken.dart';
import 'package:graduationproject/widgets/progress.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  //final userRef = FirebaseFirestore.instance.collection('Users');
  Future<QuerySnapshot> searchResultFuture;
  String searchQuery = "";
  GlobalKey <FormState> queryKey = GlobalKey();


  handleSearch(String query){
    Future<QuerySnapshot> users = userRef.orderBy("username").startAt([query]).endAt([query + '\uf8ff']).get();
    //Future<QuerySnapshot> usersQ = userRef.orderBy("displayName").startAt([query]).endAt([query + '\uf8ff']).get();
    if(users != null) {
      setState(() {
        searchResultFuture = users;
      });
    }
    queryKey.currentState.save();
   // print(searchQuery);
  }









  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultFuture = null;
      searchQuery = "";
    });
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
                onFieldSubmitted: handleSearch,
                onChanged: handleSearch,
              ),
            ),
          ),
        ),

      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child:  Icon(
          IconBroken.Search,
            color: Colors.black,
            size: 38,
          ),
      ),
    );
  }

  Container buildNoContent() {
   final  Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height:orientation == Orientation.portrait? 300 : 180,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
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
              return Padding(
                padding: const EdgeInsets.only(top: 25,left: 20),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child:
                                SizedBox(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.grey,
                                    ),
                                  ),
                                  height: 15.0,
                                  width: 15.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                  child: Text("Searching for",style: TextStyle(
                                      color: Colors.grey
                                  ),),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  width:orientation == Orientation.portrait ? 250 : 500,
                                  child: Text('"$searchQuery"', maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey
                                    ),),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          else if(snapShot.connectionState == ConnectionState.waiting){
            return Padding(
              padding: const EdgeInsets.only(top: 15,left: 20),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child:
                              SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.grey,
                                  ),
                                ),
                                height: 15.0,
                                width: 15.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                child: Text("Searching for",style: TextStyle(
                                    color: Colors.grey
                                ),),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    width:orientation == Orientation.portrait ? 250 : 620,
                                    child: Text('"$searchQuery"', maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),),
                                  ),
                                ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          else{
            List<UserInformation> userInfo =[];
             snapShot.data.docs.forEach((doc){
              UserInformation user = UserInformation.fromDocument(doc);
              userInfo.add(user);
            });
            return ListView(
                children: userInfo.map((user) {
                  return  TextButton(
                    style:  TextButton.styleFrom(
                      primary: Colors.black54,
                    ),
                    onPressed: () => showProfile(context, profileId: user.id),
                    child: Container(
                        width: double.infinity,
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child:  Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                                  radius: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 13),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.username,textAlign: TextAlign.start,style: TextStyle(
                                        color: Colors.black
                                      ),),
                                      Text(user.displayName, style: TextStyle(
                                          color: Colors.grey,
                                      ),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ),

                    ),
                  );
                }
                ).toList(),
            );
          }
        }
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSearchField(),
      body: searchResultFuture == null || searchQuery == "" ? buildNoContent() : buildSearchResult(),
    );
  }
  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          profileID: profileId,
        ),
      ),
    );
  }
}

