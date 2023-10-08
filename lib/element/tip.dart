import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class tip extends StatefulWidget {
  const tip({super.key});

  @override
  State<tip> createState() => _tipState();
}

class _tipState extends State<tip> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
           Image.network(
                'https://www1.wsrb.com/hubfs/images/blog/2020/Fire%20extinguisher%20maintenance%20and%20inspection/fire%20extinguisher%20maintenance%20and%20inspection.png',                
                scale: 0.1,
             
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                child: Text(
                  'How to prevent fire breakouts?',
                  style: TextStyle( fontFamily: 'Readex Pro',
                        fontSize: 11,)
                       
                    
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
              child: IconButton(
              
                icon: Icon(
                  Icons.open_in_new,
                  color: Color(0xFF414141),
                  size: 20,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
        
      
      ]));
  }
}