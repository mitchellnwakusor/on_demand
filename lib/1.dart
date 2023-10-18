import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/error_handler.dart';
import 'package:on_demand/firebase_database.dart';

class FirebaseAuthServices {
  //Singleton instance
  static FirebaseAuthServices instance = FirebaseAuthServices._init();
  FirebaseAuthServices._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int? _resendToken;
  late String _verificationId;

  registerNumber(String phoneNumber,BuildContext context) async{
    void navigate({required BuildContext context, String? route, Widget? widget}){
      if(route!=null&&widget==null){
        Navigator.pushNamed(context, route);
      }
      else if(widget!=null&&route==null){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return widget;
        }));
      }
      else if(widget!=null&&route!=null){
        throw Exception('both route and widget were passed as arguments, use only one');
      }
    }
    await _auth.verifyPhoneNumber(
        phoneNumber: '+234$phoneNumber',
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException exception) => ErrorHandler().authDisplayError(exception, context),
        codeSent: (String verificationId,int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          navigate(context: context);
        },
        codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout){}
    );
  }

  verifyCode(String smsCode,BuildContext context) async{
    String verificationId = _verificationId;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    try{
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      //assuming one code is shared, login and registration can happen from here but registration data will be passed as an argument
      /*
      AdditionalUserInfo? userInfo = userCredential.additionalUserInfo;
      if(userInfo!=null){
        bool newUser = userInfo.isNewUser;
        //if new user, save user info
        if(newUser){
          if(context.mounted){
            FirestoreCloudServices.instance.createUserDocument(context);
            FirestoreCloudServices.instance.createUserDetailDocument(data, context);
          }
        }
        //else do nothing, continue to login
      }
      */
      return userCredential;
    }
    on FirebaseAuthException catch(exception) {
      ErrorHandler().authDisplayError(exception, context);
    }
  }



}



