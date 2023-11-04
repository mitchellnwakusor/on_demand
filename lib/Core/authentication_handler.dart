import 'package:flutter/material.dart';
import '../UI/Screens/start_screen.dart';
import 'authentication.dart';

class AuthenticationHandler extends StatelessWidget {
  const AuthenticationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listens for firebase auth user events
      stream: Authentication().authChanges,
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
            screen = const StartScreen();
            return screen;
        }
      },
    );
  }
}
