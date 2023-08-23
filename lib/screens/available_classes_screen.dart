import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return ElevatedButton(
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: (DateTime.now().subtract(const Duration(days: 730))),
          lastDate: (DateTime.now().subtract(const Duration(days: 730))),
        );
      },
      child: const Expanded(
          child: Center(
        child: Row(
          children: [Icon(Icons.date_range), Text('Fecha')],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Clases")),
      body: Column(
        children: [
          SizedBox(
            height: TeMediaQuery.getPercentageHeight(context, 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [],
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
                    String classDesription = documentData['classDescription'];
                    int classDuration = documentData['classDuration'];
                    int classLimitSpaces = documentData['classLimitSpaces'];
                    String classType = documentData['classType'];
                    DateTime classDate =
                        (documentData['classTimeStamp'] as Timestamp).toDate();

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
          ),
        ],
      ),
    );
  }
}
