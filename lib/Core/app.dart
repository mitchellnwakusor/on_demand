import 'package:flutter/material.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/providers/app_theme_provider.dart';
import 'package:provider/provider.dart';


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}
class _MainAppState extends State<MainApp> {

  late AppTheme appTheme;
  @override
  initState() {
    AppTheme().initField();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<AppTheme>(context);
    return MaterialApp(
      //get themeMode from db
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      themeMode: appTheme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
    );
  }
}
