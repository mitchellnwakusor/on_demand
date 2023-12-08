import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/UI/Screens/business_detail_screen.dart';
import 'package:on_demand/UI/Screens/document_upload_screen.dart';
import 'package:on_demand/UI/Screens/email_verification_screen.dart';
import 'package:provider/provider.dart';
import '../UI/Screens/account_selection_screen.dart';
import '../Services/authentication.dart';

class AuthenticationHandler extends StatefulWidget {
  const AuthenticationHandler({super.key});
  static const id = 'authentication_handler_screen';

  @override
  State<AuthenticationHandler> createState() => _AuthenticationHandlerState();
}

class _AuthenticationHandlerState extends State<AuthenticationHandler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listens for firebase auth user events
      stream: Authentication.instance.authChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        //routing conditions
        //- if user is logged in
        //- if user is logged out
        late Widget screen;
        switch (user.hasData) {
          case true:
            //links email+password credential to currentUser if email is empty
            if (user.data!.email == null || user.data!.email!.isEmpty) {
              var email = Provider.of<SignupProvider>(context)
                  .signupPersonalData['email'];
              var password = Provider.of<SignupProvider>(context)
                  .signupPersonalData['password'];
              Authentication.instance.linkEmailCredential(email, password);
              // save user details
              Map<String,dynamic> data = Provider.of<SignupProvider>(context,listen: false).signupPersonalData;
              data.remove('password');
              FirebaseDatabase.saveSignUpDetails(data: data, uid: user.data!.uid);
            }

            screen = FutureBuilder(
                future:
                    FirebaseDatabase.businessDetailExist(uid: user.data!.uid),
                builder: (context, snapshot) {
                  Widget? tempScreen;
                  if (snapshot.hasData) {
                    if (snapshot.data == false) {
                      print('business detail ${snapshot.data}');
                      tempScreen = const BusinessDetailScreen();
                    } else if (snapshot.data == true) {
                      print('business detail ${snapshot.data}');
                      tempScreen = FutureBuilder(
                          future: FirebaseDatabase.verificationDetailExist(
                              uid: user.data!.uid),
                          builder: (context, snapshot) {
                            Widget? secondScreen;
                            if (snapshot.hasData) {
                              print('${snapshot.data}');
                              if (snapshot.data == false) {
                                print('verification detail ${snapshot.data}');
                                secondScreen = const DocumentUploadScreen();
                              } else {
                                print('verification detail ${snapshot.data}');
                                if (!user.data!.emailVerified ) {
                                  secondScreen = const EmailVerificationScreen();
                                } else {
                                  secondScreen = Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                      },
                                      child: const Text('Log out'),
                                    ),
                                  );
                                }

                                //check if user detail has been stored instead
                              }
                            }
                            return secondScreen ?? const Center(child: CircularProgressIndicator(),);
                          });
                    }
                  }
                  return tempScreen ?? const Center(child: CircularProgressIndicator(),);
                });
            return screen;
          case false:
            screen = const AccountSelectionScreen();
            return screen;
        }
      },
    );
  }
}
