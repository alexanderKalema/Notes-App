import 'package:bloc/bloc.dart';
import 'package:nibret_kifel/services/auth/auth_provider.dart';
import 'package:nibret_kifel/services/auth/auth_service.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_event.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthService provider , )
      : super(const AuthStateUninitialized(isLoading: true)) {




    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));

    });
//forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot-password screen
      }

// user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
// send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {

      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I Register you ...',
        ),
      );
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      }
      on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
// initialize
    on<AuthEventInitialize>((event, emit) async {



 // await provider.initialize();


  final user = provider.currentUser;

if(  user?.provider?.contains("password") ?? false)
{

  if (user == null) {
    emit(
      const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ),
    );
  }
  else if (!user.isEmailVerified) {
    emit(const AuthStateNeedsVerification(isLoading: false));
  }
  else {
    emit(AuthStateLoggedIn(
      user: user,
      isLoading: false,
    ));

}
}
else{
  emit(
    const AuthStateLoggedOut(
      exception: null,
      isLoading: false,
    ),
  );
}

});

// log in

    on<AuthEventLoginWithGoogle>(
        (event, emit) async{
      // emit(
      //   const AuthStateLoggedOut(
      //     exception: null,
      //     isLoading: true,
      //     loadingText: 'Please wait while I log you in',
      //   ),
      // );in
      emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while I log you in',
          ));


      try {


          await provider.googleLogIn();

         var user = provider.googleUser;

       emit(AuthStateLoggedIn(
         user: user,
         isLoading: false,
       ));

        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));

      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );


      }


    });


    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
// log out
    on<AuthEventLogOut>((event, emit) async {
      try {

          String? myprovider = event.emailUser?.provider ;

        if(myprovider?.contains("password") ?? false) {
          await provider.logOut();

        }
       else {

          await provider.googlelogOut();
        }


        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}
