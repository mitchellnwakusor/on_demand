import 'package:flutter/material.dart';
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
    return StreamBuilder(
      //listens for firebase auth user events
      stream: Authentication.instance.authChanges,
      builder: (BuildContext context, AsyncSnapshot<dynamic> user) {
        //routing conditions
        //- if user is logged in
        //- if user is logged out
        Widget? screen;
        switch(user.hasData){
          case true:
            //TODO: Home screen
            screen = const Placeholder(child: Text('Home Screen'));
            return screen;
          case false:
            screen = const AccountSelectionScreen();
            return screen;
        }
      },
    );
  }
}
