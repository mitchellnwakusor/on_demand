import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/firebase_database.dart';

class Authentication {

 static final Authentication instance = Authentication._init();
 Authentication._init();

 final FirebaseAuth _authInstance = FirebaseAuth.instance;

 Stream<User?> get authChanges => _authInstance.authStateChanges();
 User? get currentUser => _authInstance.currentUser;

 String? _verificationID;
 int? _forceResendingToken;

 void sendOTPCode({required BuildContext context, required String number, bool? isReauthenticate, bool? isUpdateNumber}) async{
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
       Navigator.pushNamed(context,otpVerificationScreen,arguments: [isReauthenticate,isUpdateNumber]);
   },
   codeAutoRetrievalTimeout: (timeout){},
  );
 }
 void resendOTPCode(BuildContext context,String number,bool? isReauthenticate, bool? isUpdateNumber) async{
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
       Navigator.pushReplacementNamed(context,otpVerificationScreen,arguments: [isReauthenticate,isUpdateNumber]);
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
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void emailReauthenticate(BuildContext context, String email,String password) async{
   try {
     AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: password);
     await _authInstance.currentUser!.reauthenticateWithCredential(authCredential);
     bool isAuthenticated = true;
     if(context.mounted){
       Navigator.pop(context);
       Navigator.pop(context,isAuthenticated);
     }
   } on FirebaseAuthException catch (exception) {
     bool isAuthenticated = false;
     if (!context.mounted) return;
     Navigator.pop(context,isAuthenticated);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void phoneSignIn(BuildContext context,String smsCode) async{
   try {
     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);
     await _authInstance.signInWithCredential(credential);
     //close previous pages
     if(context.mounted){
       Navigator.popUntil(context, ModalRoute.withName('/'));
     }
   } on FirebaseAuthException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }
 void phoneReauthenticate(BuildContext context,String smsCode) async{
   try {
     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);
     await _authInstance.currentUser!.reauthenticateWithCredential(credential);
     bool isAuthenticated = true;
     //close previous pages
     if(context.mounted){
       Navigator.pop(context);
       Navigator.pop(context);
       Navigator.pop(context,isAuthenticated);
       print(isAuthenticated);
     }
   } on FirebaseAuthException catch (exception) {
     bool isAuthenticated = false;
     if (!context.mounted) return;
     Navigator.pop(context,isAuthenticated);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void linkEmailCredential(String email,String password) async{
   try {
     AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
     _authInstance.currentUser!.linkWithCredential(credential);
   } on FirebaseAuthException catch (exception) {
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void forgotPassword(BuildContext context,String email) async{
  try {
    await _authInstance.sendPasswordResetEmail(email: email).then((value) {
      if (!context.mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'A password reset link has been sent to your email address');
    });
  } on FirebaseAuthException catch (exception) {
    if (!context.mounted) return;
    Navigator.pop(context);
    Fluttertoast.showToast(msg: '${exception.message}');
  }
 }

 void updateEmail(TextEditingController valueController,BuildContext context) async {
   try{
     bool? result = await Navigator.pushNamed(context, loginScreenReauthenticate) as bool?;
     if(result!=null && result == true){
       Map<String,dynamic> data = {'email': valueController.text};
       await _authInstance.currentUser!.updateEmail(valueController.text);
       // update database
       await FirebaseDatabase.updateUserDetails(data: data, uid: _authInstance.currentUser!.uid);

       _authInstance.currentUser!.reload();
       if(context.mounted){
         Navigator.popUntil(context, ModalRoute.withName('/'));
       }
       Fluttertoast.showToast(msg: 'updated email');
     }
   }
   on FirebaseException catch(exception){
     Fluttertoast.showToast(msg: exception.code);
   }
 }

 void updatePhoneNumber(TextEditingController valueController,BuildContext context) async{
   try{
     //start login flow and return bool value
     bool? isAuthenticated  = await Navigator.pushNamed(context, loginScreenReauthenticate) as bool?;
     if(isAuthenticated!=null && isAuthenticated == true){
       if(context.mounted){
         sendOTPCode(context: context, number: valueController.text,isUpdateNumber: true);
       }
       // if(context.mounted){
       //   Navigator.popUntil(context, ModalRoute.withName('/'));
       // }
     }
   }
   on FirebaseException catch(exception){
     Fluttertoast.showToast(msg: exception.code);
   }
 }

void updateNumber(BuildContext context,String phoneNumber,String smsCode) async{
  try {
    Map<String,dynamic> data = {'phone_number': phoneNumber};

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);

    await _authInstance.currentUser!.updatePhoneNumber(credential);
    // update database
    await FirebaseDatabase.updateUserDetails(data: data, uid: _authInstance.currentUser!.uid);
    _authInstance.currentUser!.reload();
    Fluttertoast.showToast(msg: 'updated phone');
    //close previous pages
    if(context.mounted){
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  } on FirebaseAuthException catch (exception) {
    if (!context.mounted) return;
    Navigator.pop(context);
    Fluttertoast.showToast(msg: '${exception.message}');
  }
}
}