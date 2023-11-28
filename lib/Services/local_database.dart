import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  //private constructor
  LocalDatabase._init();

  final _databaseRef = 'config.db';

  static Database? _database;

  //database init
  Future<Database> get database async {
    if(_database!=null) return _database!;

    _database = await _initializeDatabase();
    return _database!;
  }

  //init method
  Future<Database?> _initializeDatabase() async {
    //locally scoped database reference
    Database? db;
    try {
      //get database path
      String path = await _getLocalDatabasePath();
      //check if database exists
      if (await _localDatabaseExists(path)) {
        db = await openDatabase(path, version: 1);
      }
      else {
        //copy assets db file to local db file
        ByteData data = await rootBundle.load(url.join("assets", _databaseRef));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
        await File(path).writeAsBytes(bytes,flush: true);

        db = await openDatabase(path, version: 1,);
      }
    } on Exception catch (error) {
      db = null;
      // TODO: implement error handler
      if (kDebugMode) {
        print(error);
      }
    }
    return db;
  }

  //extracted init methods
  Future<String> _getLocalDatabasePath() async {
    late String localDatabasePath;
    if (Platform.isAndroid) {
      try {
        var path = await getDatabasesPath();
        localDatabasePath = join(path, _databaseRef);
      } on Exception catch (error) {
        //Todo: implement error handler
        if (kDebugMode) {
          print(error);
        }
      }
    } else {
      try {
        var dir = await getLibraryDirectory();
        String path = dir.path;
        localDatabasePath = join(path, _databaseRef);
      } on Exception catch (error) {
        //Todo: implement error handler
        if (kDebugMode) {
          print(error);
        }
      }
    }
    return localDatabasePath;
  }
  Future<bool> _localDatabaseExists(String localDatabasePath) async {
    bool dbExists;
    try {
      bool exists = await databaseExists(localDatabasePath);
      dbExists = exists;
    } on Exception catch (error) {
      dbExists = false;
      // TODO: Implement error handling
      if (kDebugMode) {
        print(error);
      }
    }
    return dbExists;
  }


}