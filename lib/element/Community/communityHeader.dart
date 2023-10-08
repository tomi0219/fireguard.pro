import 'package:fireguard_pro/element/Community/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class communityHeader extends StatefulWidget {
  final String userImageURL;
  const communityHeader({super.key,required this.userImageURL});

  @override
  State<communityHeader> createState() => _communityHeaderState();
}
String userImageURL = '' ;
class _communityHeaderState extends State<communityHeader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userImageURL = widget.userImageURL;
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
         SizedBox(
                      height: 240,
                      child: Stack(
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1510772314292-9c0ad420734a?w=1280&h=720',
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.00, 1.00),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      userPhotoURL,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fire Management Community',
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05,fontWeight: FontWeight.bold),
                           
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
                            child: Text(
                              'Find Your Valuable Information Here!',
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.038,fontWeight: FontWeight.w400),
                             
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                          //   child: ElevatedButton(
                          //     child: Text("Join Now"),
                          //     onPressed: () {
                          //       print('Button pressed ...');
                          //     },
                          //     ),
                          //   ),
                         
                        ],
                      ),
                    ),
      ],
    );
  }
}