import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  DataBaseProvider._();

  static final String dbName = "movie_record";

  static final DataBaseProvider dbProvider = DataBaseProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$dbName.db";
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE movie_record ("
          "id TEXT primary key,"
          "name TEXT,"
          "cover TEXT,"
          "position INTEGER"
          ")");
    });
  }


}
