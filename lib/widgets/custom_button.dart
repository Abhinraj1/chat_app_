import 'package:chat_app_ayna/constant.dart';
import 'package:chat_app_ayna/core/manager/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/manager/color_manager.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool? isLoading;
  const CustomButton({super.key, required this.onTap, required this.title, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 6.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:primaryDark
            ),
        child: Center(
            child: isLoading?? false ? const CircularProgressIndicator(
              color: Colors.white,
            ) : Text(
          title,
          style: buttonStyle,
        )),
      ),
    );
  }
}
