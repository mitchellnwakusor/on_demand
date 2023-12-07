import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Core/authentication_handler.dart';
import 'package:on_demand/Core/ids.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/UI/Components/oauth_divider.dart';
import 'package:on_demand/UI/Components/terms_conditions.dart';
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
          child: CustomLoginScreen(),
        ),
      ),
    );
  }
}


//** Custom Widgets **//
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

// class CustomLoginView extends StatelessWidget {
//   const CustomLoginView({super.key});
//   final clientID =
//       "255036669928-5b9foj1hssbr0gpjrsuptrn5s6rl2asu.apps.googleusercontent.com";
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: kMobileBodyPadding,
//       child: LoginView(
//         showAuthActionSwitch: false,
//         subtitleBuilder: (context, action) {
//           return TextButton(
//               onPressed: () {},
//               child: const Text(
//                 'Sign in with phone number',
//                 style: TextStyle(color: Colors.red),
//               ));
//         },
//         showTitle: true,
//         action: AuthAction.signIn,
//         providers: [
//           EmailAuthProvider(),
//           GoogleProvider(clientId: clientID),
//           FacebookProvider(clientId: clientID),
//         ],
//       ),
//     );
//   }
// }


class LoginScreenForm extends StatefulWidget {
  const LoginScreenForm({super.key, required this.ctrl});
  final PhoneAuthController ctrl;

  @override
  State<LoginScreenForm> createState() => _LoginScreenFormState();
}

class _LoginScreenFormState extends State<LoginScreenForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  bool isEmailPasswordSignIn = false;

  void toggleSignInMethod() {
    setState(() {
      isEmailPasswordSignIn = !isEmailPasswordSignIn;
    });
  }

  void emailSignIn() async {
    await widget.ctrl.auth.signInWithEmailAndPassword(
        email: emailField.text, password: passwordField.text);
  }

  void _signIn() async {
    if (formKey.currentState!.validate()) {
      try {
        bool doesUserExists =
            await FirebaseDatabase.userExists(
                "+234${phoneField.text}", emailField.text)
                .timeout(const Duration(seconds: 5));
        if (doesUserExists) {
          //sign in
          if (context.mounted) {
            switch (isEmailPasswordSignIn) {
              case true:
                emailSignIn();
                break;
              case false:
                widget.ctrl.acceptPhoneNumber("+234${phoneField.text}");
                break;
            }
          }
        } else {
          Fluttertoast.showToast(
              msg:
                  "There is no phone number or email address registered with an account.");
        }
      } on Exception {
        Fluttertoast.showToast(
            msg: "No internet connection, please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ElevatedButton(onPressed: _signIn, child: const Text('Continue')),
      ],
    );
  }
}

class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  String? get phoneTextScreen => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 24,),
        LoginView(
          action: AuthAction.signUp,
          showTitle: false,
          showAuthActionSwitch: false,
          providers: [
            EmailAuthProvider(),
          ],
        ),
        //const CustomLoginView(),
        const SizedBox(height: 48,),
        const OauthDivider(),
        const SizedBox(height: 48,),
        LoginView(
          action: AuthAction.signUp,
          showTitle: false,
          showAuthActionSwitch: false,
          providers: [
            GoogleProvider(clientId: clientID),
            FacebookProvider(clientId: clientID),
          ],
        ),
        TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, phoneTextScreen!),
          child: const Text(
            'Singin With Phone',
          ),
        ),
        const SizedBox(height: 24,),
        const TermsAndConditions(),
      ],
    );

  }
}

class CustomLoginView extends StatelessWidget {
  const CustomLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder<PhoneAuthController>(
      //Todo replace each return with the registerScreenForm and also navigate to the appropriate widget
      listener: (oldState, newState, controller) {
        if (newState is PhoneVerified) {
          // controller.auth.signInWithCredential(newState.credential);
          //Todo push/pop to authHandler (homeScreen)
          Navigator.pop(context);
          // Navigator.of(context).pushReplacementNamed(homeScreen);
        }
      },
      builder: (context, state, ctrl, child) {
        if (state is AwaitingPhoneNumber || state is SMSCodeRequested) {
          //Custom form
          return LoginScreenForm(
            ctrl: ctrl,
          );
        } else if (state is SMSCodeSent) {
          //Navigate to smscodeinput instead
          return SMSCodeInput(onSubmit: (smsCode) {
            ctrl.verifySMSCode(
              smsCode,
              verificationId: state.verificationId,
              confirmationResult: state.confirmationResult,
            );
          });
        } else if (state is SigningIn) {
          return const CircularProgressIndicator();
        }
        // added state
        else if (state is SignedIn) {
            return const AuthenticationHandler();
        }
         else if (state is AuthFailed) {
          return ErrorText(exception: state.exception);
        } else {
          return Text('Unknown state $state');
        }
      },
    );

  }
}
