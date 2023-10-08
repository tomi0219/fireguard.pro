import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fireguard_pro/element/Community/community.dart';
import 'package:fireguard_pro/element/Location/location.dart';
import 'package:fireguard_pro/element/Report/report.dart';
import 'package:fireguard_pro/element/educational/educationalPage.dart';
import 'package:fireguard_pro/element/function.dart';
import 'package:fireguard_pro/element/post.dart';
import 'package:fireguard_pro/services/local_notification_service.dart';
import 'package:fireguard_pro/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'homeScreen.dart';
import 'element/Report/reportPage.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
final User? user = FirebaseAuth.instance.currentUser;
List<post> PostList = [];
List<post> FeaturedPost = [];
List<report> ReportList = [];
Position? position;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
double aqi = 0;
double temperature = 0;
void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  LocalNotificationService();
  await FlutterBackgroundService.initialize(onStart);
  LocalNotificationService().showNotification("sda", "asd", 122);

  await Firebase.initializeApp(
    name: "FireGuard Pro",
    options: FirebaseOptions(
        apiKey: "AIzaSyB0izCiywb0oW9x3F8GrgxDoY7-dFgX69Y",
        authDomain: "fireguardpro-ba880.firebaseapp.com",
        databaseURL:
            "https://fireguardpro-ba880-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "fireguardpro-ba880",
        storageBucket: "fireguardpro-ba880.appspot.com",
        messagingSenderId: "1047895517233",
        appId: "1:1047895517233:web:ee6ae568a5e310c8d90d10",
        measurementId: "G-YLPT7H2LZ6"),
  );

  updatepPostList();
  updateFeaturedList();
  updateFireLocationList();
}

Future<void> onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);

  Timer.periodic(Duration(seconds: 30), (timer) async {
    double distance = 0;
    for (var i = 0; i < fireLocationList.length; i++) {
      distance = calculateDistance(
          location(lat: position!.latitude, long: position!.longitude),
          location(
              lat: fireLocationList[i].lat, long: fireLocationList[i].long));
      if (distance <= 20) {
        LocalNotificationService().showNotification(
            "Please avoid this area !", "Fire Breakout at Surrounding !", 1);
      }
    }
  });
}

Future<void> fetchData() async {
  position = await determinePosition();
  final response = await http.get(Uri.parse(
      'https://api.waqi.info//feed/geo:${position!.latitude};${position!.longitude}/?token=bc8bb42aa5c9bfc8c16013c4fe19b2c0a7f2d4b0'));

  if (response.statusCode == 200) {
    // Successfully fetched data
    final jsonData = json.decode(response.body);
    // print(jsonData['data']['aqi']);
    aqi = double.parse(jsonData['data']['aqi'].toString());
    temperature = double.parse(jsonData['data']['iaqi']['t']['v'].toString());
    //print(jsonData['data']['iaqi']['t']['v']);
    // Process and use the jsonData here
  } else {
    // Handle errors, e.g., show an error message to the user
    print('Failed to fetch data. Status code: ${response.statusCode}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const splashScreen(),
    );
  }
}

int currentIndex = 0;
List<Widget> screen = [
  const homeScreen(),
  const reportPage(),
  const CommunityWidget(),
  EducationPage()
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(

      //   title: Text("FireGuard Pro"),
      // ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // An error occurred while fetching data, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return screen[currentIndex];
          }
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set the background color here
        selectedItemColor: Color(0xFF1C1959),
        unselectedItemColor: Colors.grey,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Community"),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_sharp), label: "Info"),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
