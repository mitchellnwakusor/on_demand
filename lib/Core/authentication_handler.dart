import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/UI/Screens/business_detail_screen.dart';
import 'package:on_demand/UI/Screens/document_upload_screen.dart';
import 'package:provider/provider.dart';
import '../UI/Screens/account_selection_screen.dart';
import '../Services/authentication.dart';

class AuthenticationHandler extends StatefulWidget {
  const AuthenticationHandler({super.key});

  @override
  State<AuthenticationHandler> createState() => _AuthenticationHandlerState();
}

class _AuthenticationHandlerState extends State<AuthenticationHandler> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
      //listens for firebase auth user events
      stream: Authentication.instance.authChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        //routing conditions
        //- if user is logged in
        //- if user is logged out
        late Widget screen;
        switch(user.hasData) {
          case true:
            //links email+password credential to currentUser if email is empty
            if(user.data!.email == null || user.data!.email!.isEmpty){
              var email = Provider.of<SignupProvider>(context).signupPersonalData['email'];
              var password = Provider.of<SignupProvider>(context).signupPersonalData['password'];
              Authentication.instance.linkEmailCredential(email, password);
            }
            //check if user has business details
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
            //TODO: Home screen
            screen = Center(child: ElevatedButton(onPressed: (){FirebaseAuth.instance.signOut();},child: const Text('Log out'),),);
            return screen;
          case false:
            screen = const AccountSelectionScreen();
            return screen;
        }
      },
    );
  }
}
