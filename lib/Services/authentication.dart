import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/edit_profile_provider.dart';
import 'package:provider/provider.dart';

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

 //***** Change Email *********//

 void changeEmailAddress(TextEditingController valueController,BuildContext context) async {
   try{
     Provider.of<EditProfileProvider>(context,listen: false).setNewEmail(valueController.text);
     //reauthenticate user
     bool isDone = await Navigator.pushNamed(context, loginScreenReauthenticate) as bool;
     //update email
     if(isDone){
       if(context.mounted){
         _updateEmail(context);
       }
     }
   }
   on FirebaseException catch(exception){
     Fluttertoast.showToast(msg: exception.code);
   }
 }

 void _updateEmail(BuildContext context) async {
   //get email value
   try {
     String? email = Provider.of<EditProfileProvider>(context,listen: false).newEmail;
     if(email!=null){
       Map<String,dynamic> data = {'email': email};
       //update auth email
       await _authInstance.currentUser!.updateEmail(email);
       // update database email
       await FirebaseDatabase.updateUserDetails(data: data, uid: _authInstance.currentUser!.uid);
       _authInstance.currentUser!.reload();
       // pop reauthenticate progress indicator
       if(context.mounted){
         Fluttertoast.showToast(msg: 'updated email');
         Navigator.popUntil(context, ModalRoute.withName('/'));
         Navigator.pushNamed(context, authHandlerScreen);
       }
     }
   } on FirebaseException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 //***** Change Number *********//

 void changePhoneNumber(String number,BuildContext context) async{
   try{
     //save new number in provider for otp screen and database
     Provider.of<EditProfileProvider>(context,listen: false).setNewNumber(number);
     //reauthenticate user
     bool isAuthenticated = await Navigator.pushNamed(context, loginScreenReauthenticate) as bool;
     //update number
     if(isAuthenticated){
       if(context.mounted){
         sendOTPCode(context: context, number: number,isUpdateNumber: true);
       }
     }
   }
   on FirebaseException catch(exception){
     Fluttertoast.showToast(msg: exception.code);
   }
 }

 void updateNumberOTPCallBack(BuildContext context,String smsCode) async{
  try {
    String? number = Provider.of<EditProfileProvider>(context,listen: false).newNumber;
    Map<String,dynamic> data;
    if(number!=null){
      data = {'phone_number': number};
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);
      await _authInstance.currentUser!.updatePhoneNumber(credential);
      // update database
      await FirebaseDatabase.updateUserDetails(data: data, uid: _authInstance.currentUser!.uid);
      _authInstance.currentUser!.reload();
      Fluttertoast.showToast(msg: 'updated phone');
      //close previous pages
      if(context.mounted){
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushNamed(context, authHandlerScreen);
      }
    }
  } on FirebaseAuthException catch (exception) {
    if (!context.mounted) return;
    Navigator.pop(context);
    Fluttertoast.showToast(msg: '${exception.message}');
  }
}

 //***** Change Password *********//

 void changePassword(BuildContext context,String newPassword) async{
   try {
     //reauthenticate user
     bool isAuthenticated = await Navigator.pushNamed(context, loginScreenReauthenticate) as bool;
     //update number
     if(isAuthenticated){
       if(context.mounted){
         _updatePassword(context, newPassword);
       }
     }
   } on FirebaseAuthException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }

 }

 void _updatePassword(BuildContext context,String newPassword) async {
   try {
     await _authInstance.currentUser!.updatePassword(newPassword);
     _authInstance.currentUser!.reload();
     _authInstance.signOut();
     // pop reauthenticate progress indicator
     if(context.mounted){
       Fluttertoast.showToast(msg: 'updated password');
       Navigator.popUntil(context, ModalRoute.withName('/'));
       Navigator.pushNamed(context, authHandlerScreen);
     }

   } on FirebaseException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

//reauthenticate methods
 void reauthenticateEmailPassword(BuildContext context, String email,String password) async{
   try {
     AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: password);
     UserCredential credential = await _authInstance.currentUser!.reauthenticateWithCredential(authCredential);
     if(credential.user!=null){
       if(context.mounted){
         Navigator.pop(context);//progress view
         Navigator.pop(context,true);
         // Navigator.pop(context);// edit profile screen
         // Navigator.pop(context);// profile screen
         // Navigator.pop(context);// drawer
       }
     }
   } on FirebaseAuthException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }

 void reauthenticatePhone(BuildContext context,String number){
   sendOTPCode(context: context, number: number,isReauthenticate: true);
 }

 void reauthenticatePhoneCredential(BuildContext context,String smsCode) {
   try{
     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationID!, smsCode: smsCode);
     if(currentUser!=null){
       currentUser!.reauthenticateWithCredential(credential);
       currentUser!.reload();
       if(context.mounted){
         Navigator.pop(context); //otp progress screen
         Navigator.pop(context);  //otp screen
         Navigator.pop(context); //progress view screen
         Navigator.pop(context,true);  //reauthenticate screen
       }
     }
   } on FirebaseAuthException catch (exception) {
     if (!context.mounted) return;
     Navigator.pop(context);
     Fluttertoast.showToast(msg: '${exception.message}');
   }
 }




}
