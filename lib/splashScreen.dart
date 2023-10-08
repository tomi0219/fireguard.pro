import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fireguard_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

 final User? user = FirebaseAuth.instance.currentUser;

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}
DatabaseReference db = FirebaseDatabase.instance.ref();
class _splashScreenState extends State<splashScreen> {
  bool seen =true;
  @override
  void initState() {
  
    super.initState();
    // Wait for 3 seconds and then show login page
    Future.delayed(const Duration(seconds: 2)).then((value) {
     if(user!=null){
       Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>MyHomePage(title: "",),
            ),
          );
     }else{
      setState(() {
         seen =false;
      });
     
     }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: 
 
  Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(colors: [Colors.black , Colors.grey],
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter
          // ),
         color: Colors.white
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             CircleAvatar(child: 
             Image.asset("images/img.png"),
             backgroundColor: Colors.orange[300],maxRadius: MediaQuery.of(context).size.width*0.35),
              SizedBox(height: MediaQuery.of(context).size.height*0.04),
             Text("FireGuard Pro"
             ,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.1,fontWeight: FontWeight.w700),),
                            SizedBox(height: MediaQuery.of(context).size.height*0.02),
            
              seen==true?
              Visibility(child: SpinKitPumpingHeart(
                color: Colors.red,
                size: MediaQuery.of(context).size.width*0.2,
                duration:Duration(seconds: 2) ,
               ),
               visible: seen,
               )
               :
                 Container(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width *0.056 ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    primary: Color.fromARGB(255, 75, 57, 239),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  ),
                  
                ),
                
              ),
            ],
          ),
          
        ),
      ),
);
  }

   Future<void> signInWithGoogle() async {
     final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
   db.child("name").set(user.user?.displayName);
   Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: "",)));
  }
}