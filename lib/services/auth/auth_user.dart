import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  String? provider;
   AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
     this.provider
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
    id: user.uid,
    email: user.email!,
    isEmailVerified: user.emailVerified,
    provider:user.providerData[0].providerId,
  );
  factory AuthUser.fromGoogle(User user) => AuthUser(
    id: user.uid,
    email: user.email!,
    isEmailVerified: user.emailVerified,
    provider:user.providerData[0].providerId,
  );
}