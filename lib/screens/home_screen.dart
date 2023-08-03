import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outwork_web_app/assets/app_theme.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';
import 'package:outwork_web_app/widgets/te_class_card.dart';

import '../assets/app_color_palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _referenceClasses =
      FirebaseFirestore.instance.collection('classes');

  @override
  void initState() {
    super.initState();

    _streamClasses = _referenceClasses.snapshots();
  }

  late Stream<QuerySnapshot> _streamClasses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: TeAppColorPalette.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                TeAppThemeData.contentMargin,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buenos dias,',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                        Text(
                          'Username',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 32),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: TeAppColorPalette.green,
                    )
                  ]),
            ),
          ),
          const SizedBox(height: TeAppThemeData.contentMargin),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: TeMediaQuery.getPercentageHeight(context, 45),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TeAppThemeData.contentMargin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clases de este mes:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          ElevatedButton(
                              onPressed: null,
                              child: Text(
                                'VER',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: CalendarTimeline(
                        initialDate: DateTime(2020, 4, 20),
                        firstDate: DateTime(2019, 1, 15),
                        lastDate: DateTime(2020, 11, 20),
                        // ignore: avoid_print
                        onDateSelected: (date) => print(date),
                        leftMargin: TeAppThemeData.contentMargin,
                        dayNameColor: TeAppColorPalette.black,
                        monthColor: TeAppColorPalette.blackLight,
                        dayColor: TeAppColorPalette.white,
                        activeDayColor: TeAppColorPalette.black,
                        activeBackgroundDayColor: TeAppColorPalette.green,
                        dotsColor: TeAppColorPalette.black,
                        selectableDayPredicate: null,
                        locale: 'en_ISO',
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: TeAppThemeData.contentMargin,
                            right: TeAppThemeData.contentMargin),
                        child: SizedBox(
                          height: TeMediaQuery.getPercentageHeight(context, 25),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _streamClasses,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                      'Lo sentimos! No podemos cargar la informacion en este momento'),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                print("Fetching Data...");

                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final List<QueryDocumentSnapshot> documents =
                                  snapshot.data!.docs;
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  final documentData = documents[index];

                                  // ignore: unused_local_variable
                                  String id = documents[index].id;
                                  // ignore: avoid_init_to_null, unused_local_variable
                                  NetworkImage? classCoachImage = null;
                                  String classCoach =
                                      documentData['classCoach'];
                                  String classDesription =
                                      documentData['classDescription'];
                                  int classDuration =
                                      documentData['classDuration'];
                                  int classLimitSpaces =
                                      documentData['classLimitSpaces'];
                                  String classType = documentData['classType'];
                                  DateTime classDate =
                                      (documentData['classTimeStamp']
                                              as Timestamp)
                                          .toDate();

                                  ClassInfoModel classInfo = ClassInfoModel(
                                    classCoach: classCoach,
                                    classDesription: classDesription,
                                    classDuration: classDuration,
                                    classDate: classDate,
                                    classLimitSpaces: classLimitSpaces,
                                    classType: classType,
                                  );

                                  return TeClassCard(
                                    light: false,
                                    classInfo: classInfo,
                                  );
                                },
                              );
                            },
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: TeMediaQuery.getPercentageHeight(context, 65),
                decoration: const BoxDecoration(
                  color: TeAppColorPalette.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TeAppThemeData.contentMargin),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clases reservadas:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          ElevatedButton(
                              onPressed: null,
                              child: Text(
                                'VER',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: const [],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          )),
        ],
      ),
    );
  }
}