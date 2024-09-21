import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:provider/provider.dart';
import '../../Services/authentication.dart';
import '../../Services/providers/app_theme_provider.dart';
import '../../Services/providers/user_details_provider.dart';
import '../Components/text_field.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  static const id = 'app_settings_screen';


  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {

  late AppTheme appTheme;
  bool tempIsNotificationEnabled = true;

  GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePhoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePasswordFormKey = GlobalKey<FormState>();

  TextEditingController emailField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  String? email ;
  String? phone;


  @override
  void initState() {
    var eMail = Provider.of<UserDetailsProvider>(context,listen: false).email;
    var phoneNumber = Provider.of<UserDetailsProvider>(context,listen: false).phoneNumber;

    email ='$eMail';
    phone = '$phoneNumber';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Customization card
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 16,right: 16,left: 16,top: 8),
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 0,right: 0,top: 8.0),
                    child: Text('Customization',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable dark mode'),
                    subtitle: const Text('Turn dark mode on or off'),
                    trailing: Switch(value: appTheme.isDarkMode, onChanged: (value){
                      appTheme.toggleDarkMode(value);
                    }),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable push notifications'),
                    subtitle: const Text('Allow notifications and alerts'),
                    trailing: Switch(value: tempIsNotificationEnabled, onChanged: (value){setState(() {
                      tempIsNotificationEnabled = value;
                    });}),
                  ),
                ],
              ),
            ),
            //Account card
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 16,right: 16,left: 16),
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 0,right: 0,top: 8.0),
                    child: Text('Account',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Form(
                        key: updateEmailFormKey,
                        child: CustomTextField(
                          controller: emailField,
                          type: TextFieldType.email,
                          label: 'Change email Address',
                          hint: 'New email address',
                          onEditingComplete: () {
                            if(emailField.text.isNotEmpty){
                              if(updateEmailFormKey.currentState!.validate()) {
                                //dismiss keyboard
                                dismissKeyboard();
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: 'Change email address',
                                  desc: 'Are you sure you want to change your email address?',
                                  btnCancelOnPress: (){},
                                  btnOkOnPress: (){
                                    //call update function
                                    Authentication.instance.changeEmailAddress(emailField,context);
                                  },
                                ).show();
                              }
                            }
                          },
                          helperText: 'You will be required to sign in and then verify your new email address.',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: updatePhoneFormKey,
                        child: CustomTextField(
                          controller: phoneField,
                          type: TextFieldType.phone,
                          label: 'Change phone number',
                          hint: 'New number',
                          onEditingComplete: () {
                            if(phoneField.text.isNotEmpty){
                              if(updatePhoneFormKey.currentState!.validate()) {
                                //dismiss keyboard
                                dismissKeyboard();
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: 'Change phone number',
                                  desc: 'Are you sure you want to change your phone number?',
                                  btnCancelOnPress: (){},
                                  btnOkOnPress: (){
                                    //call update function
                                    Authentication.instance.changePhoneNumber(phoneField.text,context);
                                  },
                                ).show();
                              }
                            }
                          },
                          helperText: 'You will be required to sign in and then verify your new phone number.',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: updatePasswordFormKey,
                        child: CustomTextField(
                          controller: passwordField,
                          type: TextFieldType.password,
                          label: 'Change password',
                          hint: 'New password',
                          onEditingComplete: () {
                            if(passwordField.text.isNotEmpty){
                              if(updatePasswordFormKey.currentState!.validate()) {
                                //dismiss keyboard
                                dismissKeyboard();
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: 'Change password',
                                  desc: 'Are you sure you want to change your password?',
                                  btnCancelOnPress: (){},
                                  btnOkOnPress: (){
                                    //call update function
                                    Authentication.instance.changePassword(context,passwordField.text);
                                  },
                                ).show();
                              }
                            }
                          },
                          helperText: 'You will be required to sign in.',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                    ],
                  ),
                ],
              ),
            ),
            //Dev card
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 16,right: 16,left: 16),
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left:0,right: 0,top: 8.0),
                    child: Text('Developer',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Leave feedback'),
                    subtitle: Text('Leave a message on how we can serve you better, or report a bug.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, appFeedbackScreen);
                      // showDialog(context: context, builder: (context){
                      //   return const CustomFeedbackDialog(dialogTitle: 'Leave feedback');
                      // });
                    }, child: const Text('Leave feedback')),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Test Field'),
                    subtitle: const Text('Playground for unit testing'),
                    onTap: ()=>Navigator.pushNamed(context, testField),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

}

