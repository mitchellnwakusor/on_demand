import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/UI/Components/text_field.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  bool isEmailPasswordSignIn = true;

  void toggleSignInMethod () {
    setState(() {
      isEmailPasswordSignIn = !isEmailPasswordSignIn;
    });
  }

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
                  'Welcome back, ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ))),
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
      body: const Padding(
        padding: kMobileBodyPadding,
        child: SingleChildScrollView(
          child: CustomLoginView()
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Form(
          //       key: formKey,
          //       child: isEmailPasswordSignIn
          //           ? EmailPasswordSignIn(
          //               emailField: emailField, passwordField: passwordField,toggleSignInMethodCallback: toggleSignInMethod,)
          //           : PhoneSignIn(phoneField: phoneField,toggleSignInMethodCallback: toggleSignInMethod,),
          //     ),
          //     const SizedBox(
          //       height: 48,
          //     ),
          //     ElevatedButton(onPressed: () {}, child: const Text('Continue')),
          //     const ThirdPartyCredentials(),
          //   ],
          // ),
        ),
      ),
    );
  }
}

class EmailPasswordSignIn extends StatelessWidget {
  const EmailPasswordSignIn({
    super.key,
    required this.emailField,
    required this.passwordField,
    required this.toggleSignInMethodCallback
  });

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
            TextButton(onPressed: toggleSignInMethodCallback, child: const Text('Use phone number')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, resetPasswordScreen);
                }, child: const Text('Trouble logging in?')),
          ],
        )
      ],
    );
  }
}

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({super.key, required this.phoneField,required this.toggleSignInMethodCallback});
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
            TextButton(onPressed: toggleSignInMethodCallback, child: const Text('Use password')),
            TextButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: "Send an email to support@ondemand.com",toastLength: Toast.LENGTH_LONG);
                }, child: const Text('Trouble logging in?')),
          ],
        )
      ],
    );
  }
}

//** Custom Widgets **//
class ThirdPartyCredentials extends StatelessWidget {
  const ThirdPartyCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Column(
        //   children: [
        //     Divider(height: 48,indent: 16,endIndent: 16,thickness: 1,),
        //     Text('OR',textAlign: TextAlign.center,),
        //   ],
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 1,
                      color: Colors.black45,
                    )),
                const Expanded(
                    child: Text(
                  'OR',
                  textAlign: TextAlign.center,
                )),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 1,
                      color: Colors.black45,
                    )),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            OutlinedButton(
                onPressed: () {}, child: const Text('Continue with Google')),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
                onPressed: () {}, child: const Text('Continue with Facebook')),
          ],
        ),
      ],
    );
  }
}

class CustomLoginView extends StatelessWidget {
  const CustomLoginView({super.key});
  final clientID = "255036669928-5b9foj1hssbr0gpjrsuptrn5s6rl2asu.apps.googleusercontent.com";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: kMobileBodyPadding,
        child: LoginView(
          showAuthActionSwitch: false,
          showTitle: false,
          action: AuthAction.signIn,
          providers: [
            EmailAuthProvider(),
            PhoneAuthProvider(),
            GoogleProvider(clientId: clientID),
            FacebookProvider(clientId: clientID),
          ],
        ),
    );
  }
}
