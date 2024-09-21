import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/UI/Components/text_field.dart';

import '../Components/progress_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const id = 'reset_password_screen';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailField = TextEditingController();

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        // title: const Text('Create an account'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Reset password',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ))),
      ),
      body: Padding(
        padding: kMobileBodyPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formKey,
                child: CustomTextField(controller: emailField,label: 'Email address', type: TextFieldType.email,)
              ),
              const SizedBox(
                height: 48,
              ),
              ElevatedButton(onPressed: () {
                if(formKey.currentState!.validate()){
                  progressView();
                  Authentication.instance.forgotPassword(context, emailField.text);
                }
              }, child: const Text('Continue')), //Todo: Reset password functionality
            ],
          ),
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
                onPressed: () {}, child: const Text('Trouble logging in?')),
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


