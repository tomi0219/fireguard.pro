import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fireguard_pro/element/Report/report.dart';
import 'package:fireguard_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:collection';
import 'package:url_launcher/url_launcher.dart';


class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}
DatabaseReference ref  = FirebaseDatabase.instance.ref();
TextEditingController  controller = TextEditingController();
String searchContent= '';
class _reportPageState extends State<reportPage> {

  @override
  void initState() {
    // TODO: implement initState
    controller.text = '';
    searchContent = '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
         backgroundColor: Color(0xFF1C1959),
        automaticallyImplyLeading: false,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('History',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.06,
              color: Colors.transparent,
              child: TextField(
                  // controller: _model.textController1,
                  onChanged: (value) {
                    setState(() {
                      searchContent = controller.text.toLowerCase();
                    });
                  },
                  controller:  controller,
                  style: TextStyle( fontFamily: 'Readex Pro',
      fontWeight: FontWeight.bold,
      color: Colors.white),
                  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    prefixIcon: Icon(
      Icons.search,
      size: MediaQuery.of(context).size.width * 0.07,
      color: Colors.white,
    ),
    hintText: 'Search for any fire cases',
    hintStyle: TextStyle(
      fontFamily: 'Readex Pro',
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust the vertical padding as needed
                  ),
                  // style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
           
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
  onPressed: () async {
     Uri phoneNumber =Uri.parse("tel:999");

    

  await launchUrl(phoneNumber);
  debugPrint(phoneNumber.toString());

  },
  backgroundColor: Color(0xFFE80000),
  icon: Icon(
    Icons.call,
  ),
  elevation: 8,
  label: Text(
    'Emergency call',
    style: TextStyle(color: Colors.white),
  ),
),
backgroundColor: Color.fromARGB(255, 238, 238, 238)
,body: 
  
    Container(
      decoration: BoxDecoration(color: Colors.transparent),
      width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

      child: 
      FirebaseAnimatedList(
        reverse: controller.text==""? true :false,
        query: ref.child("report").orderByChild("showTime"),itemBuilder: (context, snapshot, animation, index) {
        // ReportList.add(report(username: snapshot.child("username").value.toString(), content: snapshot.child("content").value.toString(), userPhotoURL: snapshot.child("userPhotoURL").value.toString(), userID: snapshot.child("userID").value.toString(), showTime: DateTime.parse(snapshot.child("showTime").value.toString()), imageLink: snapshot.child("imageLink").value.toString(),lat: double.parse(snapshot.child("lat").value.toString()),
        // long: double.parse(snapshot.child("long").value.toString()),  location: snapshot.child("location").value.toString()));
        if(snapshot.child("location").value.toString().toLowerCase().contains(searchContent))
        {return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 
          MediaQuery.of(context).size.height*0.01, 0, 
           MediaQuery.of(context).size.height*0.01),
          child: ReportWidget(username: snapshot.child("username").value.toString(), content: snapshot.child("content").value.toString(), userPhotoURL: snapshot.child("userPhotoURL").value.toString(), userID: snapshot.child("userID").value.toString(), showTime: DateTime.parse(snapshot.child("showTime").value.toString()), imageLink: snapshot.child("imageLink").value.toString(),lat: double.parse(snapshot.child("lat").value.toString()),
          long: double.parse(snapshot.child("long").value.toString()),  location: snapshot.child("location").value.toString()),
        );}
        else{
          return SizedBox();
        }
      },)
    ),
   
   
);

    
  }
}
