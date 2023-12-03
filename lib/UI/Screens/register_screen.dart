import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/ids.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/UI/Components/page_indicator.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/UI/Components/text_field.dart';
import 'package:provider/provider.dart';

import '../../Services/providers/signup_provider.dart';
import '../Components/oauth_divider.dart';
import '../Components/terms_conditions.dart';


class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width/2.75,
        leading: const PageIndicator(activeScreenIndex: 0,steps: 5,),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Create an Artisan account',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24,),
                ))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, loginScreen),
            child: const Text(
              'Login',
            ),
          ),
        ],
      ),
      body: const RegisterView(),
      // Padding(
      //   padding: kMobileBodyPadding,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         Form(
      //           key: formKey,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               CustomTextField(
      //                 controller: fNameField,
      //                 type: TextFieldType.name,
      //                 label: 'First name',
      //               ),
      //               const SizedBox(
      //                 height: 24,
      //               ),
      //               CustomTextField(
      //                 controller: lNameField,
      //                 type: TextFieldType.name,
      //                 label: 'Last name',
      //               ),
      //               const SizedBox(
      //                 height: 24,
      //               ),
      //               CustomTextField(
      //                 controller: emailField,
      //                 type: TextFieldType.email,
      //                 label: 'Email',
      //               ),
      //               const SizedBox(
      //                 height: 24,
      //               ),
      //               CustomTextField(
      //                 controller: phoneField,
      //                 type: TextFieldType.phone,
      //                 label: 'Phone number',
      //               ),
      //               const SizedBox(
      //                 height: 24,
      //               ),
      //               CustomTextField(
      //                 controller: passwordField,
      //                 type: TextFieldType.password,
      //                 label: 'Password',
      //               ),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(height: 48,),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             ElevatedButton(
      //               onPressed: _saveDetails, child: const Text('Continue'),),
      //             // const SizedBox(
      //             //   height: 24,
      //             // ),
      //             const ThirdPartyCredentials(),
      //           ],
      //         ),
      //         const SizedBox(height: 48,),
      //         RichText(selectionColor: Colors.purple,text: const TextSpan(children: [
      //           TextSpan(text: 'By creating an account you agree to our ',style: TextStyle(color: Colors.black)),
      //           TextSpan(text: 'Terms & Conditions ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
      //           TextSpan(text: 'and our ',style: TextStyle(color: Colors.black)),
      //           TextSpan(text: 'Privacy Policy. ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
      //         ])),
      //
      //       ],
      //     ),
      //   ),
      // ),
      

      // const MyCustomWidget(),

    );
  }
}

//** Custom Widgets **//
class RegisterScreenForm extends StatefulWidget {
  const RegisterScreenForm({super.key,required this.ctrl});
  final PhoneAuthController ctrl;
  @override
  State<RegisterScreenForm> createState() => _RegisterScreenFormState();
}

class _RegisterScreenFormState extends State<RegisterScreenForm> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fNameField = TextEditingController();
  TextEditingController lNameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();


  void _saveDetails() async {
    if(formKey.currentState!.validate()){
      //Todo internet connection check
      try {
        bool doesUserExists = await FirebaseDatabase.userExists(phoneField.text, emailField.text).timeout(const Duration(seconds: 5));
        if(!doesUserExists){
          //save data
          if(context.mounted){
            Provider.of<SignupProvider>(context,listen: false).addMultipleData(firstName: fNameField.text, lastName: lNameField.text, email: emailField.text, phoneNumber: phoneField.text,password: passwordField.text);
            widget.ctrl.acceptPhoneNumber(phoneField.text);
          }
        }
        else{
          Fluttertoast.showToast(msg: "phone number or email address is already in use.");
        }
      } on Exception {
        // TODO
        Fluttertoast.showToast(msg: "No internet connection, please try again.");

      }
    }
  }

  @override
  void dispose() {
    fNameField.dispose();
    lNameField.dispose();
    emailField.dispose();
    phoneField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: fNameField,
                type: TextFieldType.name,
                label: 'First name',
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                controller: lNameField,
                type: TextFieldType.name,
                label: 'Last name',
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                controller: emailField,
                type: TextFieldType.email,
                label: 'Email',
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                controller: phoneField,
                type: TextFieldType.phone,
                label: 'Phone number',
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                controller: passwordField,
                type: TextFieldType.password,
                label: 'Password',
              ),
            ],
          ),
        ),
        const SizedBox(height: 48,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                _saveDetails();
                // widget.ctrl.acceptPhoneNumber(phoneField.text);
              }, child: const Text('Continue'),),
            // const SizedBox(
            //   height: 24,
            // ),
          ],
        ),


      ],
    );
  }
}

class CustomRegisterView extends StatelessWidget {
  const CustomRegisterView({super.key});

  @override
  Widget build(BuildContext context) {

    String? email = Provider.of<SignupProvider>(context).signupPersonalData['email'];
    String? password = Provider.of<SignupProvider>(context).signupPersonalData['password'];

    void linkUserEmailPassword(PhoneAuthController controller) async{
      UserCredential userCredential = await controller.auth.createUserWithEmailAndPassword(email: email!, password: password!);
      if(userCredential.user!=null){
        controller.auth.currentUser?.linkWithCredential(userCredential.credential!);
      }
    }

    return AuthFlowBuilder<PhoneAuthController>(
      listener: (oldState, newState, controller) {
        if (newState is PhoneVerified) {
          // controller.auth.signInWithCredential(newState.credential);
          linkUserEmailPassword(controller);
          //Todo push to authHandler (extra info screen)
          // Navigator.of(context).pushReplacementNamed(homeScreen);
        }
      },
      builder: (context, state, ctrl, child) {
        if (state is AwaitingPhoneNumber || state is SMSCodeRequested) {
          //Custom form
          return RegisterScreenForm(ctrl: ctrl,);

        } else if (state is SMSCodeSent) {
          return SMSCodeInput(onSubmit: (smsCode) {
            ctrl.verifySMSCode(
              smsCode,
              verificationId: state.verificationId,
              confirmationResult: state.confirmationResult,
            );
          });
        } else if (state is SigningIn) {
          return const CircularProgressIndicator();
        } else if (state is AuthFailed) {
          return ErrorText(exception: state.exception);
        } else {
          return Text('Unknown state $state');
        }
      },
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          children: [
            const CustomRegisterView(),
            const SizedBox(height: 48,),
            const OauthDivider(),
            const SizedBox(height: 24,),
            LoginView(
              action: AuthAction.signUp,
              showTitle: false,
              showAuthActionSwitch: false,
              providers: [
                GoogleProvider(clientId: clientID),
                FacebookProvider(clientId: clientID),
              ],
            ),
            const SizedBox(height: 24,),
            const TermsAndConditions(),
          ],
        ),
      ),
    );
  }
}
