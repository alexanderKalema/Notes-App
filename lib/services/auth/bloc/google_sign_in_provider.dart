
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nibret_kifel/services/auth/auth_provider.dart';
import 'package:nibret_kifel/services/auth/auth_user.dart';
import 'package:nibret_kifel/services/auth/firebase_auth_provider.dart';


class GoogleSignInProvider extends ChangeNotifier implements AuthProvider {


  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
   GoogleSignInAuthentication? googleSignInAuthentication;
   late User user;
   late AuthCredential credential;
   late UserCredential userCredential;
  Future<void> googleLogin() async{




     googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
       googleSignInAuthentication =
      await googleSignInAccount!.authentication;

       credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication!.accessToken,
        idToken: googleSignInAuthentication!.idToken,
      );

      try {
         userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user! ;



      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }


  @override
  Future<AuthUser> createUser({required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  AuthUser? get currentUser {
    if (user != null) {
      return AuthUser.fromGoogle(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
           await googleSignIn.signOut();
    // throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }

}