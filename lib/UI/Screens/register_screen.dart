import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/ids.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/UI/Components/oauth_divider.dart';
import 'package:on_demand/UI/Components/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../../Core/routes.dart';
import '../../Services/firebase_database.dart';
import '../../Services/providers/signup_provider.dart';
import '../../Services/providers/start_screen_provider.dart';
import '../../Utilities/constants.dart';
import '../Components/page_indicator.dart';
import '../Components/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fNameField = TextEditingController();
  TextEditingController lNameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  late BuildContext dialogContext;

  void progressView() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const ProgressDialog(message: "Processing, Please wait...",);
      },
    );

  }

  void _continueCallback() async {
    if(formKey.currentState!.validate()){
      progressView();
      //Todo internet connection check
      try {
        UserType? userType = Provider.of<StartScreenProvider>(context,listen: false).userType;
        bool doesUserExists = await FirebaseDatabase.userExists(phoneField.text, emailField.text).timeout(const Duration(seconds: 5));
        if(!doesUserExists){
          if(context.mounted){
            //save data in provider for later use
            Provider.of<SignupProvider>(context,listen: false).addMultipleDataSignup(firstName: fNameField.text, lastName: lNameField.text, email: emailField.text, phoneNumber: phoneField.text,password: passwordField.text,userType: userType?.name);
            //start phone authentication process
            Authentication.instance.sendOTPCode(context:context,number:phoneField.text);
          }
        }
        else{
          if (!mounted) return;
          Navigator.pop(dialogContext);
          Fluttertoast.showToast(msg: "phone number or email address is already in use.");
        }
      } on Exception {
        if (!mounted) return;
        Navigator.pop(dialogContext);
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
                  'Create an account',
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
      body: Padding(
        padding: kMobileBodyPadding,
        child: SingleChildScrollView(
          child: Column(
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
                    onPressed: _continueCallback, child: const Text('Continue'),
                  ),
                  const SizedBox(height: 24,),
                  const OauthDivider(),
                  const SizedBox(height: 24,),
                  const CustomOauthCredentials()
                  // const SizedBox(
                  //   height: 24,
                  // ),
                  // const ThirdPartyCredentials(),
                ],
              ),
              const SizedBox(height: 48,),
              RichText(selectionColor: Colors.purple,text: const TextSpan(children: [
                TextSpan(text: 'By creating an account you agree to our ',style: TextStyle(color: Colors.black)),
                TextSpan(text: 'Terms & Conditions ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
                TextSpan(text: 'and our ',style: TextStyle(color: Colors.black)),
                TextSpan(text: 'Privacy Policy. ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
              ])),

            ],
          ),
        ),
      ),
    );
  }
}

class CustomOauthCredentials extends StatelessWidget {
  const CustomOauthCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginView(
      showAuthActionSwitch: false,
      showTitle: false,
      action: AuthAction.signUp,
      providers: [
        GoogleProvider(clientId: clientID),
        FacebookProvider(clientId: clientID),
      ],
    );
  }
}
