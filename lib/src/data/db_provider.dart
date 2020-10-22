import 'package:libroteca/src/models/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, "libroteca.db");
    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE book (
         id TEXT PRIMARY KEY,
         paginas INTEGER,
         estado INTEGER,
         titulo TEXT,
         autor TEXT,
         editorial TEXT,
         genero TEXT,
         fecha_publicacion TEXT,
         edicion TEXT,
         leido TEXT, 
         nombre_prestamo TEXT,
         idioma TEXT,
         tapa INTEGER
        )""");
  }

  static Future _onUpgrade(Database db, int version, int newVersion) async {}

  insertBook(Book book) async {
    final db = await database;
    final res = await db.insert('book', book.toJson());
    return res;
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final res = await db.query('book');
    List<Book> sales =
        res.isNotEmpty ? res.map((e) => Book.fromJson(e)).toList() : [];

    return sales;
  }

  Future<Book> getBookById(int id) async {
    final db = await database;
    final res = await db.query('book', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Book.fromJson(res.first) : null;
  }

  Future updateBook(Book book) async {
    final db = await database;
    final res = await db.update(
      'book',
      book.toJson(),
      where: "id = ?",
      whereArgs: [book.id],
    );
    return res;
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    final res = await db.delete('book', where: 'id = ?', whereArgs: [id]);
    return res;
  }
}
