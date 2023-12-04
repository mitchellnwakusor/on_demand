import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:provider/provider.dart';

import '../../Utilities/constants.dart';
import '../Components/page_indicator.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});
  static const id = 'otp_verification_screen';

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String phoneNumber = '8112345678';
  TextEditingController smsField = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _continueCallback() {
    if(formKey.currentState!.validate()){
      Authentication.instance.phoneSignIn(context,smsField.text);
    }
  }

  void _resendCodeCallback() {
    Authentication.instance.resendOTPCode(context, phoneNumber);
  }
  @override
  void dispose() {
    smsField.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    phoneNumber = Provider.of<SignupProvider>(context,listen: false).signupPersonalData['phone_number'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width/2.75,
        leading: const PageIndicator(activeScreenIndex: 1,steps: 4,),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Verify code',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ))),
      ),
      body: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'Enter the one-time verification code sent to +234$phoneNumber',
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.5,
                        height: 1.4
                      ),
                    ),
                    const SizedBox(height: 24,),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '______',
                        hintStyle: TextStyle(
                          letterSpacing: 8
                        ),
                        filled: true,
                      ),
                      controller: smsField,
                      validator: (value){
                        if(value==null){
                          return 'OTP Code is required.';
                        }
                        return null;
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6,maxLengthEnforcement: MaxLengthEnforcement.enforced)
                      ],
                    ),
                    const SizedBox(height: 24,),
                    TextButton(onPressed: _resendCodeCallback, child: const Text('Resend code?'))
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: _continueCallback, child: const Text('Continue'))
          ],
        ),
      ),
    );
  }
}
