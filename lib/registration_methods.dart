import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/firebase_authentication.dart';
import 'package:on_demand/firebase_database.dart';

class HelperMethod {

  static final FirebaseAuthServices _authServices = FirebaseAuthServices.instance;
  static final FirestoreCloudServices _cloudServices = FirestoreCloudServices.instance;

 static void registerArtisanPhoneNumber(String phoneNumber,Map<String,dynamic>? data ,BuildContext context) async {
    await _authServices.phoneNumberSignupWithNavigation(phoneNumber, data, context);
  }

 static void registerArtisanUser(String smsCode,Map<String,dynamic> data,BuildContext context) async{
    User? user = await _authServices.verifySMSCode(smsCode, context);
    if(user!=null){
      if(context.mounted){
        dbStoreUser(context);
        dbStoreUserDetail(data, context);
      }
    }
 }

 static void dbStoreUser(BuildContext context) async {
   await _cloudServices.createUserDocument(context);
 }

 static void dbStoreUserDetail(Map<String,dynamic> data,BuildContext context) async {
   await _cloudServices.createUserDetailDocument(data, context);
 }

}

