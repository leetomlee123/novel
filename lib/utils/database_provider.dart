import 'dart:io';

import 'package:novel/pages/listen/listen_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  DataBaseProvider._();

  static final String _dbVoice = "voice";

  static final DataBaseProvider dbProvider = DataBaseProvider._();

  Database? _databaseVoice;

  Future<Database?> get databaseVoice async {
    if (_databaseVoice != null) return _databaseVoice;
    _databaseVoice = await getDatabaseInstanceVoice();
    return _databaseVoice;
  }

  getDatabaseInstanceVoice() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$_dbVoice.db";
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbVoice("
          "id INTEGER PRIMARY KEY ,"
          "title TEXT,"
          "url TEXT,"
          "bookMeta TEXT,"
          "lasttime INTEGER,"
          "idx INTEGER,"
          "count INTEGER,"
          "duration INTEGER,"
          "position INTEGER,"
          "cover TEXT)");
    });
  }

  addVoice(Search listenSearchModel) async {
    var client = await databaseVoice;

    int result = await client!.update(_dbVoice, listenSearchModel.toMap(),
        where: "id=?", whereArgs: [listenSearchModel.id]);
    if (result < 1) {
      await client.insert(
        _dbVoice,
        listenSearchModel.toMap(),
      );
    }
  }

  Future<List<Search>> voices() async {
    var client = await databaseVoice;
    List result = await client!.query(
      _dbVoice,
      orderBy: "lasttime desc",
    );
    return result.map((e) => Search.fromJson(e)).toList();
  }

  Future<Search?> voiceById(int? id) async {
    var client = await databaseVoice;
    List result = await client!.query(_dbVoice, where: "id=?", whereArgs: [id]);
    if (result.isEmpty) return null;
    return result.map((e) => Search.fromJson(e)).first;
  }

  delById(int? id) async {
    var client = await databaseVoice;
    await client!.delete(_dbVoice, where: "id=?", whereArgs: [id]);
  }

  clear() async {
    var client = await databaseVoice;
    client!.delete(_dbVoice);
  }
}
