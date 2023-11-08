import 'package:flutter/material.dart';
import 'package:on_demand/UI/Screens/search_input_screen.dart';

import 'authentication_handler.dart';
import '../UI/Screens/login_screen.dart';
import '../UI/Screens/register_screen.dart';

Route<dynamic>? generateRoute (RouteSettings settings) {
  switch(settings.name){
    case RegisterScreen.id:
      return MaterialPageRoute(builder: (_)=> const RegisterScreen());
    case LoginScreen.id:
      return MaterialPageRoute(builder: (_)=> const LoginScreen());
    case SearchScreen.id:
      return MaterialPageRoute(builder: (_)=> const SearchScreen());
    default:
      return MaterialPageRoute(builder: (_)=> const AuthenticationHandler()); //initial route
  }
}

String registerScreen = RegisterScreen.id;
String loginScreen = LoginScreen.id;
String searchScreen = SearchScreen.id;