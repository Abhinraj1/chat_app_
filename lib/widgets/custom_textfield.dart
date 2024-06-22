// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app_ayna/constant.dart';
import 'package:flutter/material.dart';

import '../core/manager/color_manager.dart';
import '../core/manager/font_manager.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  int? lines;
  String hintText;
  bool isPassword;
  TextEditingController controller;
  CustomTextField({
    super.key,
    required this.hintText,
    this.lines = 1,
    this.isPassword = false,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textFieldStyle,
      validator: (val) {
        if (widget.hintText != "Mobile2" && val!.isEmpty || val == null) {
          return 'Enter your ${widget.hintText}';
        }
      },
      cursorColor: Colors.white,
      controller: widget.controller,
      obscureText: !widget.isPassword ? false : isShow,
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.4),
          filled: true,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: isShow
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.white70,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.white70,
                        ),
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                )
              : null,
          labelText: widget.hintText,
          labelStyle: textFieldStyle,
          floatingLabelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white70)),
    );
  }
}
