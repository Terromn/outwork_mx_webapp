import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  String? _selectedCoach;
  String? _selectedClassType;

  void _updateSelectedCoach(String newCoach) {
    setState(() {
      _selectedCoach = newCoach;
    });
  }

  void _updateSelectedClassType(String newClassType) {
    setState(() {
      _selectedClassType = newClassType;
    });
  }

  TimeOfDay _convertTimestampToTimeOfDay(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return TimeOfDay.fromDateTime(dateTime);
  }

  DateTime _convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  void resetFilters() {
    setState(() {
      _selectedTime = null;
      _selectedDate = null;
      _selectedCoach = null;
      _selectedClassType = null;
    });
  }

  Widget pickerButton(BuildContext context, String insideText,
      Function updateFilter, var filterValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ElevatedButton(
        child: SizedBox(
          height: 68,
          child: Center(
            child: Text(
              insideText,
              style:
                  const TextStyle(color: TeAppColorPalette.black, fontSize: 18),
            ),
          ),
        ),
        onPressed: () {
          updateFilter(filterValue);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget datePickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: Builder(builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: (DateTime.now().subtract(const Duration(days: 730))),
                lastDate: (DateTime.now().add(const Duration(days: 730))),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: const SizedBox(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.date_range_rounded,
                        color: TeAppColorPalette.black),
                    Text(
                      ' Fecha',
                      style: TextStyle(color: TeAppColorPalette.black),
                    )
                  ],
                ),
              ),
            )),
          );
        }),
      ),
    );
  }

  Widget hourPickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: Builder(builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.input,
              );

              if (pickedTime != null) {
                setState(() {
                  _selectedTime = pickedTime;
                });
              }
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
          );
        }),
      ),
    );
  }

  Widget typePickerChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                    height: 360,
                    width: TeMediaQuery.getPercentageWidth(context, 40),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: TeAppColorPalette.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Center(
                      child: ListView(
                        children: [
                          pickerButton(context, "Yoga",
                              _updateSelectedClassType, "Yoga"),
                          pickerButton(context, "Calistenia",
                              _updateSelectedClassType, "Calistenia"),
                          pickerButton(context, "HIIT",
                              _updateSelectedClassType, "HIIT"),
                          pickerButton(context, "Kettle Flow",
                              _updateSelectedClassType, "Kettle Flow"),
                        ],
                      ),
                    )),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  height: 360,
                  width: TeMediaQuery.getPercentageWidth(context, 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TeAppColorPalette.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('coaches').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error loading coaches');
                      }
                      final coaches = snapshot.data!.docs;

                      return Center(
                        child: ListView.builder(
                          itemCount: coaches.length,
                          itemBuilder: (context, index) {
                            final coachName = coaches[index]['coachName'];
                            return pickerButton(context, coachName,
                                _updateSelectedCoach, coachName);
                          },
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Clases",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 32),
          )),
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

                    final filteredDocuments = documents.where((document) {
                      final classTimestamp =
                          document['classTimeStamp'] as Timestamp;
                      final classTime =
                          _convertTimestampToTimeOfDay(classTimestamp);
                      final classDate =
                          _convertTimestampToDateTime(classTimestamp);
                      final classCoach = document['classCoach'];
                      final classType = document['classType'];

                      if (_selectedTime != null) {
                        if (_selectedTime != classTime) {
                          return false;
                        }
                      }

                      if (_selectedDate != null) {
                        // You might need to compare dates without time for accurate filtering.
                        if (_selectedDate?.year != classDate.year ||
                            _selectedDate?.month != classDate.month ||
                            _selectedDate?.day != classDate.day) {
                          return false;
                        }
                      }

                      if (_selectedCoach != null && classCoach != null) {
                        if (_selectedCoach != classCoach) {
                          return false;
                        }
                      }

                      if (_selectedClassType != null && classType != null) {
                        if (_selectedClassType != classType) {
                          return false;
                        }
                      }

                      return true; // Include this document in the filtered list.
                    }).toList();

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        final documentData = filteredDocuments[index];

                        String id = filteredDocuments[index].id;
                        String classCoach = documentData['classCoach'];
                        String classDesription =
                            documentData['classDescription'];
                        double classDuration = documentData['classDuration'];
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
