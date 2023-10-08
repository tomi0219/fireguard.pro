
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fireguard_pro/element/Community/communityHeader.dart';
import 'package:fireguard_pro/element/Community/communityPost.dart';
import 'package:fireguard_pro/element/function.dart';
import 'package:fireguard_pro/main.dart';
import 'package:fireguard_pro/sendPost.dart';
import 'package:flutter/material.dart';

final User? user = FirebaseAuth.instance.currentUser;
class CommunityWidget extends StatefulWidget {
  const CommunityWidget({Key? key}) : super(key: key);

  @override
  _CommunityWidgetState createState() => _CommunityWidgetState();
}

String userPhotoURL = '';

class _CommunityWidgetState extends State<CommunityWidget> {
  

  

  @override
  void initState() {
    super.initState();
    userPhotoURL = user!.photoURL.toString();
    PostList.sort((a, b) {
  // Parse the 'time' values to DateTime objects

  DateTime dateTimeA = DateTime.parse(a.showTime.toString());
  DateTime dateTimeB = DateTime.parse(b.showTime.toString());
  // Compare the DateTime objects
  return dateTimeB.compareTo(dateTimeA);
});
  
  }

  @override
  void dispose() {
   

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    
                   Scaffold(
                    backgroundColor: Color.fromARGB(255, 238, 238, 238),

                     body: RefreshIndicator(
                      onRefresh: ()async{
                        setState(() {
  updateAllPostList();
});
                      },
                       child: SingleChildScrollView(
                         child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                             AppBar(
                             backgroundColor: Color(0xFF1C1959),
                             automaticallyImplyLeading: false,
                             title: Text('Community'),
                             actions: [],
                             centerTitle: false,
                           ),
                          communityHeader(userImageURL: userPhotoURL,),
                     
                            FeaturedPost.length!=0? 
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                              child: Text(
                                'Featured Posts',
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,fontWeight: FontWeight.w500),
                                    ),
                              )
                              : SizedBox(),
                     
                             Column(children: FeaturedPost.map((item) {
                                     return communityPost(userName: item.username, category: item.category, content:  item.content, like: item.like,
                                     comment: item.comment, group: item.group,showTime: item.showTime
                                     ,userID: item.userID ,userPhotoURL: item.userPhotoURL, imageLink: item.imageLink,);
                                   }).toList(),),
                          
                            PostList.length != 0 ?
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                              child: Text(
                                'Recent Posts',
                             style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,fontWeight: FontWeight.w500),
                              ),
                            )
                            : SizedBox(),
                           //                 Expanded(child: 
                          
                           //                 FirebaseAnimatedList(
                           //   query: ref.child("post"),
                           //   itemBuilder: (BuildContext context, DataSnapshot snapshot,
                           //       Animation<double> animation, int index) {
                           //     // Replace with your list item widget
                           //     return communityPost(userName: "userName", category: "category", content: "content", like: 22);
                           //   },
                           // )
                           // ),
                           Column(children: PostList.map((item) {
                     return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 
          MediaQuery.of(context).size.height*0.01, 0, 
           MediaQuery.of(context).size.height*0.01),
                       child:   communityPost(userName: item.username, category: item.category, content:  item.content, like: item.like,
                       
                                       comment: item.comment, group: item.group,showTime: item.showTime
                       
                                       ,userID: item.userID ,userPhotoURL: item.userPhotoURL,imageLink: item.imageLink,),
                     );              }).toList(),),
                          // ListView.builder( itemCount: PostList.length, itemBuilder: (BuildContext context, index) {
                          //   return communityPost(userName: PostList[index].username, 
                          //   category: PostList[index].category, 
                          //   content: PostList[index].content,
                          //    like: PostList[index].like);
                          // })
                                      ]),
                       ),
                     ),
                     floatingActionButton: FloatingActionButton(onPressed: (){
                      Navigator.push(context ,MaterialPageRoute(builder: (context) =>  sendPost()));
                     },
                     child: Icon(Icons.add)),
                   );
                
             
             
            
         
}
}

