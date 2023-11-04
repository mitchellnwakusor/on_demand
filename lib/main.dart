import 'package:firebase_core/firebase_core.dart';
import 'Services/firebase_options.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}