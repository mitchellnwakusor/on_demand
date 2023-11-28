import 'package:firebase_core/firebase_core.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/Services/providers/start_screen_provider.dart';
import 'Services/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => StartScreenProvider()),
          Provider(create: (_) => SignupProvider()),
        ],
        child: const MainApp(),
      )
  );
}