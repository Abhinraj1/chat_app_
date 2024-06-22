import 'package:chat_app_ayna/screens/auth/login.dart';
import 'package:chat_app_ayna/screens/auth/signup_screen.dart';
import 'package:chat_app_ayna/screens/chat_screen.dart';
import 'package:chat_app_ayna/screens/profile_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

List<GetPage> appRoute() {
  return [
    GetPage(
      name: "/",
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: "/signup",
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: "/chatScreen",
      page: () => ChatScreen(),
    ),
    GetPage(
      name: "/profile",
      page: () => const ProfileScreen(),
    ),
  ];
}
