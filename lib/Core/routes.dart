import 'package:flutter/material.dart';
import 'package:on_demand/UI/Screens/edit_profile_screen.dart';
import 'package:on_demand/UI/Screens/home_screen.dart';
import 'package:on_demand/UI/Screens/login_screen_reauthenticate.dart';
import 'package:on_demand/UI/Screens/profile_screen.dart';
import 'package:on_demand/UI/Screens/reset_password.dart';
import 'package:on_demand/UI/Screens/settings_screen.dart';
import 'package:on_demand/UI/Screens/start_screen.dart';
import 'package:on_demand/UI/Screens/business_detail_screen.dart';
import 'package:on_demand/UI/Screens/document_upload_screen.dart';
import 'package:on_demand/UI/Screens/otp_verification_screen.dart';
import 'package:on_demand/UI/Screens/search_input_screen.dart';
import '../UI/Screens/email_verification_screen.dart';
import 'authentication_handler.dart';
import '../UI/Screens/login_screen.dart';
import '../UI/Screens/register_screen.dart';

//Material navigator routes
Route<dynamic>? generateRoute (RouteSettings settings) {
  switch(settings.name){
    case AuthenticationHandler.id:
      return MaterialPageRoute(builder: (_)=> const AuthenticationHandler(),settings: settings);
    case HomeScreen.id:
      return MaterialPageRoute(builder: (_)=> const HomeScreen(),settings: settings);
    case StartScreen.id:
      return MaterialPageRoute(builder: (_)=> const StartScreen(),settings: settings);
    case RegisterScreen.id:
      return MaterialPageRoute(builder: (_)=> const RegisterScreen(),settings: settings);
    case ResetPasswordScreen.id:
      return MaterialPageRoute(builder: (_)=> const ResetPasswordScreen(),settings: settings);
    case EmailVerificationScreen.id:
      return MaterialPageRoute(builder: (_)=> const EmailVerificationScreen(),settings: settings);
    case LoginScreen.id:
      return MaterialPageRoute(builder: (_)=> const LoginScreen(),settings: settings);
    case LoginScreenReauthenticate.id:
      return MaterialPageRoute(builder: (_)=> const LoginScreenReauthenticate(),settings: settings);
    case SearchScreen.id:
      return MaterialPageRoute(builder: (_)=> const SearchScreen(),settings: settings);
    case OTPVerificationScreen.id:
      return MaterialPageRoute(builder: (_)=> const OTPVerificationScreen(),settings: settings);
    case BusinessDetailScreen.id:
      return MaterialPageRoute(builder: (_)=> const BusinessDetailScreen(),settings: settings);
    case ProfileScreen.id:
      return MaterialPageRoute(builder: (_)=> const ProfileScreen(),settings: settings);
    case EditProfileScreen.id:
      return MaterialPageRoute(builder: (_)=> const EditProfileScreen(),settings: settings);
    case AppSettingsScreen.id:
      return MaterialPageRoute(builder: (_)=> const AppSettingsScreen(),settings: settings);
    case DocumentUploadScreen.id:
      return MaterialPageRoute(builder: (_)=> const DocumentUploadScreen(),settings: settings);
    default:
      return MaterialPageRoute(builder: (_)=> const AuthenticationHandler(),settings: settings); //initial route
  }
}

//String literal references to route
String authHandlerScreen = AuthenticationHandler.id;
String homeScreen = HomeScreen.id;
String startScreen = StartScreen.id;
String registerScreen = RegisterScreen.id;
String emailVerificationScreen = EmailVerificationScreen.id;
String resetPasswordScreen = ResetPasswordScreen.id;
String loginScreen = LoginScreen.id;
String loginScreenReauthenticate = LoginScreenReauthenticate.id;
String searchScreen = SearchScreen.id;
String otpVerificationScreen = OTPVerificationScreen.id;
String documentUploadScreen = DocumentUploadScreen.id;
String businessDetailScreen = BusinessDetailScreen.id;
String profileScreen = ProfileScreen.id;
String editProfileScreen = EditProfileScreen.id;
String appSettingsScreen = AppSettingsScreen.id;
// String phoneTextScreen = PhoneTextScreen.id;



