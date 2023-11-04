import 'package:flutter/material.dart';

import 'authentication_handler.dart';
import '../UI/Screens/login_screen.dart';
import '../UI/Screens/register_screen.dart';

Route<dynamic>? generateRoute (RouteSettings settings) {
  switch(settings.name){
    case RegisterScreen.id:
      return MaterialPageRoute(builder: (_)=> const RegisterScreen());
    case LoginScreen.id:
      return MaterialPageRoute(builder: (_)=> const LoginScreen());
    default:
      return MaterialPageRoute(builder: (_)=> const AuthenticationHandler()); //initial route
  }
}

String registerScreen = RegisterScreen.id;
String loginScreen = LoginScreen.id;