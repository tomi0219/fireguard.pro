import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fireguard_pro/element/Community/community.dart';
import 'package:fireguard_pro/element/Report/addReport.dart';
import 'package:fireguard_pro/element/educational/educationalPage.dart';
import 'package:fireguard_pro/element/fireReminder.dart';
import 'package:fireguard_pro/sendPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'element/function.dart';
import 'main.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
// final controller = WebViewController()
// // ..setJavaScriptMode(JavaScriptMode.disabled)
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
  
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   // ..loadRequest(Uri.parse('https://flutter.dev'));
//  ..loadRequest(Uri.parse('https://firms.modaps.eosdis.nasa.gov/map/#d:today;@115.5,-0.6,6.9z'))
//  ..runJavaScriptReturningResult("document.getElementsByTagName('header')[0].style.display = 'none';")
// ..runJavaScript("document.getElementsByTagName('header')[0].style.display = 'none';");

class _homeScreenState extends State<homeScreen> {
  late WebViewController controller;

 bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF1C1959),
        automaticallyImplyLeading: false,
        title: Text('FireGuard Pro'),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 5, 23, 38),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()  {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const addReport()));
          },
          backgroundColor: Color(0xFFFF5555),
          icon: Icon(
            Icons.local_fire_department_sharp,
          ),
          
          label: Text(
            'REPORT',
            style: TextStyle(fontFamily: 'Readex Pro',
                  color: Colors.white,)
                  
                ),
          ),
        
        body: 
          Stack(
            
            children: [
              
              WebView(
                onPageFinished: (url) {
                  controller.runJavascript("document.querySelector('#map').style.top='0';document.querySelector('header').style.display = 'none';document.querySelector('#lmvInfoBar').remove();document.querySelector('#leftNavBarMapResize').remove();document.querySelector('#leftNavBar').remove();document.querySelector('#bottomBar').style.bottom='9rem';");
                },
    javascriptMode: JavascriptMode.unrestricted,
    initialUrl: 'https://firms.modaps.eosdis.nasa.gov/map/#d:today;@115.5,-0.6,6.9z',
    onWebViewCreated: (controller) async {
        this.controller = controller;
         //controller.loadUrl('https://firms.modaps.eosdis.nasa.gov/map/#d:today;@115.5,-0.6,6.9z');
       
       
    },
),
              
              // Stack(children: [ 
              //   Positioned(
              //     top: 0,
              //     right: MediaQuery.of(context).size.width*0.01,
              //     child: ElevatedButton(
              //     onPressed: (){},
              //     child: Row(
              //                  children: [
              //     Icon(Icons.zoom_out_map),
              //      Text("VIEW FULL"),
              //                  ],
              //                ),),
              //   ),],),
              
                
                  //map
                 Positioned(
                  top: visible==true ? MediaQuery.of(context).size.height*0.0:MediaQuery.of(context).size.height*0.733,
                  bottom:visible == true?MediaQuery.of(context).size.height*0.0: MediaQuery.of(context).size.height*-0.7,
                  left: MediaQuery.of(context).size.width*0.015,
                   child: AnimatedContainer(
                    duration: Duration(microseconds: 300),
                   height: visible == false? 0 :375,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            visible = !visible;
                            print(visible);
                            
                          });
                        }, child: Text(visible==false?"Expand":"Hide")),
                        Visibility(
                          visible: visible,
                          child: fireReminder(visible:visible)),
                      ],
                    )),
                 ),
               
             
             

              
            ],
          ),
    );
  }
}