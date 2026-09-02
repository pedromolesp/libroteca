import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/catalog/data/google_books_api.dart';
import 'package:tomora/features/catalog/domain/model/google_book.dart';

enum SearchStatus { idle, loading, success, empty, error }

class BookSearchState {
  const BookSearchState({
    this.status = SearchStatus.idle,
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  final SearchStatus status;
  final List<GoogleBook> results;
  final String query;
  final String? errorMessage;

  BookSearchState copyWith({
    SearchStatus? status,
    List<GoogleBook>? results,
    String? query,
    String? errorMessage,
  }) {
    return BookSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }
}

/// Búsqueda con _debounce_. Sustituye al `FutureBuilder` en línea que creaba un
/// future nuevo por rebuild y a un `ListView.builder` sin `itemCount` (que
/// provocaba `RangeError`).
class BookSearchCubit extends Cubit<BookSearchState> {
  BookSearchCubit(this._api) : super(const BookSearchState());

  final GoogleBooksApi _api;
  Timer? _debounce;
  int _requestId = 0;

  static const _debounceDelay = Duration(milliseconds: 400);

  void queryChanged(String raw) {
    final query = raw.trim();
    _debounce?.cancel();

    if (query.length < 2) {
      emit(const BookSearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: query));
    _debounce = Timer(_debounceDelay, () => _run(query));
  }

  /// Reintenta la última consulta (botón de la UI tras un error).
  void retry() {
    if (state.query.length < 2) return;
    _debounce?.cancel();
    emit(state.copyWith(status: SearchStatus.loading));
    _run(state.query);
  }

  Future<void> _run(String query) async {
    final id = ++_requestId;
    try {
      final result = await _api.search(query);
      if (isClosed || id != _requestId) return; // llegó una búsqueda más nueva
      emit(state.copyWith(
        status:
            result.items.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: result.items,
      ));
    } on GoogleBooksException catch (e) {
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(
        status: SearchStatus.error,
        results: const [],
        errorMessage: e.isQuotaExceeded
            ? 'Google Books ha alcanzado su límite de consultas. '
                'Inténtalo de nuevo en un rato.'
            : 'No se pudo buscar en Google Books. Revisa tu conexión.',
      ));
    }
  }

  void clear() {
    _debounce?.cancel();
    emit(const BookSearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
