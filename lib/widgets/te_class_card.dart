import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:outwork_web_app/screens/class_info_screen.dart';

class TeClassCard extends StatelessWidget {
  final ClassInfoModel classInfo;
  final bool light;
  final bool reserving;

  const TeClassCard(
      {super.key,
      required this.classInfo,
      required this.light,
      required this.reserving});

  Future<String> getCoachImageUrl() async {
    final ref = FirebaseStorage.instance.ref(
      'coaches/${classInfo.classCoach}.png',
    );
    return await ref.getDownloadURL();
  }

  FaIcon getIcon(String classType) {
    if (classType == "Calistenia") {
      return const FaIcon(FontAwesomeIcons.bolt, color: TeAppColorPalette.black, size: 8,);
    } else if (classType == "HIIT") {
      return const FaIcon(FontAwesomeIcons.stopwatch, color: TeAppColorPalette.black, size: 8);
    } else if (classType == "Kettle Flow") {
      return  const FaIcon(FontAwesomeIcons.wind, color: TeAppColorPalette.black, size: 8);
    } else if (classType == "Yoga") {
      return const FaIcon(FontAwesomeIcons.streetView, color: TeAppColorPalette.black, size: 8);
    }
    
    else {
      return const FaIcon(FontAwesomeIcons.question, color: TeAppColorPalette.black, size: 8);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassInformationScreen(
                    classInfo: classInfo,
                    reserving: reserving,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: light ? TeAppColorPalette.blackLight : TeAppColorPalette.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  color: TeAppColorPalette.black,
                  height: 48,
                  width: 48,
                  child: FutureBuilder<String>(
                    future: getCoachImageUrl(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final imageUrl = snapshot.data;

                      return Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18.0,
                  height: 18.0,
                  decoration:  const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200),
                        topRight: Radius.circular(200),
                        topLeft: Radius.circular(0)),
                    color: TeAppColorPalette.green,
                  ),
                  child: Center(child: getIcon(classInfo.classType)),
                ),
              ),
            ],
          ),
          title: Text(classInfo.classType),
          subtitle: Text(
              "${DateFormat('h:mm a').format(classInfo.classDate)} - ${classInfo.classCoach}"),
        ),
      ),
    );
  }
}
