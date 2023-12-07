import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  User? user = Authentication.instance.currentUser;
  late bool isVerified;

  late Timer checkVerificationTimer;

  void initVerification() {
    checkVerificationTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) {
          checkVerification(user!);
        });
  }
  void checkVerification(User user,) {
    user.reload();
    if(user.emailVerified){
      //save details
      Map<String,dynamic> data = Provider.of<SignupProvider>(context).signupPersonalData;
      FirebaseDatabase.saveSignUpDetails(data: data, uid: user.uid);
      checkVerificationTimer.cancel();
    }
  }
  @override
  void initState() {
    // initVerification();
    super.initState();
  }

  @override
  void dispose() {
    checkVerificationTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verify your email address'),
            const SizedBox(height:48),
            const Text('A verification link was sent to your address, .Check your inbox or spam folder and confirm your account by tapping the link. '),
            const SizedBox(height:48),
            Center(child: TextButton(onPressed: (){}, child: const Text('resend verification link')))
          ],
        ),
      ),
    );
  }
}
