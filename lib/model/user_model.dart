import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class LocalUser {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String mobileNumber;

  @HiveField(3)
  final String profilePic;

  LocalUser({
    required this.email,
    required this.name,
    required this.mobileNumber,
    required this.profilePic,
  });

  factory LocalUser.fromJson(Map<String, dynamic> json) {
    return LocalUser(
      email: json['email'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      profilePic: json['profilePic'],
    );
  }
}
