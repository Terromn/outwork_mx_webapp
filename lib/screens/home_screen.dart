import 'dart:math';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outwork_web_app/assets/app_theme.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
import 'package:outwork_web_app/screens/auth/auth.dart';
import 'package:outwork_web_app/screens/available_classes_screen.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';
import 'package:outwork_web_app/utils/qr_code_generator.dart';
import 'package:outwork_web_app/widgets/te_class_card.dart';

import '../assets/app_color_palette.dart';
import '../models/user_model.dart';

final _confettiController =
      ConfettiController(duration: const Duration(seconds: 1));

void playConfetti() {
  _confettiController.play();
}

void stopConfetti() {
  _confettiController.stop();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  

  final _storage = FirebaseStorage.instance;
  // ignore: unused_field
  late Reference _storageRef;

  // test
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

    FlutterNativeSplash.remove();
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
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching user data: $error');
    }
  }

  Widget _profilePicture(String profilePic, Reference reference) {
    return GestureDetector(
      onTap: () =>
          _showQrCode(context, _userInfo.name, Auth().getCurrentUserUID()),
      child: CircleAvatar(
        backgroundColor: TeAppColorPalette.black,
        backgroundImage:
            AssetImage('defaultProfilePictures/${_userInfo.profilePicture}'),
        radius: 38,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _storageRef = _storage.ref().child('/defaultProfilePictures');

    return Stack(
      children: [
        Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                            Text(
                              "Creditos Disponibles:  ${_userInfo.creditsAvailable.toString()}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            )
                          ],
                        ),
                        _profilePicture(_userInfo.profilePicture, _storageRef),
                      ]),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Column(
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
                                DateTime.now().add(const Duration(days: 8)),
                            // ignore: avoid_print
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            leftMargin: TeAppThemeData.contentMargin,
                            dayNameColor: TeAppColorPalette.black,
                            monthColor: TeAppColorPalette.white,
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
                              height: TeMediaQuery.getPercentageHeight(
                                  context, 42.5),
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
                                        (document['classTimeStamp']
                                                as Timestamp)
                                            .toDate();
                                    return classDate.year ==
                                            _selectedDate.year &&
                                        classDate.month ==
                                            _selectedDate.month &&
                                        classDate.day == _selectedDate.day;
                                  }).toList();

                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: filteredDocuments.length,
                                    itemBuilder: (context, index) {
                                      final documentData =
                                          filteredDocuments[index];

                                      // ignore: unused_local_variable
                                      String id = documents[index].id;
                                      // ignore: avoid_init_to_null, unused_local_variable
                                      NetworkImage? classCoachImage = null;
                                      String classCoach =
                                          documentData['classCoach'];
                                      String classDesription =
                                          documentData['classDescription'];
                                      double classDuration =
                                          documentData['classDuration'];
                                      int classLimitSpaces =
                                          documentData['classLimitSpaces'];
                                      String classType =
                                          documentData['classType'];
                                      int classCost = documentData['classCost'];

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
                                        classCost: classCost,
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
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: TeAppColorPalette.black,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _streamClasses,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Icon(FontAwesomeIcons.circleExclamation,
                                    size: 48),
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
                                double classDuration =
                                    documentData['classDuration'];
                                int classLimitSpaces =
                                    documentData['classLimitSpaces'];
                                String classType = documentData['classType'];
                                int classCost = documentData['classCost'];

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
                                  classCost: classCost,
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
                      );
                    },
                  )
                },
                child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: TeAppColorPalette.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TeAppColorPalette.green, // Shadow color
                        blurRadius: 18, // Spread radius of the shadow
                        offset: Offset(0,
                            4), // Offset of the shadow (horizontal, vertical)
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "RESERVACIONES",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: TeAppColorPalette.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ConfettiWidget(
          
          confettiController: _confettiController,
          blastDirection: pi /2,
          colors: const [
            TeAppColorPalette.green,
            TeAppColorPalette.black,
          ],
          gravity: .01,
          emissionFrequency: 0.05,
          
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void _showQrCode(BuildContext context, String userName, dynamic data) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          color: TeAppColorPalette.black,
          height: TeMediaQuery.getPercentageHeight(context, 75),
          width: TeMediaQuery.getPercentageWidth(context, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TeQRCodeGenerator(data: data),
              const SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  color: TeAppColorPalette.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: TeAppColorPalette.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ));
    },
  );
}
