import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/error_handler.dart';
import 'package:on_demand/registration_methods.dart';
import 'package:on_demand/text_field.dart';

class FirebaseAuthServices {
  //Singleton instance
  static FirebaseAuthServices instance = FirebaseAuthServices._init();
  FirebaseAuthServices._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  String? get currentUserUID{
    return _auth.currentUser?.uid;
  }

  int? _forceResendingToken;
  String _verificationId = '';

  Future<void> phoneNumberSignupWithNavigation(String phoneNumber,Map<String,dynamic>? data,BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+234$phoneNumber',
      forceResendingToken: _forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // create user with credential - in the case of phone number, sign-up is sign-in
        //wrap in error handler
        ErrorHandler().authCheckMethod(() async {
         UserCredential userCredential = await _auth.signInWithCredential(credential);
         User? user = userCredential.user;
         if(user!=null){
           if(context.mounted){
             HelperMethod.dbStoreUser(context);
             HelperMethod.dbStoreUserDetail(data!,context);
           }
         }
        }, context);
      },
      verificationFailed: (FirebaseAuthException exception) {
        //call error handler
        ErrorHandler().authDisplayError(exception, context);
      },
      codeSent: (String verificationID, int? forceResendingToken) {
        //navigate to otp input screen with arguments or(and) set values
        _forceResendingToken = forceResendingToken;
        _verificationId = verificationID;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return OTP(data: data,);
        }));
      },
      codeAutoRetrievalTimeout: (String verificationID) {

      },
    );
  }

  Future<User?> verifySMSCode(String smsCode,BuildContext context) async {
    try {
      //get credential from verificationId and smsCode then sign in
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (exception) {
      //call error handler
      ErrorHandler().authDisplayError(exception, context);
      return null;
    }
  }


}


class OTP extends StatefulWidget {
  const OTP({super.key,this.data});
  final Map<String,dynamic>? data;
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(controller: controller, type: TextFieldType.number),
              ElevatedButton(onPressed: ()=> HelperMethod.registerArtisanUser(controller.text, widget.data!, context), child: const Text('Verify code'))
            ],
          ),
        ),
      ),
    );
  }
}


