import 'package:tomora/features/library/data/book_local_datasource.dart';
import 'package:tomora/features/library/domain/model/book.dart';

/// Contrato de acceso a los libros. La implementación activa es
/// [LocalBookRepository] (sqflite); [FirestoreBookRepository] queda como
/// destino para cuando se conecte el backend (ver `firestore_book_repository.dart`).
abstract interface class BookRepository {
  Future<List<Book>> getAll();
  Future<List<Book>> getRead();
  Future<List<Book>> getRated();
  Future<Book?> getById(int id);
  Future<int> add(Book book);
  Future<void> update(Book book);
  Future<void> delete(int id);
  Future<void> importAll(List<Book> books);
}

/// Implementación local sobre sqflite.
class LocalBookRepository implements BookRepository {
  LocalBookRepository(this._local);

  final BookLocalDataSource _local;

  @override
  Future<List<Book>> getAll() => _local.getAllBooks();

  @override
  Future<List<Book>> getRead() => _local.getReadBooks();

  @override
  Future<List<Book>> getRated() => _local.getRatedBooks();

  @override
  Future<Book?> getById(int id) => _local.getBookById(id);

  @override
  Future<int> add(Book book) => _local.insertBook(book);

  @override
  Future<void> update(Book book) => _local.updateBook(book);

  @override
  Future<void> delete(int id) => _local.deleteBook(id);

  @override
  Future<void> importAll(List<Book> books) => _local.importBooks(books);
}
