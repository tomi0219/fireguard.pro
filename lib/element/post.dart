import 'package:flutter/material.dart';

class post {
   
   

     String username;
   String category;
   String content;
   int like;
   String userPhotoURL;
   String userID;
   DateTime showTime;
   String group;
   int comment;
   String imageLink;
   post({
    required this.username,
    required this.category,
    required this.group,
    required this.content,
    required this.like,
    required this.comment,
    required this.showTime,
    required this.userPhotoURL,
    required this.userID,
    required this.imageLink
   });

}
