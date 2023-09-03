import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';

import '../models/user_model.dart';
import 'auth/auth.dart';

// ignore: must_be_immutable
class ClassInformationScreen extends StatefulWidget {
  final ClassInfoModel classInfo;
  final bool reserving;

  const ClassInformationScreen(
      {super.key, required this.classInfo, required this.reserving});

  @override
  State<ClassInformationScreen> createState() => _ClassInformationScreenState();
}

class _ClassInformationScreenState extends State<ClassInformationScreen> {
  late UserModel _userInfo;

  final DocumentReference _userData = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth().getCurrentUserUID());

  @override
  void initState() {
    super.initState();

    _userInfo = UserModel(
      name: '',
      creditsAvailable: 0,
      profilePicture: '',
      reservedClasses: [],
    );

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDataSnapshot = await _userData.get();
      // ignore: avoid_print
      print("trying to get user data");

      if (userDataSnapshot.exists) {
        // ignore: avoid_print
        print("user data exists");
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

  bool canReserveClass() {
    return _userInfo.creditsAvailable > 0;
  }

  void reserveClass() {
    if (canReserveClass()) {
      setState(() {
        _userInfo.reservedClasses.add(widget.classInfo.documentID);
        _userInfo.creditsAvailable--;
      });
      _userData.update({
        'reservedClasses': _userInfo.reservedClasses,
        'creditsAvailable': _userInfo.creditsAvailable,
      });
    }
  }

  Future<String> getCoachImageUrl() async {
    final ref = FirebaseStorage.instance.ref(
      'coaches/${widget.classInfo.classCoach}.png',
    );
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    double contentMargin = 32;

    return Scaffold(
        appBar: AppBar(
            title: Text(widget.classInfo.classType),
            // toolbarHeight: TeMediaQuery.getPercentageHeight(context, 6)    
            ),
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
                      child: Column(
                        children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              child: Expanded(
                                  child: FutureBuilder<String>(
                                    future: getCoachImageUrl(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
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
                                  )),
                            ),
                          Container(
                              decoration: const BoxDecoration(
                        color: TeAppColorPalette.blackLight,
                      ),
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  widget.classInfo.classCoach,
                                  style: GoogleFonts.inter(
                                      color: TeAppColorPalette.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DoubleText(
                                type: "Dia/",
                                title: DateFormat("d 'de' MMMM", 'es')
                                    .format(widget.classInfo.classDate)),
                            DoubleText(
                                type: "Duracion/",
                                title: widget.classInfo.classDuration != 1
                                    ? "${widget.classInfo.classDuration} Horas"
                                    : "${widget.classInfo.classDuration} Hora"),
                            DoubleText(
                                type: "Capacidad/",
                                title:
                                    "${widget.classInfo.classLimitSpaces} Lugares"),
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
                      widget.classInfo.classDesription,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: widget.reserving,
                child: SizedBox(
                  height: 60,
                  width: TeMediaQuery.getPercentageWidth(context, 100),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _fetchUserData();
                      // ignore: unnecessary_null_comparison
                      if (_userInfo != null) {
                        reserveClass();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, true); // Pop the current screen
                      } else {
                        // ignore: avoid_print
                        print("Error fetching user data or user data is null.");
                      }
                    },
                    child: Text(
                      "RESERVAR",
                      style: GoogleFonts.inter(
                        color: TeAppColorPalette.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
