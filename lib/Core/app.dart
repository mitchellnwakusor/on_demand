import 'package:flutter/material.dart';
import 'package:on_demand/Core/routes.dart';


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}
class _MainAppState extends State<MainApp> {

  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //get themeMode from db
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xff954a03),
            onPrimary: Color(0xffffffff),
            secondary: Color(0xff8a5100),
            onSecondary: Color(0xffffffff),
            error: Color(0xffba1a1a),
            onError: Color(0xffffffff),
            background: Color(0xfffffbff),
            onBackground: Color(0xff201a17),
            surface: Color(0xfffffbff),
            onSurface: Color(0xff201a17),
        )
      ),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xffffb785),
            onPrimary: Color(0xff502400),
            secondary: Color(0xffffb86f),
            onSecondary: Color(0xff4a2800),
            error: Color(0xffffb4ab),
            onError: Color(0xff690005),
            background: Color(0xff201a17),
            onBackground: Color(0xffece0da),
            surface: Color(0xff201a17),
            onSurface: Color(0xffece0da),
          )
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
    );
  }
}
