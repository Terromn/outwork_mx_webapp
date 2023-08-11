import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outwork_web_app/assets/app_theme.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
import 'package:outwork_web_app/screens/auth/auth.dart';
import 'package:outwork_web_app/screens/available_classes_screen.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';
import 'package:outwork_web_app/widgets/te_class_card.dart';

import '../assets/app_color_palette.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _userInfo;

  final CollectionReference _referenceClasses =
      FirebaseFirestore.instance.collection('classes');

  final DocumentReference _userData = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth().getCurrentUserUID());

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now().add(const Duration(days: 1));

    _streamClasses = _referenceClasses.snapshots();

    _userInfo = UserModel(
      name: '',
      creditsAvailable: 0,
      profilePicture: '',
      reservedClasses: [],
    );

    _fetchUserData();
  }

  late Stream<QuerySnapshot> _streamClasses;

  late DateTime _selectedDate;

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDataSnapshot = await _userData.get();

      if (userDataSnapshot.exists) {
        setState(() {
          _userInfo = UserModel(
            name: userDataSnapshot['name'],
            creditsAvailable: userDataSnapshot['creditsAvailable'],
            profilePicture: userDataSnapshot['profilePicture'],
            reservedClasses:
                List<String>.from(userDataSnapshot['reservedClasses']),
          );

          print(_userInfo.reservedClasses);
        });
      }
    } catch (error) {
      // Handle error if fetching user data fails
      // ignore: avoid_print
      print('Error fetching user data: $error');
    }
  }

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
                          _userInfo.name,
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
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 12),
              SizedBox(
                height: TeMediaQuery.getPercentageHeight(context, 65),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AvailableClassesScreen()),
                                );
                              },
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
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 4)),
                        // ignore: avoid_print
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
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
                          right: TeAppThemeData.contentMargin,
                        ),
                        child: SizedBox(
                          height:
                              TeMediaQuery.getPercentageHeight(context, 42.5),
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
                                return const Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                TeAppColorPalette.green)));
                              }

                              final List<QueryDocumentSnapshot> documents =
                                  snapshot.data!.docs;

                              final filteredDocuments =
                                  documents.where((document) {
                                DateTime classDate =
                                    (document['classTimeStamp'] as Timestamp)
                                        .toDate();
                                return classDate.year == _selectedDate.year &&
                                    classDate.month == _selectedDate.month &&
                                    classDate.day == _selectedDate.day;
                              }).toList();

                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: filteredDocuments.length,
                                itemBuilder: (context, index) {
                                  final documentData = filteredDocuments[index];

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
                                    documentID: id,
                                    classCoach: classCoach,
                                    classDesription: classDesription,
                                    classDuration: classDuration,
                                    classDate: classDate,
                                    classLimitSpaces: classLimitSpaces,
                                    classType: classType,
                                  );

                                  return TeClassCard(
                                    reserving: true,
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
                              return const Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          TeAppColorPalette.green)));
                            }

                            final List<QueryDocumentSnapshot> documents =
                                snapshot.data!.docs;

                            final filteredDocuments =
                                documents.where((document) {
                              String documentID = document.id;
                              return _userInfo.reservedClasses
                                  .contains(documentID);
                            }).toList();

                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: filteredDocuments.length,
                              itemBuilder: (context, index) {
                                final documentData = filteredDocuments[index];

                                // ignore: unused_local_variable
                                String id = documents[index].id;
                                // ignore: avoid_init_to_null, unused_local_variable
                                NetworkImage? classCoachImage = null;
                                String classCoach = documentData['classCoach'];
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
                                  documentID: id,
                                  classCoach: classCoach,
                                  classDesription: classDesription,
                                  classDuration: classDuration,
                                  classDate: classDate,
                                  classLimitSpaces: classLimitSpaces,
                                  classType: classType,
                                );

                                return TeClassCard(
                                  reserving: false,
                                  light: true,
                                  classInfo: classInfo,
                                );
                              },
                            );
                          },
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
