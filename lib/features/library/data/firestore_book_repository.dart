import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';

/// Destino para la fase de backend: guardar los libros en Firestore por usuario
/// (`books/{id}` con `ownerId`), sincronizados en vivo — el mismo patrón que
/// los repos de Planogether (`watchForOwner`, `newId`, ...).
///
/// Todavía no está cableado: el DI usa [LocalBookRepository]. Para activarlo:
///  1. `flutterfire configure`
///  2. registrar este repo en `repository_modules.dart` cuando `firebaseReady`
///  3. migrar el id de `int` a `String` (id de documento) en [Book]
///  4. desplegar la regla `books/{id}` de `firestore.rules`
class FirestoreBookRepository implements BookRepository {
  FirestoreBookRepository({
    required String ownerId,
    FirebaseFirestore? firestore,
  })  : _ownerId = ownerId,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ignore: unused_field
  final String _ownerId;
  // ignore: unused_field
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('books');

  Never _todo() => throw UnimplementedError(
        'FirestoreBookRepository: pendiente de la fase de backend Firebase',
      );

  /// Stream en vivo de los libros del usuario (para cuando la UI pase a bloc
  /// con streams, como `GroupsCubit` en Planogether).
  Stream<List<Book>> watchForOwner() {
    return _collection
        .where('ownerId', isEqualTo: _ownerId)
        .snapshots()
        .map((s) => s.docs.map((d) => Book.fromMap(d.data())).toList());
  }

  @override
  Future<List<Book>> getAll() => _todo();

  @override
  Future<List<Book>> getRead() => _todo();

  @override
  Future<List<Book>> getRated() => _todo();

  @override
  Future<Book?> getById(int id) => _todo();

  @override
  Future<int> add(Book book) => _todo();

  @override
  Future<void> update(Book book) => _todo();

  @override
  Future<void> delete(int id) => _todo();

  @override
  Future<void> importAll(List<Book> books) => _todo();
}
