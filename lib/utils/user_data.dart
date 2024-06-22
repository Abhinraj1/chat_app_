import 'package:chat_app_ayna/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

saveUserData(
    {required String name,
    required String email,
    required String mobileNumber,
    required String profilePic}) async {
  final details = await Hive.openBox('userDetails');
  await details.putAll({
    "name": name,
    "email": email,
    "mobileNumber": mobileNumber,
    "profilePic": profilePic
  });
}



Future<LocalUser> getUserData() async {
  final details = await Hive.openBox('userDetails');
  return LocalUser(
      email: await details.get("email"),
      name: await details.get("name"),
      mobileNumber: await details.get("mobileNumber"),
      profilePic: await details.get("profilePic"));
}


clearUserData() async {
  final details = await Hive.openBox('userDetails');
  await details.putAll({
    "name": "",
    "email": "",
    "mobileNumber": "",
    "profilePic": ""
  });
}

Future<bool> checkUser() async{
  final details = await Hive.openBox('userDetails');
  final String email = await details.get("email");
  if(email.trim().isEmpty){
    return false;
  }else{
    return true;
  }
}