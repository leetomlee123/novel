import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  DataBaseProvider._();

  static final String _dbShelf = "shelf1";
  static final String _dbChapters = "chapter";

  static final DataBaseProvider dbProvider = DataBaseProvider._();
  Database? _databaseShelf;
  Database? _databaseChapter;

  Future<Database?> get databaseChapter async {
    if (_databaseChapter != null) return _databaseChapter;
    _databaseChapter = await getDatabaseInstanceShelf();
    return _databaseChapter;
  }

  Future<Database?> get databaseShelf async {
    if (_databaseChapter != null) return _databaseChapter;
    _databaseChapter = await getDatabaseInstanceShelf();
    return _databaseChapter;
  }

  Future<Database> getDatabaseInstanceShelf() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "$_dbShelf.db";
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbShelf("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "cname TEXT,"
          "author TEXT,"
          "rate INTEGER,"
          "book_status TEXT,"
          "u_time TEXT,"
          "img TEXT,"
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
    String path = directory.path + "$_dbShelf.db";
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $_dbChapters("
          "id TEXT PRIMARY KEY ,"
          "name TEXT,"
          "content TEXT,"
          "book_id TEXT,"
          "hasContent INTEGER");
    });
  }

//添加书籍到书架
  Future<Null> addBooks(List<Book> bks) async {
    var dbClient = await databaseChapter;
    var batch = dbClient!.batch();

    for (Book book in bks) {
      batch.insert("$_dbShelf", {
        "id": book.id,
        "name": book.name,
        "cname": book.cName,
        "author": book.author,
        "img": book.img,
        "rate": book.rate,
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
    var dbClient = await getDatabaseInstanceShelf();
    List<Book> bks = [];
    var list = await dbClient
        .rawQuery("select * from $_dbShelf order by sort_time desc", []);
    for (var i in list) {
      bks.add(Book.fromSql(i));
    }
    return bks;
  }

  Future<Null> updBook(Book book) async {
    var dbClient = await getDatabaseInstanceShelf();
    var i = await dbClient
        .update(_dbShelf, book.toMap(), where: "id=?", whereArgs: [book.id]);
    print(i);
    // await dbClient.rawUpdate(
    //     "update $_dbShelf set last_chapter=?,new_chapter=?,u_time=?,img=? where id=?",
    //     [lastChapter, newStatus, uTime, img, bookId]);
  }

  Future<void> clearBooks() async {
    var dbClient = await getDatabaseInstanceShelf();
    await dbClient.rawDelete("delete from $_dbShelf");
  }

  Future<void> clearBooksById(String bookId) async {
    var dbClient = await getDatabaseInstanceShelf();
    await dbClient.delete(_dbShelf, where: "id=?", whereArgs: [bookId]);
  }
}
