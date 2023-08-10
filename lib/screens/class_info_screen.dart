import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';

class ClassInformationScreen extends StatelessWidget {
  final ClassInfoModel classInfo;

  const ClassInformationScreen({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    double contentMargin = 32;

    return Scaffold(
        appBar: AppBar(title: Text(classInfo.classType), toolbarHeight: TeMediaQuery.getPercentageHeight(context, 6)),
        body: Padding(
          padding: EdgeInsets.all(contentMargin),
          child: Column(
            children: [
              SizedBox(
                height: TeMediaQuery.getPercentageHeight(context, 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: TeAppColorPalette.green,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(""),
                            ),
                            SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  classInfo.classType,
                                  style: GoogleFonts.inter(
                                      color: TeAppColorPalette.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DoubleText(
                                type: "Dia/", title: DateFormat("d 'de' MMMM", 'es').format(classInfo.classDate)),
                            DoubleText(
                                type: "Duracion/",
                                title: classInfo.classDuration != 1 ? "${classInfo.classDuration} Horas" : "${classInfo.classDuration} Hora"),
                            DoubleText(
                                type: "Capacidad/",
                                title: "${classInfo.classLimitSpaces} Lugares"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Descripcion",
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      classInfo.classDesription,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                width: TeMediaQuery.getPercentageWidth(context, 100),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(
                    "RESERVAR",
                    style: GoogleFonts.inter(
                      color: TeAppColorPalette.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class DoubleText extends StatelessWidget {
  final String type;
  final String title;

  const DoubleText({super.key, required this.type, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  color: TeAppColorPalette.grey,
                  fontWeight: FontWeight.w500)),
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 22,
                  color: TeAppColorPalette.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
