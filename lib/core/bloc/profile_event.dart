import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}



class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final XFile? file;

  const SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    this.file,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class SignOutEvent extends AuthEvent {}

class ProfilePicChanged extends AuthEvent {
  final String profilePicUrl;

  const ProfilePicChanged({required this.profilePicUrl});

  @override
  List<Object?> get props => [profilePicUrl];
}
