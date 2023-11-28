import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/UI/Components/page_indicator.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/UI/Components/text_field.dart';
import 'package:provider/provider.dart';

import '../../Services/providers/signup_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  const RegisterScreen({super.key});

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


  void _saveDetails() async {
    if(formKey.currentState!.validate()){
      //Todo internet connection check
      bool doesUserExists = await FirebaseDatabase.userExists(phoneField.text, emailField.text);
      if(!doesUserExists){
        //save data
        if(context.mounted){
          Provider.of<SignupProvider>(context,listen: false).addMultipleData(firstName: fNameField.text, lastName: lNameField.text, email: emailField.text, phoneNumber: phoneField.text,);
          Navigator.pushNamed(context, businessDetailScreen);
        }
      }
      else{
        Fluttertoast.showToast(msg: "phone number or email address is already in use.");
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
                    onPressed: _saveDetails, child: const Text('Continue'),),
                  // const SizedBox(
                  //   height: 24,
                  // ),
                  const ThirdPartyCredentials(),
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
            const SizedBox(height: 24,),
            Row(
              children: [
                Expanded(flex: 2,child: Container(height: 1,color: Colors.black45,)),
                const Expanded(child: Text('OR',textAlign: TextAlign.center,)),
                Expanded(flex: 2,child: Container(height: 1,color: Colors.black45,)),
              ],
            ),
            const SizedBox(height: 24,),
            OutlinedButton(onPressed: (){}, child: const Text('Continue with Google')),
            const SizedBox(height: 16,),
            OutlinedButton(onPressed: (){}, child: const Text('Continue with Facebook')),
          ],
        ),
      ],
    );
  }
}

