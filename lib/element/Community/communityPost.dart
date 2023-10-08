import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class communityPost extends StatefulWidget {
  final String userName;
  final String category;
  final String content;
  final int like;
  final String userPhotoURL;
  final String userID;
  final DateTime showTime;
  final String group;
  final int comment;
  final String imageLink;

  const communityPost(
      {super.key,
      required this.userName,
      required this.category,
      required this.content,
      required this.like,
      required this.userPhotoURL,
      required this.userID,
      required this.showTime,
      required this.group,
      required this.comment,
      required this.imageLink});

  @override
  State<communityPost> createState() => _communityPostState();
}

class _communityPostState extends State<communityPost> {
  @override
  String userName = "Anonymous";
  String category = '';
  String content = '';
  String userPhotoURL = '';
  String userID = '';
  DateTime showTime = DateTime.now();
  DateTime hiddenTime = DateTime.now();
  String group = '';
  int comment = 0;
  int like = 0;
  String imageLink = '';
  List imageLinkList = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = widget.userName;
    category = widget.category;
    content = widget.content;
    like = widget.like;
    userPhotoURL = widget.userPhotoURL;
    userID = widget.userID;
    showTime = widget.showTime;
    group = widget.group;
    comment = widget.comment;
    imageLink = widget.imageLink;

    if (imageLink.trim() != null) {
      imageLinkList =
          imageLink.split(',').where((element) => element.isNotEmpty).toList();
      print(imageLinkList.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                          child: ClipOval(child: Image.network(userPhotoURL,
               fit: BoxFit.cover,width: MediaQuery.of(context).size.width*0.1,)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: 
                                      Text(
                                        userName,
                                        style: TextStyle(
                                          
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.04,
                                          fontWeight: FontWeight.w500,
                                        ),
                                       
                                      ),
                                   
                                ),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width*0.28,
                                // ),
                               
                              
                            Text(category),
                            Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.width * 0,
                      MediaQuery.of(context).size.width * 0.0,
                      MediaQuery.of(context).size.width * 0.0),
                  child: Container(
                                           width: MediaQuery.of(context).size.width*0.6,
                    child: Text(content)),
                ),
                 imageLink != ''
                    ? Row(
                          children: imageLinkList.isNotEmpty
                              ? imageLink
                                  .split(',')
                                  .where((element) => element.isNotEmpty)
                                  .toList()
                                  .map(
                                    (e) => Image.network(
                                      e,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                                  )
                                  .toList()
                              : [],
                        )
                      
                    : SizedBox(),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(DateFormat('dd MMM yyyy HH:mm a   ')
                                          .format(showTime)),
                         ),

                         
                         Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                  child: Container(
                   
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_rounded,
                            color: Colors.grey,
                            size: MediaQuery.of(context).size.width * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                MediaQuery.of(context).size.width * 0.01,
                                0,
                                0,
                                0),
                            child: Text(
                              like.toString(),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),

                          GestureDetector(
                            onTap: (){
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => commentPage,))
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Colors.grey,
                                  size: MediaQuery.of(context).size.width * 0.04,
                                ),
                                Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  MediaQuery.of(context).size.width * 0.01,
                                  00,
                                  0,
                                  0),
                              child: Text(
                                comment.toString(),
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ),
                              ],
                            ),
                          ),
                          
                          // Icon(
                          //   Icons.bookmark_border_rounded,
                          //   color:Colors.grey,
                          //   size: MediaQuery.of(context).size.width*0.04,

                          // ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       0, 4, 0, 0),
                          //   child: Text(
                          //     'Save',

                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                       ],
                     )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
               
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
