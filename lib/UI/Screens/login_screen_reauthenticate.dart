import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/providers/user_details_provider.dart';
import 'package:on_demand/UI/Components/oauth_divider.dart';
import 'package:on_demand/UI/Components/progress_dialog.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:provider/provider.dart';
import '../../Core/ids.dart';
import '../../Core/routes.dart';
import '../../Services/firebase_database.dart';
import '../../Services/providers/signup_provider.dart';
import '../Components/text_field.dart';

class LoginScreenReauthenticate extends StatefulWidget {
  const LoginScreenReauthenticate({super.key});
  static const id = 'login_screen_reauthenticate';

  @override
  State<LoginScreenReauthenticate> createState() => _LoginScreenReauthenticateState();
}

class _LoginScreenReauthenticateState extends State<LoginScreenReauthenticate> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  bool isEmailPasswordSignIn = false;

  // late bool? isChangeEmail;
  // late bool? isChangeNumber;

  void toggleSignInMethod() {
    setState(() {
      isEmailPasswordSignIn = !isEmailPasswordSignIn;
    });
  }

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

  void _signIn() async {
    if (formKey.currentState!.validate()) {
      progressView();
      try {
        String userType = Provider.of<UserDetailsProvider>(context,listen: false).userType;
        bool doesUserTypeExists =
        await FirebaseDatabase.userTypeExists(phoneField.text, emailField.text, userType).timeout(const Duration(seconds: 5));
        if (doesUserTypeExists) {
          //sign in
          if (context.mounted) {
            //save phone number in provider, specifically for use by otp screen
            Provider.of<SignupProvider>(context,listen: false).addDataSignup(key: 'phone_number', value: phoneField.text);
            switch (isEmailPasswordSignIn) {
              case true:
            Authentication.instance.reauthenticateEmailPassword(context, emailField.text, passwordField.text);
                break;
              case false:
                Authentication.instance.reauthenticatePhone(context,phoneField.text);
                break;
            }
          }
        } else {
          if (!mounted) return;
          Navigator.pop(dialogContext);

          Fluttertoast.showToast(
              msg:
              "There is no phone number or email address registered with an account."
          );

        }
      } on Exception {
        if (!mounted) return;
        Navigator.pop(dialogContext);
        Fluttertoast.showToast(
            msg: "No internet connection, please try again.");
      }
    }
  }

  // @override
  // void didChangeDependencies() {
  //   List<bool?> args = ModalRoute.of(context)!.settings.arguments as List<bool?>;
  //   isChangeEmail = args[0];
  //   isChangeNumber = args[1];
  //   super.didChangeDependencies();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        // title: const Text('Create an account'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Log in to your account, ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kMobileBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formKey,
                child: isEmailPasswordSignIn
                    ? EmailPasswordSignIn(
                  emailField: emailField,
                  passwordField: passwordField,
                  toggleSignInMethodCallback: toggleSignInMethod,
                )
                    : PhoneSignIn(
                  phoneField: phoneField,
                  toggleSignInMethodCallback: toggleSignInMethod,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              ElevatedButton(onPressed:(){
                _signIn();
              },
                child: const Text('Continue'),

              ),
              const SizedBox(
                height: 48,
              ),
              const OauthDivider(),
              const SizedBox(
                height: 48,
              ),
              const CustomOauthCredentials(),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPasswordSignIn extends StatelessWidget {
  const EmailPasswordSignIn(
      {super.key,
        required this.emailField,
        required this.passwordField,
        required this.toggleSignInMethodCallback});

  final TextEditingController emailField;
  final TextEditingController passwordField;
  final void Function()? toggleSignInMethodCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CustomTextField(
              controller: emailField,
              type: TextFieldType.email,
              label: 'Email address',
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              controller: passwordField,
              type: TextFieldType.password,
              label: 'Password',
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: toggleSignInMethodCallback,
                child: const Text('Use phone number')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, resetPasswordScreen);
                },
                child: const Text('Trouble logging in?')),
          ],
        )
      ],
    );
  }
}

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn(
      {super.key,
        required this.phoneField,
        required this.toggleSignInMethodCallback});
  final TextEditingController phoneField;
  final void Function()? toggleSignInMethodCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: phoneField,
          type: TextFieldType.phone,
          label: 'Enter phone number',
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: toggleSignInMethodCallback,
                child: const Text('Use password')),
            TextButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Send an email to support@ondemand.com",
                      toastLength: Toast.LENGTH_LONG);
                },
                child: const Text('Trouble logging in?')),
          ],
        )
      ],
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