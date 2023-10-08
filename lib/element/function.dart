import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fireguard_pro/element/Location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../main.dart';
import 'post.dart';
 
Future<Position> determinePosition() async{
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
} 

Future<String> GetAddressFromLocation(Position position) async {
 // print(await placemarkFromCoordinates(position.latitude, position.longitude));
  List<Placemark> address = await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = address[0];
  String finalAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
  
   return "finalAddress";
   
}

updatepPostList(){
  DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref.child("post").onValue.listen((event) {
    PostList= [];
    
    for (int i  = 0; i < event.snapshot.children.length; i++){
     
     // print(event.snapshot.children.elementAt(0).toString());
    
  String username = event.snapshot.children.elementAt(i).child("username").value.toString() ;
     String category = event.snapshot.children.elementAt(i).child("category").value.toString() ;
     String group = event.snapshot.children.elementAt(i).child("group").value.toString() ;
     String content = event.snapshot.children.elementAt(i).child("content").value.toString() ;
     int like = int.parse(event.snapshot.children.elementAt(i).child("like").value.toString()) ;
     int comment = int.parse(event.snapshot.children.elementAt(i).child("comment").value.toString()) ;
     DateTime showTime = DateTime.parse(event.snapshot.children.elementAt(i).child("showTime").value.toString()) ;
     String userPhotoURL =  event.snapshot.children.elementAt(i).child("userPhotoURL").value.toString() ;
      String userID =  event.snapshot.children.elementAt(i).child("userID").value.toString() ;
      String imageLink = event.snapshot.children.elementAt(i).child("imageLink").value.toString() ;
    PostList.add(post(username: username, category: category, group: group, content: content, like: like, comment: comment,
    showTime: showTime,userID: userID, userPhotoURL: userPhotoURL ,imageLink: imageLink));
    //  print("object");
      print(PostList[0].comment.toString());}
   
   
   
    
}); }


updateFeaturedList(){
    DatabaseReference ref = FirebaseDatabase.instance.ref();
  ref.child("featured").onValue.listen((event) {
    FeaturedPost = [];
    
    for (int i  = 0; i < event.snapshot.children.length; i++){
      
     // print(event.snapshot.children.elementAt(0).toString());
 String username = event.snapshot.children.elementAt(i).child("username").value.toString() ;
     String category = event.snapshot.children.elementAt(i).child("category").value.toString() ;
     String group = event.snapshot.children.elementAt(i).child("group").value.toString() ;
     String content = event.snapshot.children.elementAt(i).child("content").value.toString() ;
     int like = int.parse(event.snapshot.children.elementAt(i).child("like").value.toString()) ;
     int comment = int.parse(event.snapshot.children.elementAt(i).child("comment").value.toString()) ;
     DateTime showTime = DateTime.parse(event.snapshot.children.elementAt(i).child("showTime").value.toString()) ;
     String userPhotoURL =  event.snapshot.children.elementAt(i).child("userPhotoURL").value.toString() ;
      String userID =  event.snapshot.children.elementAt(i).child("userID").value.toString() ;
      String imageLink = event.snapshot.children.elementAt(i).child("imageLink").value.toString() ;

    FeaturedPost.add(post(username: username, category: category, group: group, content: content, like: like, comment: comment,
    showTime: showTime,userID: userID, userPhotoURL: userPhotoURL ,imageLink:imageLink ));
    //  print("object");
      }
});
}

updateAllPostList(){
  updatepPostList();
  updateFeaturedList();
}

updateFireLocationList(){
    DatabaseReference ref = FirebaseDatabase.instance.ref();
  ref.child("report").onValue.listen((event) {
    fireLocationList = [];
    
    for (int i  = 0; i < event.snapshot.children.length; i++){
      
     // print(event.snapshot.children.elementAt(0).toString());
    
      double lat =  double.parse(event.snapshot.children.elementAt(i).child("lat").value.toString()) ;
      double long= double.parse(event.snapshot.children.elementAt(i).child("long").value.toString()) ;

   fireLocationList.add(location(lat: lat, long: long));
    //  print("object");
            print(fireLocationList.toList());
}
});
}

double calculateDistance(location start, location end) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers

  // Convert degrees to radians
  final double startLatRadians = degreesToRadians(start.lat);
  final double endLatRadians = degreesToRadians(end.lat);
  final double startLngRadians = degreesToRadians(start.long);
  final double endLngRadians = degreesToRadians(end.long);

  // Calculate the differences between coordinates
  final double latDiff = endLatRadians - startLatRadians;
  final double lngDiff = endLngRadians - startLngRadians;

  // Calculate the Haversine formula
  final double a = pow(sin(latDiff / 2), 2) +
      cos(startLatRadians) * cos(endLatRadians) * pow(sin(lngDiff / 2), 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c;
  return distance; // Distance in kilometers
}

// Helper function to convert degrees to radians
double degreesToRadians(double degrees) {
  return degrees * (pi / 180.0);
}


