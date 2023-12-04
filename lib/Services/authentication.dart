import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/routes.dart';

class Authentication {

 static final Authentication instance = Authentication._init();
 Authentication._init();

 final FirebaseAuth _authInstance = FirebaseAuth.instance;

 Stream<User?> get authChanges => _authInstance.userChanges();

 String? _verificationID;
 int? _forceResendingToken;

 void sendOTPCode(BuildContext context,String number) async{
  await _authInstance.verifyPhoneNumber(
   phoneNumber: '+234$number',
   timeout: const Duration(seconds: 60),
   verificationCompleted: (credential){},
   verificationFailed: (exception){
       Fluttertoast.showToast(msg: '${exception.message}');
      },
   codeSent: (verificationID,resendToken){
       _verificationID = verificationID;
       _forceResendingToken = resendToken;
       Navigator.pushNamed(context,otpVerificationScreen);
      },
   codeAutoRetrievalTimeout: (timeout){},
  );
 }
 void resendOTPCode(BuildContext context,String number) async{
  await _authInstance.verifyPhoneNumber(
   phoneNumber: '+234$number',
   forceResendingToken: _forceResendingToken,
   timeout: const Duration(seconds: 60),
   verificationCompleted: (credential){},
   verificationFailed: (exception){
       Fluttertoast.showToast(msg: '${exception.message}');
      },
   codeSent: (verificationID,resendToken){
       _verificationID = verificationID;
       _forceResendingToken = resendToken;
       Navigator.pushReplacementNamed(context,otpVerificationScreen);
      },
   codeAutoRetrievalTimeout: (timeout){},
  );
 }

 void emailSignIn(BuildContext context, String email,String password) async{
   try {
     await _authInstance.signInWithEmailAndPassword(email: email, password: password);
     if(context.mounted){
       Navigator.popUntil(context, ModalRoute.withName('/'));
     }
   } on FirebaseAuthException catch (exception) {
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void phoneSignIn(BuildContext context,String smsCode) async{
   try {
     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);
     await _authInstance.signInWithCredential(credential);
     //close previous pages
     if(context.mounted){
       Navigator.popUntil(context, (route) => false);
     }
   } on FirebaseAuthException catch (exception) {
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void linkEmailCredential(String email,String password) async{
   AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
   _authInstance.currentUser!.linkWithCredential(credential);
 }

}