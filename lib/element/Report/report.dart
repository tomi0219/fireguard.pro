import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class report {
   
   

     String username;
  
   String content;
   String userPhotoURL;
   String userID;
   DateTime showTime;
   String imageLink;
   double lat;
   double long;
   String location;
   report({
    required this.username,
    required this.content,
    required this.showTime,
    required this.userPhotoURL,
    required this.userID,
    required this.imageLink,
    required this.lat,
    required this.long,
    required this.location
   });

  
}


class ReportWidget extends StatefulWidget {
 final String username;
  
  final String content;
  final String userPhotoURL;
  final String userID;
  final DateTime showTime;
  final String imageLink;
  final String location;
  final double lat;
  final double long;
  const ReportWidget({super.key,required this.username,
required this.content,
required this.userPhotoURL,
required this.userID,
required this.showTime,
required this.imageLink,
  required this.long,
    required this.lat,
    required this.location});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  String userName = "Anonymous";
String content = '';
String userPhotoURL = '';
 String userID = '';
 DateTime showTime = DateTime.now();
String imageLink = '';
Position? position;
String location = '';
double lat = 0;
double long = 0;
List imageLinkList = [];
  void initState() {
    // TODO: implement initState
    super.initState();
     userName = widget.username;
    content = widget.content;
    userPhotoURL = widget.userPhotoURL;
userID = widget.userID;
showTime = widget.showTime;
    imageLink = widget.imageLink;
   lat = widget.lat;
   long = widget.long;
   location = widget.location;
    if(imageLink.trim() !=null){
      imageLinkList = imageLink.split(',').where((element) => element.isNotEmpty).toList();
      print(imageLinkList.toList());
    }

  }
  @override
  Widget build(BuildContext context) {
    return   Padding(
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
                                          fontWeight: FontWeight.w600,
                                        ),
                                       
                                      ),
                                   
                                ),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width*0.28,
                                // ),
                               
                              
                            GestureDetector(
                              onTap: (){
                                final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                                launchUrl(Uri.parse(url));

                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.6,
                                child: Text("$location ($lat, $long)",
                                 style: TextStyle(
                                            
                                            fontSize:
                                                MediaQuery.of(context).size.width *
                                                    0.035,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey
                                          ),)),
                            ),
                           
                  content.trim()!=''?Padding(
                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Container(
                       width: MediaQuery.of(context).size.width*0.6,
                      child: Text("\n$content")),
                  )
                    :SizedBox(),
                
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
                     Padding(
                       padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(DateFormat('dd MMM yyyy HH:mm a   ')
                                            .format(showTime),
                                             style: TextStyle(
                                            
                                          color: Colors.grey
                                          ),),
                                            
                           
                         ],
                       ),
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