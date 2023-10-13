import 'package:flutter/material.dart';
import 'package:on_demand/firebase_authentication.dart';

class HelperMethod {

 static void registerArtisanPhoneNumber(String phoneNumber,BuildContext context) async {
    await FirebaseAuthServices.instance.phoneNumberSignupWithNavigation(phoneNumber, context);
  }

 static void verifyArtisanPhoneNumber(String smsCode,BuildContext context) async {
   await FirebaseAuthServices.instance.verifySMSCode(smsCode, context);
 }
}

