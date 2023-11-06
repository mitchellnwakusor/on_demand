import 'package:flutter/material.dart';
import 'package:on_demand/Core/local_database.dart';
import 'package:sqflite/sqflite.dart';
import '../UI/Screens/start_screen.dart';
import 'authentication.dart';

class AuthenticationHandler extends StatefulWidget {
  const AuthenticationHandler({super.key});

  @override
  State<AuthenticationHandler> createState() => _AuthenticationHandlerState();
}

class _AuthenticationHandlerState extends State<AuthenticationHandler> {
  //ideally set database using provider
  Database? _database;
  void initDatabase() async{
    _database = await LocalDatabase.instance.database;
    var query = await _database?.query('occupation',columns: ['name'],where: 'name = ?',whereArgs: ['']);

    query?.forEach((element) {
      print(element);
    });
  }
  @override
  void initState() {
    // init database
    initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listens for firebase auth user events
      stream: Authentication.instance.authChanges,
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
