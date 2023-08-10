class ClassInfoModel {
  // late final NetworkImage classCoachImage;
  late final String documentID;
  late final String classCoach;
  late final String classDesription;
  late final int classDuration;
  late final int classLimitSpaces;
  late final String classType;
  late final DateTime classDate;
  late final bool light;

  ClassInfoModel({
    // required this.classCoachImage,
    required this.documentID,
    required this.classCoach,
    required this.classDesription,
    required this.classDuration,
    required this.classLimitSpaces,
    required this.classType,
    required this.classDate,
  });
}
