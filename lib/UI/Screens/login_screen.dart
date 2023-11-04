import 'package:flutter/material.dart';
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
                  'Login to your account',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, registerScreen),
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
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
                      controller: phoneField,
                      type: TextFieldType.phone,
                      label: 'Phone number',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(onPressed: (){}, child: const Text('Trouble logging in?'))
                  ],
                ),
              ),
              const SizedBox(height: 48,),
              ElevatedButton(
                  onPressed: () {}, child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
