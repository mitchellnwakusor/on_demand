import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {
  static FirebaseAuthServices instance = FirebaseAuthServices._init();

  FirebaseAuthServices._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? _forceResendingToken;
  String _verificationId = '';

  Future<void> phoneNumberSignup(String phoneNumber,Function navigator) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // create user with credential - in the case of phone number, sign-up is sign-in
        await _auth.signInWithCredential(credential); //TODO: wrap in error handler
      },
      verificationFailed: (FirebaseAuthException exception) {
        //TODO: call error handler
        //error handler could have two overrides, one accepts a method to try-catch, the other accepts an exception to display a dialog
      },
      codeSent: (String verificationID, int? forceResendingToken) {
        //navigate to otp input screen with arguments or(and) set values
        _forceResendingToken = forceResendingToken;
        _verificationId = verificationID;
        navigator();
      },
      codeAutoRetrievalTimeout: (String verificationID) {

      },
    );
  }

  static void registerArtisanPhoneNumber(String phoneNumber,BuildContext context) async {
    void navigator() {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        return const Placeholder();
      }));
    }
    await FirebaseAuthServices.instance.phoneNumberSignup(phoneNumber, navigator);
  }

}


