import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firebase_authentication.dart';
import 'firebase_database.dart';
import 'user_data.dart';
import 'package:provider/provider.dart';

class HelperMethod {


  static final FirebaseAuthServices _authServices = FirebaseAuthServices.instance;
  static final FirestoreCloudServices _cloudServices = FirestoreCloudServices.instance;

 // static void sendOTPCode(String phoneNumber,Map<String,dynamic>? data ,BuildContext context) async {
 //   await _authServices.sendCodeWithNavigation(phoneNumber, data, context);
 //  }

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



 static void loginWithPhoneNumber(String phoneNumber, BuildContext context) async {

   Map<String,dynamic>? data;
  final query =  await FirebaseFirestore.instance
      .collection('user detail')
      .where('phone_number', isEqualTo: phoneNumber)
      .get();

  if(query.docs.isEmpty==false){
    Fluttertoast.showToast(msg: "phone number is not Valid.");
  }
  else{
    if(context.mounted){
      data = Provider.of<UserData>(context,listen: false).mapData;
      _authServices.sendCodeWithNavigation(phoneNumber:phoneNumber,data:data,context:context);
    }
  }

  // query.docs.isEmpty == false ?  Fluttertoast.showToast(msg: "phone number is not Valid.") : _authServices.sendCodeWithNavigation(phoneNumber,data,context);

 }

 static void signupWithPhoneNumber(String phoneNumber, BuildContext context) async {

   Map<String,dynamic>? data;
   final query =  await FirebaseFirestore.instance.collection('user detail').where('phone_number', isEqualTo: phoneNumber).get();

   if(query.docs.isEmpty==false){
     Fluttertoast.showToast(msg: "phone number is already registered.");
   }
   else{
     if(context.mounted){
       data = Provider.of<UserData>(context,listen: false).mapData;
       _authServices.sendCodeWithNavigation(phoneNumber:phoneNumber,data: data,context:context);
     }
   }

  }

}

