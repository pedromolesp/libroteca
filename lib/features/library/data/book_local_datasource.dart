import 'package:tomora/features/library/domain/model/book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Acceso a la base de datos local sqflite (`tomora.db`, tabla `book`).
/// Portado del antiguo singleton `DBProvider`, conservando el esquema para no
/// romper bases de datos ya instaladas.
class BookLocalDataSource {
  BookLocalDataSource();

  Database? _database;

  Future<Database> get _db async => _database ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'tomora.db');
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, _) => db.execute('''
        CREATE TABLE book (
          id INTEGER PRIMARY KEY,
          paginas INTEGER,
          estado INTEGER,
          titulo TEXT,
          isbn TEXT,
          autor TEXT,
          editorial TEXT,
          genero TEXT,
          fecha_publicacion TEXT,
          edicion TEXT,
          leido TEXT,
          nombre_prestamo TEXT,
          idioma TEXT,
          tapa INTEGER,
          valoracion INTEGER,
          opinion TEXT
        )
      '''),
    );
  }

  Future<List<Book>> getAllBooks() async {
    final rows = await (await _db).query('book');
    return rows.map(Book.fromMap).toList();
  }

  Future<List<Book>> getReadBooks() async {
    final rows =
        await (await _db).query('book', where: 'leido = ?', whereArgs: ['Si']);
    return rows.map(Book.fromMap).toList();
  }

  Future<List<Book>> getRatedBooks() async {
    final rows = await (await _db)
        .query('book', where: 'valoracion != ?', whereArgs: [0]);
    return rows.map(Book.fromMap).toList();
  }

  Future<Book?> getBookById(int id) async {
    final rows =
        await (await _db).query('book', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? Book.fromMap(rows.first) : null;
  }

  Future<int> insertBook(Book book) =>
      _db.then((db) => db.insert('book', book.toMap()));

  Future<int> updateBook(Book book) => _db.then(
        (db) => db.update(
          'book',
          book.toMap(),
          where: 'id = ?',
          whereArgs: [book.id],
        ),
      );

  Future<int> deleteBook(int id) =>
      _db.then((db) => db.delete('book', where: 'id = ?', whereArgs: [id]));

  Future<void> importBooks(List<Book> books) async {
    final batch = (await _db).batch();
    for (final book in books) {
      batch.insert(
        'book',
        book.toExportMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
