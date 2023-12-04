import 'package:blurry/blurry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Core/routes.dart';


class PhoneTextScreen extends StatefulWidget {
  const PhoneTextScreen({super.key});
  static const id = 'phone_text_screen';

  @override
  State<PhoneTextScreen> createState() => _PhoneTextScreenState();

}



class _PhoneTextScreenState extends State<PhoneTextScreen> {

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        // title: const Text('Create an account'),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, registerScreen),
            child: const Text(
              'Register',
            ),
          ),
        ],
      ),
      body: AuthFlowBuilder<PhoneAuthController>(
        listener: (oldState, newState, controller) {

          if (newState is PhoneVerified) {
            Navigator.of(context).pushReplacementNamed('/profile');
          }
        },
        builder: (context, state, ctrl, child) {
          if (state is AwaitingPhoneNumber || state is SMSCodeRequested) {
            return PhoneInput(
              initialCountryCode: 'NG',
              onSubmit: (phoneNumber) async {

                final query =  await FirebaseFirestore.instance.collection
                  ('user detail').where('phone_number', isEqualTo: phoneNumber).get();

                if(query.docs.isEmpty==false){
                  Fluttertoast.showToast(msg: "phone number is already registered.");
                }
              else{ctrl.acceptPhoneNumber(phoneNumber);}

              },
            );
          } else if (state is SMSCodeSent) {
            return SMSCodeInput(onSubmit: (smsCode) {
              ctrl.verifySMSCode(
                smsCode,
                verificationId: state.verificationId,
                confirmationResult: state.confirmationResult,
              );
            }
            );
          } else if (state is SigningIn) {
            return const CircularProgressIndicator();
          } else if (state is AuthFailed) {
            return Blurry.error(
                title:  'Timed out',
                description: 'The Authentication Took too long',
                confirmButtonText:  'Retry',
                onConfirmButtonPressed: () {
                  Navigator.pushReplacementNamed(context, phoneTextScreen);
                });
          } else {
            return Text('Unknown state $state');
          }
        },
      ),
    );
  }
}






