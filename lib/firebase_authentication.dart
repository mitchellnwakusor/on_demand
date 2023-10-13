import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/error_handler.dart';

class FirebaseAuthServices {
  static FirebaseAuthServices instance = FirebaseAuthServices._init();

  FirebaseAuthServices._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? _forceResendingToken;
  String _verificationId = '';

  Future<void> phoneNumberSignupWithNavigation(String phoneNumber,BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // create user with credential - in the case of phone number, sign-up is sign-in
        //wrap in error handler
        ErrorHandler().authCheckMethod(() async => await _auth.signInWithCredential(credential), context);
      },
      verificationFailed: (FirebaseAuthException exception) {
        //call error handler
        ErrorHandler().authDisplayError(exception, context);
        //error handler could have two overrides, one accepts a method to try-catch, the other accepts an exception to display a dialog

      },
      codeSent: (String verificationID, int? forceResendingToken) {
        //navigate to otp input screen with arguments or(and) set values
        _forceResendingToken = forceResendingToken;
        _verificationId = verificationID;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return const Placeholder();
        }));
      },
      codeAutoRetrievalTimeout: (String verificationID) {

      },
    );
  }

  Future<void> verifySMSCode(String smsCode,BuildContext context) async {
    try {
      //get credential from verificationId and smsCode then sign in
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (exception) {
      //call error handler
      ErrorHandler().authDisplayError(exception, context);
    }
  }

}




