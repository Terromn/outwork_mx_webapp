import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork_web_app/assets/app_theme.dart';
import 'package:outwork_web_app/models/class_info_model.dart';
import 'package:outwork_web_app/utils/get_media_query.dart';

import '../assets/app_color_palette.dart';
import '../widgets/te_class_card.dart';

class AvailableClassesScreen extends StatefulWidget {
  const AvailableClassesScreen({super.key});

  @override
  State<AvailableClassesScreen> createState() => _AvailableClassesScreenState();
}

class _AvailableClassesScreenState extends State<AvailableClassesScreen> {
  final CollectionReference _referenceClasses =
      FirebaseFirestore.instance.collection('classes');

  @override
  void initState() {
    super.initState();
    _streamClasses = _referenceClasses.snapshots();
  }

  late Stream<QuerySnapshot> _streamClasses;

  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  String _selectedCoach = '';
  String _selectedClassType = '';
  int _selectedDuration = 1;

  Widget datePickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: (DateTime.now().subtract(const Duration(days: 730))),
            lastDate: (DateTime.now().add(const Duration(days: 730))),
          );
        },
        child: const SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.date_range_rounded, color: TeAppColorPalette.black),
                Text(
                  ' Fecha',
                  style: TextStyle(color: TeAppColorPalette.black),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget hourPickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now());
        },
        child: const SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.watch, color: TeAppColorPalette.black),
                Text(
                  ' Hora',
                  style: TextStyle(color: TeAppColorPalette.black),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget typePickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {},
        child: const SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.swap_calls_sharp, color: TeAppColorPalette.black),
                Text(
                  ' Tipo',
                  style: TextStyle(color: TeAppColorPalette.black),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget coachPickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: (DateTime.now().subtract(const Duration(days: 730))),
            lastDate: (DateTime.now().add(const Duration(days: 730))),
          );
        },
        child: const SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.person_2_rounded, color: TeAppColorPalette.black),
                Text(
                  ' Coach',
                  style: TextStyle(color: TeAppColorPalette.black),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget durationPickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  width: TeMediaQuery.getPercentageWidth(context, 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ListView.builder(
                    itemCount: 23,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index + 1} hrs'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: const SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.timer, color: TeAppColorPalette.black),
                Text(
                  ' Duracion',
                  style: TextStyle(color: TeAppColorPalette.black),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Clases")),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: TeMediaQuery.getPercentageHeight(context, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      datePickerChip(context),
                      hourPickerChip(context),
                      durationPickerChip(context),
                      coachPickerChip(context),
                      typePickerChip(context),
                    ],
                  ),
                ),
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

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  TeAppColorPalette.green)));
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
                        String classCoach = documentData['classCoach'];
                        String classDesription =
                            documentData['classDescription'];
                        int classDuration = documentData['classDuration'];
                        int classLimitSpaces = documentData['classLimitSpaces'];
                        String classType = documentData['classType'];
                        DateTime classDate =
                            (documentData['classTimeStamp'] as Timestamp)
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

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TeAppThemeData.contentMargin),
                          child: TeClassCard(
                            reserving: true,
                            light: false,
                            classInfo: classInfo,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
