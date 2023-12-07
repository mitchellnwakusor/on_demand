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
        late Widget tempScreen;
        late Widget secondScreen;
        switch (user.hasData) {
          case true:
            //links email+password credential to currentUser if email is empty
            if (user.data!.email == null || user.data!.email!.isEmpty) {
              var email = Provider.of<SignupProvider>(context)
                  .signupPersonalData['email'];
              var password = Provider.of<SignupProvider>(context)
                  .signupPersonalData['password'];
              Authentication.instance.linkEmailCredential(email, password);
            }

            screen = FutureBuilder(
                future:
                    FirebaseDatabase.businessDetailExist(uid: user.data!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == false) {
                      print(snapshot.data);
                      tempScreen = const BusinessDetailScreen();
                    } else if (snapshot.data == true) {
                      tempScreen = FutureBuilder(
                          future: FirebaseDatabase.verificationDetailExist(
                              uid: user.data!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == false) {
                                //
                                secondScreen = const DocumentUploadScreen();
                              } else if (snapshot.data == true) {
                                if (!user.data!.emailVerified) {
                                  secondScreen = const EmailVerificationScreen();
                                } else {
                                  return Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                      },
                                      child: const Text('Log out'),
                                    ),
                                  );
                                }
                              }
                            }
                            return secondScreen;
                          });
                    }
                  }
                  return tempScreen;
                });

            // screen = FutureBuilder(future: FirebaseDatabase.verificationDetailExist(uid: user.data!.uid), builder: (context,snapshot){
            //   if(snapshot.hasData){
            //     if(snapshot.data==false){
            //       tempScreen = const DocumentUploadScreen();
            //     }
            //   }
            //   return tempScreen;
            // });
            // // FirebaseDatabase.businessDetailExist(uid: user.data!.uid).then((exists) {
            // //   print('future started 01');
            // //   if(!exists){
            // //     screen = const BusinessDetailScreen();
            // //     return screen;
            // //   }
            // // });
            // // print('start verification check');
            // //
            // // FirebaseDatabase.verificationDetailExist(uid: user.data!.uid).then((exists) {
            // //   print('future started 02');
            // //   if(exists){
            // //     screen = const DocumentUploadScreen();
            // //     return screen;
            // //   }
            // // });
            // if(!user.data!.emailVerified){
            //   screen = const EmailVerificationScreen();
            // }
            // else{
            //   screen = Center(child: ElevatedButton(onPressed: (){FirebaseAuth.instance.signOut();},child: const Text('Log out'),),);
            // }

            // or
            // check if user has business details
            // void check() async{
            //   if(!await FirebaseDatabase.businessDetailExist(uid: user.data!.uid)){
            //     screen = const BusinessDetailScreen();
            //   }
            //   else if(!await FirebaseDatabase.verificationDetailExist(uid: user.data!.uid)){
            //     screen = const DocumentUploadScreen();
            //   }
            //   else {
            //     screen = Center(child: ElevatedButton(onPressed: (){FirebaseAuth.instance.signOut();},child: const Text('Log out'),),);
            //   }
            // }
            // check();
            // TODO: Home screen
            // screen = Center(child: ElevatedButton(onPressed: (){FirebaseAuth.instance.signOut();},child: const Text('Log out'),),);

            return screen;
          case false:
            screen = const AccountSelectionScreen();
            return screen;
        }
      },
    );
  }
}
