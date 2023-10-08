//import 'dart:html';

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fireguard_pro/element/Report/reportPage.dart';
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

class addReport extends StatefulWidget {
  const addReport({super.key});

  @override
  State<addReport> createState() => _addReportState();
}

TextEditingController controller = TextEditingController();
List<File> selectedImage = [];
File? selectedVideo;
String link = '';
Random random = Random();
final User? user = FirebaseAuth.instance.currentUser;
String username = '' ;
String userPhotoURL = '';
DatabaseReference db = FirebaseDatabase.instance.ref();
class _addReportState extends State<addReport> {
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
    bool loading = false;
    return Scaffold(
         appBar: AppBar(
        backgroundColor: Color(0xFF1C1959),
        automaticallyImplyLeading: true,
        title: Text('Submit Report'),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                    onPressed: () async {
                      if (selectedImage != [] && controller.text.trim() !='') {
                        setState(() {
  loading = true;
});
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

                      final downloadURL = await uploadTask.whenComplete(() => {}).then((value) => storageReference.getDownloadURL());
                      imageLink+="$downloadURL,";
                      print(downloadURL);
          //                  try {
          //                   //get downloadurl
                            
          //                     String downloadURL =
          //                         await storageReference.getDownloadURL();
                                 
          //                     print(downloadURL);
          //  imageLink+= "$downloadURL,";
          //                     // setting up post to be uploaded to firebase
                             
          
          
                           
          //                 } catch (e) {
          //                   print('Error retrieving image URL: $e');
          //                   return null;
          //                 }
                         }
                      
          
                        Future.delayed(Duration(seconds: 7)).then((value) async {
            DateTime now = DateTime.now();
                  String hiddenTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  String showTime = DateFormat('MM.dd HH:mm').format(now);
                     int randomNum = random.nextInt(8999) + 1000;
                      Position position = await determinePosition();
                     List<Placemark> address = await placemarkFromCoordinates(
                position.latitude, position.longitude);
            Placemark place = address[0];
            String location = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
                     String? userID = user?.uid;
                     String? userPhotoURL = user?.photoURL;
                     String? username = user?.displayName;
                    
                     db.child("report/$randomNum").set({
                      "content":controller.text.toString(),
                      "showTime": DateTime.now().toString(),
                      "username":username,
                      "userID": userID,
                      "userPhotoURL":userPhotoURL,
                      "imageLink":imageLink,
                      "lat" : position.latitude.toString() ,
                      "long": position.longitude.toString(),
                      "location": location.toString()
                     });
                        }).then((value) {
                          setState(() {
  setState(() {
  loading = false;
});
});
                          reset();
                        } );
                 
                      }else
                        
                         if(controller.text.trim()!=''&& selectedImage == []){
                          setState(() {
  loading = true;
});
                            DateTime now = DateTime.now();
                  String hiddenTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  String showTime = DateFormat('MM.dd HH:mm').format(now);
                     int randomNum = random.nextInt(8999) + 1000;
                      Position position = await determinePosition();
                     List<Placemark> address = await placemarkFromCoordinates(
                position.latitude, position.longitude);
            Placemark place = address[0];
            String location = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
                     String? userID = user?.uid;
                     String? userPhotoURL = user?.photoURL;
                     String? username = user?.displayName;
                     db.child("report/$randomNum").set({
                      "content":controller.text.toString(),
                      "showTime": DateTime.now().toString(),
                      "username":username,
                      "userID": userID,
                      "userPhotoURL":userPhotoURL,
                      "imageLink":'',
                     "lat" : position.latitude.toString() ,
                      "long": position.longitude.toString(),
                      "location": location.toString()
                     }).then((value) {
                      setState(() {
  loading = false;
});
                      reset();
                     });
                 
                         }
                         else{
                          
                         }
                    },
                    child: Text("REPORT",
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
                          hintText: "Please describe the situation (As specific as possible)",
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
          Visibility(child: CircularProgressIndicator(),

          visible: loading,)
        ])));
        
  }
  getCurrentLocation() async {
     Position? position = await determinePosition();
          // String address = GetAddressFromLocation(position).toString();
          List<Placemark> address = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          Placemark place = address[0];
          return
           
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
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
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} (Lat:${position.latitude}, Long:${position.longitude})";
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

  }
  
}
