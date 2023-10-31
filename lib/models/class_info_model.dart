class ClassInfoModel {
  // late final NetworkImage classCoachImage;
  late final String documentID;
  late final String classCoach;
  late final String classDesription;
  late final double classDuration;
  late final int classLimitSpaces;
  late final String classType;
  late final DateTime classDate;
  late final int classCost;
  late final bool light;

  ClassInfoModel({
    required this.classCost,
    required this.documentID,
    required this.classCoach,
    required this.classDesription,
    required this.classDuration,
    required this.classLimitSpaces,
    required this.classType,
    required this.classDate,
  });
}
