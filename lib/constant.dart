import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/repository/user_repository.dart';

var userRepo = UserRepository();

customSnackBar(String data){
  return Get.snackbar(
    "Message",
    data
  );
}