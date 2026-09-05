import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';

/// Pestañas de la biblioteca.
enum LibraryTab { all, read, rated }

/// Orden de la lista de libros.
enum LibrarySort {
  /// Los añadidos más recientemente primero (por `id`, que en sqflite crece
  /// con cada inserción).
  recent,
  titleAsc,
  authorAsc,

  /// Mejor valorados primero; sin valoración quedan al final.
  ratingDesc,
}

class LibraryState {
  const LibraryState({
    this.books = const [],
    this.tab = LibraryTab.all,
    this.query = '',
    this.sort = LibrarySort.recent,
    this.loading = true,
  });

  final List<Book> books;
  final LibraryTab tab;
  final String query;
  final LibrarySort sort;
  final bool loading;

  /// Libros de la pestaña activa, filtrados por [query] (título, autor, ISBN
  /// o género; insensible a mayúsculas, null-safe) y ordenados por [sort].
  List<Book> get visibleBooks {
    final base = switch (tab) {
      LibraryTab.all => books,
      LibraryTab.read => books.where((b) => b.isRead),
      LibraryTab.rated => books.where((b) => b.isRated),
    };
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? base.toList()
        : base.where((b) {
            final titulo = b.titulo?.toLowerCase() ?? '';
            final autor = b.autor?.toLowerCase() ?? '';
            final isbn = b.isbn?.toLowerCase() ?? '';
            final genero = b.genero?.toLowerCase() ?? '';
            return titulo.contains(q) ||
                autor.contains(q) ||
                isbn.contains(q) ||
                genero.contains(q);
          }).toList();

    switch (sort) {
      case LibrarySort.recent:
        filtered.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      case LibrarySort.titleAsc:
        filtered.sort((a, b) => (a.titulo ?? '')
            .toLowerCase()
            .compareTo((b.titulo ?? '').toLowerCase()));
      case LibrarySort.authorAsc:
        filtered.sort((a, b) => (a.autor ?? '')
            .toLowerCase()
            .compareTo((b.autor ?? '').toLowerCase()));
      case LibrarySort.ratingDesc:
        filtered
            .sort((a, b) => (b.valoracion ?? 0).compareTo(a.valoracion ?? 0));
    }
    return filtered;
  }

  LibraryState copyWith({
    List<Book>? books,
    LibraryTab? tab,
    String? query,
    LibrarySort? sort,
    bool? loading,
  }) {
    return LibraryState(
      books: books ?? this.books,
      tab: tab ?? this.tab,
      query: query ?? this.query,
      sort: sort ?? this.sort,
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

  void setSort(LibrarySort sort) => emit(state.copyWith(sort: sort));

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
