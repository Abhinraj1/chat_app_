// profile_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:chat_app_ayna/core/manager/color_manager.dart';
import 'package:chat_app_ayna/core/manager/font_manager.dart';
import 'package:chat_app_ayna/core/manager/image_manager.dart';
import 'package:chat_app_ayna/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/user_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileBg), fit: BoxFit.cover)),
          child: GlassContainer(
            blur: 2,
            borderColor: Colors.white.withOpacity(0.2),
            borderGradient:
                LinearGradient(colors: [Colors.white.withOpacity(0.2)]),
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.4),
              Colors.white.withOpacity(0.2)
            ]),
            child: FutureBuilder(
                future: getUserData(),
                builder: (context, AsyncSnapshot<LocalUser> data) {
                  final LocalUser? user = data.data;
                  if (data.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                            child: Text(
                          "User Profile",
                          style: titleStyle,
                        )),
                        SizedBox(
                          height: 5.h,
                        ),
                        CircleAvatar(
                          radius: 10.h,
                          backgroundColor: primaryDark.withOpacity(0.3),
                          backgroundImage:
                              (user?.profilePic).toString().contains("null")
                                  ? null
                                  : NetworkImage(user?.profilePic ?? ""),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 40.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                              color: primaryDark.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10.h)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: Text(
                                user?.name ?? "Hi",
                                style: subTitleStyle,
                              )),
                              Center(
                                  child: Text(
                                user?.email ?? "No Email",
                                style: subTitleStyle,
                              )),
                              Center(
                                  child: Text(
                                user?.mobileNumber ?? "",
                                style: subTitleStyle,
                              )),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white60,
                    ));
                  }
                }),
          )),
    );
  }
}
