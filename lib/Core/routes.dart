import 'package:flutter/material.dart';
import 'package:on_demand/UI/Screens/start_screen.dart';
import 'package:on_demand/UI/Screens/business_detail_screen.dart';
import 'package:on_demand/UI/Screens/document_upload_screen.dart';
import 'package:on_demand/UI/Screens/otp_verification_screen.dart';
import 'package:on_demand/UI/Screens/search_input_screen.dart';

import 'authentication_handler.dart';
import '../UI/Screens/login_screen.dart';
import '../UI/Screens/register_screen.dart';

Route<dynamic>? generateRoute (RouteSettings settings) {
  switch(settings.name){
    case StartScreen.id:
      return MaterialPageRoute(builder: (_)=> const StartScreen(),settings: settings);
    case RegisterScreen.id:
      return MaterialPageRoute(builder: (_)=> const RegisterScreen(),settings: settings);
    case LoginScreen.id:
      return MaterialPageRoute(builder: (_)=> const LoginScreen(),settings: settings);
    case SearchScreen.id:
      return MaterialPageRoute(builder: (_)=> const SearchScreen(),settings: settings);
    case OTPVerificationScreen.id:
      return MaterialPageRoute(builder: (_)=> const OTPVerificationScreen(),settings: settings);
    case BusinessDetailScreen.id:
      return MaterialPageRoute(builder: (_)=> const BusinessDetailScreen(),settings: settings);
    case DocumentUploadScreen.id:
      return MaterialPageRoute(builder: (_)=> const DocumentUploadScreen(),settings: settings);
    default:
      return MaterialPageRoute(builder: (_)=> const AuthenticationHandler(),settings: settings); //initial route
  }
}

String startScreen = StartScreen.id;
String registerScreen = RegisterScreen.id;
String loginScreen = LoginScreen.id;
String searchScreen = SearchScreen.id;
String otpVerificationScreen = OTPVerificationScreen.id;
String documentUploadScreen = DocumentUploadScreen.id;
String businessDetailScreen = BusinessDetailScreen.id;



