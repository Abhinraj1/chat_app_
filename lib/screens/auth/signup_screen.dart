import 'dart:io';
import 'dart:typed_data';
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:chat_app_ayna/constant.dart';
import 'package:chat_app_ayna/core/manager/font_manager.dart';
import 'package:chat_app_ayna/screens/auth/login.dart';
import 'package:chat_app_ayna/screens/chat_screen.dart';
import 'package:chat_app_ayna/widgets/custom_button.dart';
import 'package:chat_app_ayna/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/bloc/profile_bloc.dart';
import '../../core/bloc/profile_event.dart';
import '../../core/bloc/profile_state.dart';
import '../../core/manager/color_manager.dart';
import '../../core/manager/image_manager.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signup";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  XFile? file;
  Uint8List registrationImage = Uint8List(1);
  final authBloc = ProfileBloc(authRepository: userRepo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(authBg), fit: BoxFit.cover)),
        child: GlassContainer(
          blur: 2,
          borderColor: Colors.white.withOpacity(0.2),
          borderGradient:
              LinearGradient(colors: [Colors.white.withOpacity(0.2)]),
          gradient: LinearGradient(colors: [
            Colors.black.withOpacity(0.4),
            Colors.white.withOpacity(0.2)
          ]),
          child: BlocProvider(
            create: (context) => ProfileBloc(authRepository: userRepo),
            child: BlocConsumer<ProfileBloc, AuthState>(
              bloc: authBloc,
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  Get.offAllNamed("/chatScreen");
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                  children: [
                    SizedBox(height: 5.h),
                    Center(
                      child: Text("Sign Up", style: titleStyle),
                    ),
                    // SizedBox(height: 5.h),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          ImagePicker()
                              .pickImage(
                                  source: ImageSource.gallery, imageQuality: 30)
                              .then((xFile) async {
                            xFile?.readAsBytes().then(
                              (value) {
                                setState(() {
                                  file = xFile;
                                  registrationImage = value;
                                });
                              },
                            );
                          });
                        },
                        child: CircleAvatar(
                          radius: 8.h,
                          backgroundColor: file != null
                              ? Colors.white70
                              : Colors.grey.withOpacity(0.8),
                          backgroundImage: file != null
                              ? MemoryImage(registrationImage)
                              : null,
                          child: file != null
                              ? const SizedBox()
                              : Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white,
                                  size: 5.h,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Form(
                      key: _signUpKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            controller: _nameController,
                          ),
                          SizedBox(height: 5.h),
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          SizedBox(height: 5.h),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          SizedBox(height: 5.h),
                          CustomButton(
                            isLoading: state is AuthLoading,
                            title: "Sign Up",
                            onTap: () {
                              if (_signUpKey.currentState!.validate()) {
                                authBloc.add(
                                  SignUpEvent(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      file: file),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 2.h),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.offAllNamed("/");
                              },
                              child: Text("OR Login", style: infoStyle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
