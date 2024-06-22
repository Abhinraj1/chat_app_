import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app_ayna/constant.dart';

import '../../model/user_model.dart';
import '../../utils/user_data.dart';


class UserRepository {
  String url = "https://fcb-donation.onrender.com";

  Future<LocalUser?> signUp(
      {required String email,
      required String password,
      required String name,
      required XFile? file}) async {
    LocalUser user;
    String? imageUrl;

    user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      print("ERROR SIGN UP =============$e");
    }).then(
      (_user) async {
        if (file != null) {
          _uploadImage(uid: _user.user?.uid ?? "n", file: file).then(
            (img) async {
              imageUrl = await img?.ref.getDownloadURL();
              _updateUserDetails(name, imageUrl ?? "").then(
                (_) {
                  return LocalUser(
                    name: _user.user?.displayName.toString() ?? "",
                    email: _user.user?.email.toString() ?? "",
                    mobileNumber: _user.user?.phoneNumber.toString() ?? "",
                    profilePic: _user.user?.photoURL ?? "",
                  );
                },
              );
            },
          );
        } else {
          await _updateUserDetails(name, imageUrl ?? "").then(
            (_) async {
              saveUserData(
                  name: name,
                  email: email,
                  mobileNumber: _user.user?.phoneNumber.toString() ?? "",
                  profilePic: imageUrl ?? "");
              return LocalUser(
                name: name,
                email: email,
                mobileNumber: _user.user?.phoneNumber.toString() ?? "",
                profilePic: imageUrl ?? "",
              );
            },
          );
        }
        return LocalUser(
          name: name,
          email: email,
          mobileNumber: _user.user?.phoneNumber.toString() ?? "",
          profilePic: imageUrl ?? "",
        );
      },
    );
    return user;
  }

  Future<void> _updateUserDetails(String name, String url) async {
    try {
      final value = await FirebaseAuth.instance.currentUser
          ?.updateProfile(displayName: name, photoURL: url);
      return value;
    } catch (e) {
      print("Error Updating User detaisl ==$e");
    }
  }

  Future<TaskSnapshot?> _uploadImage(
      {required XFile file, required String uid}) async {
    try {
      await FirebaseStorage.instance
          .ref("Dp/${uid}.jpg")
          .putData(
              await file.readAsBytes(),
              SettableMetadata(
                contentType: 'image/jpeg',
                customMetadata: {'picked-file-path': file.path},
              ))
          .then(
        (snap) {
          return snap;
        },
      );
    } catch (e) {
      print("Error uploadinh image===$e");
    }
    return null;
  }

  Future<LocalUser?> login({
    required String email,
    required String password,
  }) async {
    LocalUser user;
    user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (_user) async {
        saveUserData(
            name: _user.user?.displayName ?? "Hi",
            email: _user.user?.email ?? "",
            mobileNumber: _user.user?.phoneNumber.toString() ?? "",
            profilePic: _user.user?.photoURL ?? "");

        return LocalUser(
            email: _user.user?.email ?? "",
            name: _user.user?.displayName ?? "",
            mobileNumber: _user.user?.phoneNumber ?? "",
            profilePic: _user.user?.photoURL ?? "");
      },
    ).catchError((error) {
      var errorCode = error.code;

      if (errorCode == 'auth/invalid-email') {
        customSnackBar("Invalid Credentials");
      } else {
        customSnackBar("Something went wrong please try after sometime");
      }
    });
    return user;
  }

  Future<bool> isLoggedIn() async {
    return await checkUser();
  }

  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    final allChats = await Hive.box("chatBox");
    allChats.clear();
    clearUserData();
    Get.offAllNamed("/");
  }

  void httpErrorHandling({
    required http.Response res,
    required VoidCallback onSuccess,
  }) {
    switch (res.statusCode) {
      case 200:
        onSuccess();
        break;
      case 400:
        customSnackBar('Bad request');
        break;
      case 401:
        customSnackBar('Unauthorized');
        break;
      case 500:
        customSnackBar('Server error');
        break;
      default:
        customSnackBar('Unexpected error');
    }
  }
}
