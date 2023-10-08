import 'dart:async';
import 'dart:convert';

import 'package:fireguard_pro/element/airQuality.dart';
import 'package:fireguard_pro/element/educational/educationalPage.dart';
import 'package:fireguard_pro/element/tip.dart';
import 'package:fireguard_pro/main.dart';
import 'package:fireguard_pro/services/local_notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'Location/location.dart';
import 'function.dart';

class fireReminder extends StatefulWidget {
  final bool visible;
  const fireReminder({super.key, required this.visible});

  @override
  State<fireReminder> createState() => _fireReminderState();
}

double aqi = 0;
double temperature = 0;
Position? position;

class _fireReminderState extends State<fireReminder> {
  bool visible = false;
  late Timer timer;  
  String finalAddress = "Jalan Brother Albinus, 96000 Sibu";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visible = widget.visible;
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      position = await determinePosition();
      final response = await http.get(Uri.parse(
          'https://api.waqi.info//feed/geo:${position!.latitude};${position!.longitude}/?token=bc8bb42aa5c9bfc8c16013c4fe19b2c0a7f2d4b0'));

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        print("sda $visible");
        // print(jsonData['data']['aqi']);
        if (mounted) {
          setState(() {
             aqi = double.tryParse(jsonData['data']['aqi'].toString())!;
      temperature = double.tryParse(jsonData['data']['iaqi']['t']['v'].toString())!;
          });
        }
        print("$aqi , $temperature");
        ref
            .child("${user?.uid}/data")
            .set({"aqi": aqi, "temperature": temperature});
        //print(jsonData['data']['iaqi']['t']['v']);
        // Process and use the jsonData here
      } else {
        // Handle errors, e.g., show an error message to the user
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
      popFireNotification("local");

      double distance;
      
        for (var i = 0; i < fireLocationList.length; i++) {
    distance  = calculateDistance(location(lat: position!.latitude,long: position!.longitude), 
    location(lat: fireLocationList[i].lat,long: fireLocationList[i].long));
    if(distance <=20){
      List<Placemark> address = await placemarkFromCoordinates(fireLocationList[i].lat, fireLocationList[i].long);
  Placemark place = address[0];
  if(mounted){
      setState(() {
      finalAddress= "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
  });
  }

    print("distance $finalAddress");

     
    
         LocalNotificationService().showNotification("Please avoid this area !", "Fire Breakout at Surrounding !", 1);


    }
    
    
  }  
     
  
    });

    Timer.periodic(Duration(seconds: 5), (timer) {
      ref.child("update").get().then((value) {
        if (value.value.toString() == "true") {
          ref.child("aqi").get().then((value) {
            if (mounted) {
              setState(() {
                aqi = double.parse(value.value.toString());
              });

              print("$aqi , $temperature");
            }
          });

          ref.child("temperature").get().then((value) {
            if (mounted) {
              setState(() {
                temperature = double.parse(value.value.toString());
              });

              print("$aqi , $temperature");
            }
          });
          popFireNotification("firebase");
        } 
        
    });
      });

      
     
  }

  void dispose() {
    // Your cleanup code goes here
    // This method is called when the widget is removed from the widget tree.
    super.dispose();
    timer.cancel;
  }

  Future<void> fetchAQData() async {
    position = await determinePosition();
    final response = await http.get(Uri.parse(
        'https://api.waqi.info//feed/geo:${position!.latitude};${position!.longitude}/?token=bc8bb42aa5c9bfc8c16013c4fe19b2c0a7f2d4b0'));

    if (response.statusCode == 200) {
      // Successfully fetched data
      final jsonData = json.decode(response.body);
      // print(jsonData['data']['aqi']);
      aqi = double.tryParse(jsonData['data']['aqi'].toString())!;
      temperature = double.tryParse(jsonData['data']['iaqi']['t']['v'].toString())!;

      //print(jsonData['data']['iaqi']['t']['v']);
      // Process and use the jsonData here
    } else {
      // Handle errors, e.g., show an error message to the user
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }

   
  double distance;
  for (var i = 0; i < fireLocationList.length; i++) {
    distance  = calculateDistance(location(lat: position!.latitude,long: position!.longitude), 
    location(lat: fireLocationList[i].lat,long: fireLocationList[i].long));
    if(distance <=20){
      List<Placemark> address = await placemarkFromCoordinates(fireLocationList[i].lat, fireLocationList[i].long);
  Placemark place = address[0];
  setState(() {
      finalAddress= "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
  });
    print("distance $finalAddress");

    
         LocalNotificationService().showNotification("Please avoid this area !", "Fire Breakout at Surrounding !", 1);
    

    }
    
    
  }  
  }

  Future<void> hi() async {}

   popFireNotification(String source){
    String FireNotificationTitle = '';
    String FireNotificationContent = '';
     ref.child("FireNotificationTitle").get().then((value) {
      FireNotificationTitle = value.value.toString();
     });
     ref.child("FireNotificationContent").get().then((value) {
      FireNotificationContent = value.value.toString();
     });

    double currentAqi = 0;
    double currentTemperature = 0 ;
    print("$currentAqi , $currentTemperature");
    if(source == "local"){
      ref.child("${user?.uid}/data").get().then((value) {
         currentAqi =  double.parse(value.child("aqi").value.toString());
          currentTemperature=  double.parse(value.child("temperature").value.toString());
          if(currentAqi >= 280){
       LocalNotificationService().showNotification(FireNotificationTitle, FireNotificationContent, 1);
       print("1");
    }
 if(currentTemperature >= 40){
       LocalNotificationService().showNotification(FireNotificationTitle, FireNotificationContent, 1);
              print("2");

    }
      });
    
    
    }else if(source == "firebase"){
      ref.child("aqi").get().then((value) {
            if (mounted) {
              setState(() {
                currentAqi = double.parse(value.value.toString()); 
                if(currentAqi >= 280){
       LocalNotificationService().showNotification(FireNotificationTitle, FireNotificationContent, 1);
              print("3");

    }
              });

             
            }
          });
          ref.child("temperature").get().then((value) {
            if (mounted) {
              setState(() {
                currentTemperature = double.parse(value.value.toString()); 
                if(currentTemperature >= 40){
       LocalNotificationService().showNotification(FireNotificationTitle, FireNotificationContent, 1);
              print("4");

    }
              });

            }
          });
          
    
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: aqi==0?fetchAQData(): hi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still being fetched, show a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // An error occurred while fetching data, display an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  airQuality(text: "AIR QUALITY", data: aqi),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  airQuality(text: "TEMPERATURE", data: temperature)
                ]),
                Container(
                  height: MediaQuery.of(context).size.height * 0.01,
                  decoration: BoxDecoration(),
                ),
              ]),
              Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.width * 0.01),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(
                                    MediaQuery.of(context).size.width * 0.05,
                                    0.00),
                                child: Icon(
                                  Icons.wifi_tethering_error,
                                  color: Color(0xFFC50000),
                                  size:
                                      MediaQuery.of(context).size.width * 0.07,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text('FIRE BREAKOUT',
                                    style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        color: Color(0xFFC50000),
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              MediaQuery.of(context).size.width*0.0,
                              MediaQuery.of(context).size.width*0.0,
                              MediaQuery.of(context).size.width*0.0,
                              MediaQuery.of(context).size.width*0.01
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Text(
                                  finalAddress,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/The_front_gate_of_Sacred_Heart_secondary_school.jpg/220px-The_front_gate_of_Sacred_Heart_secondary_school.jpg',
                              width: double.infinity,
                              height: 139,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: Color(0xFFC50000),
                                  size:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                                Flexible(
                                  child: Padding(
                                     padding: EdgeInsetsDirectional.fromSTEB(
                                    MediaQuery.of(context).size.width*0.02, MediaQuery.of(context).size.width*0.01,
                                     0, MediaQuery.of(context).size.width*0.02),
                                    child: Text(
                                        'Reported fire at $finalAddress. Please avoid this area!',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Color(0xFFC50000),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: MediaQuery.of(context).size.height * 0.169,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          MediaQuery.of(context).size.width * 0.02, 0, 0, 0),
                      
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(1, 4, 0, 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Color(0xFFFF7C34),
                                    size:
                                        MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        MediaQuery.of(context).size.width * 0.01,
                                        0,
                                        0,
                                        0),
                                    child: Text('TIPS',
                                        style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Color(0xFFFF7C34),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                      FlutterWebBrowser.openWebPage(url: "https://www.youtube.com/watch?v=vGX7nNEUVTs", customTabsOptions: CustomTabsOptions(toolbarColor: Color(0xFF1C1959)));

                              },
                              child: Row(mainAxisSize: MainAxisSize.max, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://web.nepalnews.com/storage/story/1024/fire_2946038_12801650290551_1024.jpg',
                                    width:
                                        MediaQuery.of(context).size.width * 0.27,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.03,
                                ),
                                Flexible(
                                  child: Text('How to prevent fire breakouts?',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 18,
                                      )),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.open_in_new,
                                    color: Color(0xFF414141),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                              ]),
                            ),
                           GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EducationPage(),));
                             
                            },
                             child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text("View More",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,
                              color: Colors.blue),),
                              ]
                             ),
                           )
                          ])))
            ],
          );
        }
      },
    );
  }
}
