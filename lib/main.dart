import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:on_demand/Services/providers/app_theme_provider.dart';
import 'package:on_demand/Services/providers/edit_profile_provider.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/Services/providers/start_screen_provider.dart';
import 'package:on_demand/Services/providers/user_details_provider.dart';
import 'Core/ids.dart';
import 'Services/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/app.dart';

void main() async {

  // const clientID = "255036669928-5b9foj1hssbr0gpjrsuptrn5s6rl2asu.apps.googleusercontent.com";

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders(
    [
      EmailAuthProvider(),
      PhoneAuthProvider(),
      GoogleProvider(clientId: clientID)
    ]
  );

  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => StartScreenProvider()),
          Provider(create: (_) => SignupProvider()),
          Provider(create: (_) => UserDetailsProvider()),
          Provider(create: (_) => EditProfileProvider()),
          ChangeNotifierProvider(create: (_) => AppTheme()),
        ],
        child: const MainApp(),
      )
  );
}