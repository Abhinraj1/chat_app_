import 'package:chat_app_ayna/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository authRepository;

  ProfileBloc({required this.authRepository})
      : super(AuthInitial()) {


    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(
          email: event.email,
          password: event.password,
        );
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          Get.offAllNamed("/chatScreen");
        } else {
          emit(const AuthError(message: 'Failed to sign in'));
        }
      } catch (e) {
        emit(const AuthError(message: 'Failed to sign in'));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(
          name: event.name,
          email: event.email,
          password: event.password,
          file: event.file

        );
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          Get.offAllNamed("/chatScreen");
        } else {
          emit(const AuthError(message: 'Failed to sign up'));
        }
      } catch (e) {
        emit(const AuthError(message:'Failed to sign up'));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthUnauthenticated());
    });

  
  }
}
