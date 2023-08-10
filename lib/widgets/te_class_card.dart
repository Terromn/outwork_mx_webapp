import 'package:flutter/material.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:outwork_web_app/screens/class_info_screen.dart';

class TeClassCard extends StatelessWidget {
  final ClassInfoModel classInfo;
  final bool light;

   const TeClassCard({super.key, required this.classInfo, required this.light});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassInformationScreen(
                    classInfo: classInfo,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: light
              ? TeAppColorPalette.blackLight
              : TeAppColorPalette.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: _SquaredLeadingIcon(),
          title: Text(classInfo.classType),
          subtitle: Text("${DateFormat('h:mm a').format(classInfo.classDate)} - ${classInfo.classCoach}"),
        ),
      ),
    );
  }
}

class _SquaredLeadingIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            color: TeAppColorPalette.grey,
            height: 48,
            width: 48,
          ),
        ),
        Positioned(
          bottom: -1,
          right: -1,
          child: Container(
            width: 18.0,
            height: 18.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                  topRight: Radius.circular(200),
                  topLeft: Radius.circular(0)),
              color: TeAppColorPalette.green,
            ),
          ),
        ),
      ],
    );
  }
}
