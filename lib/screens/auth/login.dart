import 'package:chat_app_ayna/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_ayna/widgets/custom_button.dart';
import 'package:chat_app_ayna/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../core/bloc/profile_bloc.dart';
import '../../core/bloc/profile_event.dart';
import '../../core/bloc/profile_state.dart';
import '../../core/manager/font_manager.dart';
import '../../core/manager/image_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

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
            create: (context) => ProfileBloc(
              authRepository: userRepo,
            ),
            child: BlocConsumer<ProfileBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  Get.offAll("chatScreen");
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
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        "Login",
                        style: titleStyle,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Center(
                      child: Text("Welcome!..", style: subTitleStyle),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _loginKey,
                      child: Column(
                        children: [
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
                          state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : CustomButton(
                                  title: "Login",
                                  onTap: () {
                                    if (_loginKey.currentState!.validate()) {
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        SignInEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed("/signup");
                        },
                        child: Text(
                          " OR Create Account",
                          style: infoStyle,
                        ),
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
