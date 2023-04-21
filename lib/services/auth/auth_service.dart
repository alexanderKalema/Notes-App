import 'package:Notes_App/services/auth/auth_provider.dart';
import 'package:Notes_App/services/auth/auth_user.dart';
import 'package:Notes_App/services/auth/firebase_auth_provider.dart';
import 'google_sign_in_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider FirebaseProvider;
  GoogleSignInProvider? googleProvider;

  AuthService({required this.FirebaseProvider, this.googleProvider});

  factory AuthService.firebase() =>
      AuthService(FirebaseProvider: FirebaseAuthProvider());
  factory AuthService.googleLogin() => AuthService(
      googleProvider: GoogleSignInProvider(),
      FirebaseProvider: FirebaseAuthProvider());

  Future<void> googleLogIn() async => await googleProvider?.googleLogin();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      FirebaseProvider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => FirebaseProvider.currentUser;

  AuthUser? get googleUser => googleProvider?.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      FirebaseProvider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => FirebaseProvider.logOut();

  Future<void>? googlelogOut() => googleProvider?.logOut();

  @override
  Future<void> sendEmailVerification() =>
      FirebaseProvider.sendEmailVerification();

  @override
  Future<void> initialize() => FirebaseProvider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      FirebaseProvider.sendPasswordReset(toEmail: toEmail);
}
