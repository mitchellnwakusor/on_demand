import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/error_handler.dart';

class FirebaseAuthServices {
  //Singleton instance
  static FirebaseAuthServices instance = FirebaseAuthServices._init();
  FirebaseAuthServices._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  String? get currentUserUID{
    return _auth.currentUser?.uid;
  }

  int? _forceResendingToken;
  String _verificationId = '';

  Future<void> sendCodeWithNavigation(
      {required String phoneNumber,
      Map<String, dynamic>? data,
      required BuildContext context}) async {

    await _auth.verifyPhoneNumber(
      phoneNumber: '+234$phoneNumber',
      forceResendingToken: _forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException exception) => ErrorHandler().authDisplayError(exception, context),
      codeSent: (String verificationID, int? forceResendingToken) {
        //navigate to otp input screen (and) set values
        _forceResendingToken = forceResendingToken;
        _verificationId = verificationID;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          //pass signup data to otp screen
          return const Placeholder();
        }));
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  //verify smsCode
  Future<User?> verifySMSCode(String smsCode,BuildContext context) async {
    try {
      //get credential from verificationId and smsCode then sign in
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (exception) {
      //call error handler
      ErrorHandler().authDisplayError(exception, context);
      return null;
    }
  }

}



