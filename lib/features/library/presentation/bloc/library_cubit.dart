import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';

/// Pestañas de la biblioteca.
enum LibraryTab { all, read, rated }

class LibraryState {
  const LibraryState({
    this.books = const [],
    this.tab = LibraryTab.all,
    this.query = '',
    this.loading = true,
  });

  final List<Book> books;
  final LibraryTab tab;
  final String query;
  final bool loading;

  /// Libros de la pestaña activa, filtrados por [query] (insensible a
  /// mayúsculas, null-safe).
  List<Book> get visibleBooks {
    final base = switch (tab) {
      LibraryTab.all => books,
      LibraryTab.read => books.where((b) => b.isRead),
      LibraryTab.rated => books.where((b) => b.isRated),
    };
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return base.toList();
    return base.where((b) {
      final titulo = b.titulo?.toLowerCase() ?? '';
      final autor = b.autor?.toLowerCase() ?? '';
      return titulo.contains(q) || autor.contains(q);
    }).toList();
  }

  LibraryState copyWith({
    List<Book>? books,
    LibraryTab? tab,
    String? query,
    bool? loading,
  }) {
    return LibraryState(
      books: books ?? this.books,
      tab: tab ?? this.tab,
      query: query ?? this.query,
      loading: loading ?? this.loading,
    );
  }
}

/// Reemplaza a los `BookController` / `BookViewController` de GetX. Carga los
/// libros **una sola vez** (o tras un cambio explícito), nunca desde `build`.
class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this._repository) : super(const LibraryState());

  final BookRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final books = await _repository.getAll();
    emit(state.copyWith(books: books, loading: false));
  }

  void setTab(LibraryTab tab) => emit(state.copyWith(tab: tab));

  void setQuery(String query) => emit(state.copyWith(query: query));

  Future<void> addBook(Book book) async {
    await _repository.add(book);
    await load();
  }

  Future<void> updateBook(Book book) async {
    await _repository.update(book);
    await load();
  }

  Future<void> deleteBook(int id) async {
    await _repository.delete(id);
    await load();
  }
}
