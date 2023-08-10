class UserModel {
  late int creditsAvailable;
  late String name;
  late String profilePicture;
  late List reservedClasses;

  UserModel({
    required this.creditsAvailable,
    required this.name,
    required this.profilePicture,
    required this.reservedClasses,
  });
}
