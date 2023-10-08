//import 'dart:html';

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fireguard_pro/element/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:fireguard_pro/element/Community/community.dart';

class sendPost extends StatefulWidget {
  const sendPost({super.key});

  @override
  State<sendPost> createState() => _sendPostState();
}

TextEditingController controller = TextEditingController();
List<File> selectedImage = [];
File? selectedVideo;
String link = '';
Random random = Random();
final User? user = FirebaseAuth.instance.currentUser;
DatabaseReference db = FirebaseDatabase.instance.ref();
String username = '' ;
String userPhotoURL = '';
class _sendPostState extends State<sendPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     username = user!.displayName.toString();
    userPhotoURL = user!.photoURL.toString();
     controller.text = '';
    selectedImage = [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xFF1C1959),
        automaticallyImplyLeading: true,
        title: Text('Add Post'),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                  onPressed: () async {
                    if (selectedImage != null && controller.text !=null) {
                      String imageLink = '';
                      final ref =
                          FirebaseStorage.instance.ref().child("files/");
                      for (var i = 0; i < selectedImage.length; i++) {
                      
                      //upload to firebase storage
                        final storageReference = FirebaseStorage.instance
                              .ref()
                              .child(
                                  "files/${"user"}/${path.basename(selectedImage[i].toString())}");
                         final uploadTask= storageReference.putFile(selectedImage[i]);

                                  final snapshot = await uploadTask.whenComplete(() {});
                      final downloadURL = await uploadTask.whenComplete(() => {}).then((value) => storageReference.getDownloadURL());
                      imageLink+="$downloadURL,";
                      print(downloadURL);
                      }

                      Future.delayed(Duration(seconds: 7)).then((value) {
  DateTime now = DateTime.now();
                String hiddenTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                String showTime = DateFormat('MM.dd HH:mm').format(now);
                   int randomNum = random.nextInt(8999) + 1000;
                   String? userID = user?.uid;
                   String? userPhotoURL = user?.photoURL;
                   String? username = user?.displayName;
                   db.child("post/$randomNum").set({
                    "category":"User",
                    "comment": 0,
                    "content":controller.text.toString(),
                    "group":"recent",
                    "like":0,
                    "showTime": DateTime.now().toString(),
                    "username":username,
                    "userID": userID,
                    "userPhotoURL":userPhotoURL,
                    "imageLink":imageLink
                   });
                      }).then((value) => reset());
                    }
                      
                       if(controller.text.trim()!=''&& selectedImage == null){
                         DateTime now = DateTime.now();
                String hiddenTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                String showTime = DateFormat('MM.dd HH:mm').format(now);
                   int randomNum = random.nextInt(8999) + 1000;
                   String? userID = user?.uid;
                   String? userPhotoURL = user?.photoURL;
                   String? username = user?.displayName;
                   db.child("post/$randomNum").set({
                    "category":"User",
                    "comment": 0,
                    "content":controller.text.toString(),
                    "group":"recent",
                    "like":0,
                    "showTime": DateTime.now().toString(),
                    "username":username,
                    "userID": userID,
                    "userPhotoURL":userPhotoURL,
                    "imageLink": ''
                   }).then((value) => reset());
                       }
                  },
                  child: Text("POST",
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                      )),
                ),
          ),
            

        ],
        centerTitle: false,
        elevation: 2,
      ),
        body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                   userPhotoURL,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      MediaQuery.of(context).size.width * 0.02, 0, 0, 0),
                  child: Text(
                    username,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.00, -0.20),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
              child: Container(
                width: double.infinity,
                height: 189,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 218, 218, 218)),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        MediaQuery.of(context).size.width * 0.03, 0, 0, 0),
                    child: TextField(
                      maxLines: 30,
                      controller: controller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: "What's on your mind ?",
                          hintStyle: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Color(0x8E14181B),
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: selectedImage != null ? true : false,
                        child: selectedImage != null
                            ? Row(
                                children: selectedImage.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.file(
                                      item,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }).toList(),
                              )
                            : SizedBox()),
                  ],
                ),
              ),
            ),
          ),
          Text(link),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
              alignment: AlignmentDirectional(0.00, 0.99),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    postFunction("Location", Icons.location_pin),
                    postFunction("Photo", Icons.image_outlined),
                    postFunction("Video", Icons.video_collection),
                    postFunction("Camera", Icons.camera_alt_outlined)
                  ],
                ),
              ),
            ),
          ),
        ])));
  }

  GestureDetector postFunction(String text, IconData icon) {
    return GestureDetector(
      onTap: () async {
        if (text == "Location") {
          Position? position = await determinePosition();
          // String address = GetAddressFromLocation(position).toString();
          List<Placemark> address = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          Placemark place = address[0];
          String finalAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
          controller.text += "#${finalAddress}";
        } else if (text == "Video") {
          print("object");
          //  final returnedVideo =  await ImagePicker().pickImage(source: ImageSource.camera);
          //  if(returnedVideo != null){
          //          selectedVideo = File(returnedVideo.path);
          //  }
          final returnedImage =
              await ImagePicker().pickVideo(source: ImageSource.gallery);
          if (returnedImage != null) {
            setState(() {
              selectedImage.add(File(returnedImage.path));
            });
          }
        } else if (text == "Camera") {
          print("object");
          //  final returnedVideo =  await ImagePicker().pickImage(source: ImageSource.camera);
          //  if(returnedVideo != null){
          //          selectedVideo = File(returnedVideo.path);
          //  }
          final returnedImage =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (returnedImage != null) {
            setState(() {
              selectedImage.add(File(returnedImage.path));
            });
          }
        } else if (text == "Photo") {
          final returnedImage =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (returnedImage != null) {
            setState(() {
              selectedImage.add(File(returnedImage.path));
            });
          }
        }
      },
      child: Row(children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 81, 80, 80),
          size: 40,
        ),
        Text(text,
            style: TextStyle(
              fontFamily: 'Readex Pro',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )),
      ]),
    );
  }
    reset(){
    Navigator.pop(context);
    controller.text = '';
    selectedImage = [];
   updatepPostList();
   updateFeaturedList();
  }
  
}
