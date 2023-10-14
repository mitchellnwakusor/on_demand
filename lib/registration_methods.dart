import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/firebase_authentication.dart';
import 'package:on_demand/firebase_database.dart';

class HelperMethod {

  static final FirebaseAuthServices _authServices = FirebaseAuthServices.instance;
  static final FirestoreCloudServices _cloudServices = FirestoreCloudServices.instance;

 static void registerArtisanPhoneNumber(String phoneNumber,BuildContext context) async {
    await _authServices.phoneNumberSignupWithNavigation(phoneNumber, context);
  }

 static void registerArtisanUser(String smsCode,String firstName,String lastName,String email,String phoneNumber,DateTime date,BuildContext context) async{
    User? user = await _authServices.verifySMSCode(smsCode, context);
    if(user!=null){
      if(context.mounted){
        dbStoreUser(context);
        dbStoreUserDetail(firstName, lastName, email, phoneNumber, date, context);
      }
    }
 }

 static void dbStoreUser(BuildContext context) async {
   await _cloudServices.createUserDocument(context);
 }

 static void dbStoreUserDetail(String firstName,String lastName,String email,String phoneNumber,DateTime date,BuildContext context) async {
   Map<String,dynamic> data = {
     'first_name': firstName,
     'last_name': lastName,
     'email': email,
     'phone_number': phoneNumber,
     'date_of_reg': date,
   };
   await _cloudServices.createUserDetailDocument(data, context);
 }

}

