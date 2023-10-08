import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'EduContainer.dart';
import 'EduInfoBox.dart';

class EducationPage extends StatefulWidget {

  static Future<List<EduContainer>> getEduContent() async {
    const url = "https://educationfeed.chiengeugene.repl.co/edu.json";
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body.map<EduContainer>(EduContainer.fromJson).toList();
  }

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  Future<List<EduContainer>> eduContent = EducationPage.getEduContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1959),
        automaticallyImplyLeading: false,
        title: Text('Information centre'),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFFE6E6E6),
      body: Center(
        child: FutureBuilder<List<EduContainer>>(
          future: eduContent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final eduContainer = snapshot.data!;
              return buildEduInfoBox(eduContainer);
            } else {
              return const Text("No data");
            }
          },
        ),
      ),
    );
  }

  Widget buildEduInfoBox(List<EduContainer> eduContainer) => 
  RefreshIndicator(child: ListView.builder(
      itemCount: eduContainer.length,
      itemBuilder: (context, index) {
        final container = eduContainer[index];

        return EduInfoBox(
          title: container.title,
          desc: container.desc,
          src: container.src,
          provider: container.provider,
          providerURL: container.providerURL,
          thumbnailURL: container.thumbnailURL,
        );
      }), onRefresh: () async {
        setState(() {
          eduContent = EducationPage.getEduContent();
        });
      });
}