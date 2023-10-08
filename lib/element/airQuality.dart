import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class airQuality extends StatefulWidget {
  final String text;
  final double data;
  
  const airQuality({super.key, required this.text, required this.data});

  @override
  State<airQuality> createState() => _airQualityState();
}

class _airQualityState extends State<airQuality> {
  String text = '';
  double data = 4 ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = widget.text;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.47,
        height: MediaQuery.of(context).size.height*0.15,
        decoration: BoxDecoration(
          color: 
          text=="AIR QUALITY"?
          data>100
          ?Colors.red
          :Color(0xFFFFEE00)
          :data>40
          ?Colors.red
          :Color.fromARGB(255, 132, 191, 240),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
           EdgeInsetsDirectional.fromSTEB(
            MediaQuery.of(context).size.width*0.05, 
            MediaQuery.of(context).size.width*0.00, 
            MediaQuery.of(context).size.width*0.05, 
            MediaQuery.of(context).size.width*0.00),
            
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width*0.04,
                  fontWeight: FontWeight.w600
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  text == "AIR QUALITY"?
                  Icon(Icons.air_sharp, color: Color.fromARGB(255, 81, 81, 81), size: MediaQuery.of(context).size.width*0.13,)
                  : Icon(Icons.thermostat, color: Color.fromARGB(255, 81, 81, 81),size: MediaQuery.of(context).size.width*0.13),
                  
                  Text(
                    text == "AIR QUALITY" ?
                    data.toString()
                    : "${data}°C",
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: MediaQuery.of(context).size.width*0.075,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
