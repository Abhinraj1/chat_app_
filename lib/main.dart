import 'package:chat_app_ayna/core/manager/color_manager.dart';
import 'package:chat_app_ayna/core/manager/route_manager.dart';
import 'package:chat_app_ayna/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_ayna/screens/auth/login.dart';
import 'package:chat_app_ayna/screens/chat_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/bloc/profile_bloc.dart';
import 'core/repository/user_repository.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.openBox('chatBox');
  await Hive.openBox('userDetails');
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return FutureBuilder(
        future: userRepository.isLoggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == true) {
              return BlocProvider(
                create: (context) =>
                    ProfileBloc(authRepository: userRepository),
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Chat App',
                 // initialRoute: "/chatScreen",
                  theme: ThemeData(
                    primarySwatch: Colors.grey,
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(seedColor: primaryDark),
                  ),
                  home: ChatScreen(),
                  getPages: appRoute(),
                ),
              );
            } else {
              return BlocProvider(
                create: (context) =>
                    ProfileBloc(authRepository: userRepository),
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Chat App',
                  getPages: appRoute(),
                  //initialRoute: "/",
                  theme: ThemeData(
                      primarySwatch: Colors.grey,
                      colorScheme: ColorScheme.fromSeed(seedColor: primaryDark),
                      useMaterial3: true),
                  home: const LoginScreen(),
                ),
              );
            }
          }
        },
      );
    });
  }
}
