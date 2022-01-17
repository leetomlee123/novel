import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:novel/pages/book_chapters/chapter.pb.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/utils/chapter_parse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  DataBaseProvider._();

  static final String _dbShelf = "shelf";
  static final String _dbChapters = "chapter";
  static final String _dbVoice = "voice";

  static final DataBaseProvider dbProvider = DataBaseProvider._();
  Database? _databaseShelf;
  Database? _databaseChapter;
  Database? _databaseVoice;

  Future<Database?> get databaseVoice async {
    if (_databaseVoice != null) return _databaseVoice;
    _databaseVoice = await getDatabaseInstanceVoice();
    return _databaseVoice;
  }

  Future<Database?> get databaseChapter async {
    if (_databaseChapter != null) return _databaseChapter;
    _databaseChapter = await getDatabaseInstanceChapter();
    return _databaseChapter;
  }

  Future<Database?> get databaseShelf async {
    if (_databaseShelf != null) return _databaseShelf;
    _databaseShelf = await getDatabaseInstanceShelf();
    return _databaseShelf;
  }

  getDatabaseInstanceVoice() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$_dbVoice.db";
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbVoice("
          "id INTEGER PRIMARY KEY ,"
          "title TEXT,"
          "author TEXT,"
          "transmit TEXT,"
          "url TEXT,"
          "idx INTEGER,"
          "count INTEGER,"
          "duration INTEGER,"
          "position INTEGER,"
          "lasttime INTEGER,"
          "picture TEXT,"
          "addtime INTEGER)");
    });
  }

  Future<Database> getDatabaseInstanceShelf() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$_dbShelf.db";
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbShelf("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "cname TEXT,"
          "author TEXT,"
          "rate TEXT,"
          "book_status TEXT,"
          "u_time TEXT,"
          "img TEXT,"
          "cache_chapter_content TEXT,"
          "book_desc TEXT,"
          "chapter_idx INTEGER,"
          "sort_time INTEGER,"
          "new_chapter INTEGER,"
          "page_idx INTEGER,"
          "last_chapter TEXT)");
    });
  }

  Future<Database> getDatabaseInstanceChapter() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$_dbChapters.db";
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbChapters("
          "id TEXT PRIMARY KEY ,"
          "name TEXT,"
          "content TEXT,"
          "book_id TEXT,"
          "has_content INTEGER)");
    });
  }

//添加书籍到书架
  Future<Null> addBooks(List<Book> bks) async {
    var dbClient = await databaseShelf;
    var batch = dbClient!.batch();

    for (Book book in bks) {
      batch.insert("$_dbShelf", {
        "id": book.id,
        "name": book.name,
        "cname": book.cName,
        "author": book.author,
        "img": book.img,
        "rate": book.rate,
        "cache_chapter_content": book.cacheChapterContent,
        "book_status": book.bookStatus,
        "book_desc": book.desc,
        "u_time": book.uTime,
        "chapter_idx": book.chapterIdx,
        "sort_time": book.sortTime ?? DateUtil.getNowDateMs(),
        "page_idx": book.pageIdx,
        "new_chapter": book.newChapter,
        "last_chapter": book.lastChapter
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Book>> getBooks() async {
    var dbClient = await databaseShelf;
    List<Book> bks = [];
    var list = await dbClient!
        .rawQuery("select * from $_dbShelf order by sort_time desc", []);
    for (var i in list) {
      bks.add(Book.fromSql(i));
    }
    return bks;
  }

  Future<Null> updBook(Book book) async {
    var dbClient = await databaseShelf;
    await dbClient!
        .update(_dbShelf, book.toMap(), where: "id=?", whereArgs: [book.id]);
  }

  Future<void> clearBooks() async {
    var dbClient = await databaseShelf;
    await dbClient!.delete(_dbShelf);
  }

  Future<void> clearBooksById(String bookId) async {
    var dbClient = await databaseShelf;
    await dbClient!.delete(_dbShelf, where: "id=?", whereArgs: [bookId]);
  }

  //chapter
  Future<void> addChapters(List<ChapterProto> chapters, String? bookId) async {
    var dbClient = await databaseChapter;
    var batch = dbClient!.batch();
    chapters.forEach((element) {
      batch.insert(_dbChapters, {
        "id ": element.chapterId,
        "name": element.chapterName,
        "content": "",
        "book_id": bookId,
        "has_content": "1"
      });
    });
    await batch.commit(noResult: true);
  }

  Future<List<ChapterProto>> getChapters(String? bookId) async {
    var dbClient = await databaseChapter;

    List<ChapterProto> cps = [];
    var list = await dbClient!
        .query(_dbChapters, where: "book_id=?", whereArgs: [bookId]);
    for (var i in list) {
      cps.add(ChapterProto(
          chapterName: i['name'].toString(),
          chapterId: i['id'].toString(),
          hasContent: i['has_content'].toString()));
    }
    return cps;
  }

  Future<String> getContent(String? chapterId) async {
    var dbClient = await databaseChapter;

    List list = await dbClient!
        .query(_dbChapters, where: "id=?", whereArgs: [chapterId]);

    return list[0]['content'] ?? "";
  }

  updateContent(String chapterId, String? chapterContent) async {
    var dbClient = await databaseChapter;

    await dbClient!.update(
        _dbChapters, {"content": chapterContent, "has_content": "2"},
        where: "id=?", whereArgs: [chapterId]);
  }

  downContent(List<DownChapter> downs) async {
    var dbClient = await databaseChapter;
    var batch = dbClient!.batch();
    downs.forEach((element) {
      batch.update(
          _dbChapters, {"content": element.chapterContent, "has_content": "2"},
          where: "id=?", whereArgs: [element.chapterId]);
    });
    await batch.commit();
  }

  clearChapter(String bookId) async {
    var dbClient = await databaseChapter;
    await dbClient!
        .delete(_dbChapters, where: "book_id=?", whereArgs: [bookId]);
  }

  clearChapters() async {
    var dbClient = await databaseChapter;
    await dbClient!.delete(_dbChapters);
  }

  addVoice(ListenSearchModel listenSearchModel) async {
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

  Future<List<ListenSearchModel>> voices() async {
    var client = await databaseVoice;
    List result = await client!.query(
      _dbVoice,
      orderBy: "lasttime desc",
    );
    return result.map((e) => ListenSearchModel.fromJson(e)).toList();
  }

  Future<ListenSearchModel?> voiceById(int? id) async {
    var client = await databaseVoice;
    List result = await client!.query(_dbVoice, where: "id=?", whereArgs: [id]);
    if (result.isEmpty) return null;
    return result.map((e) => ListenSearchModel.fromJson(e)).first;
  }

  clear() async {
    var client = await databaseVoice;
    client!.delete(_dbVoice);
  }
}
