import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';

class BookDetailState {
  const BookDetailState({
    required this.book,
    this.saving = false,
  });

  final Book book;
  final bool saving;

  int get rating => book.valoracion ?? 0;
  String get opinion => book.opinion ?? '';

  BookDetailState copyWith({Book? book, bool? saving}) => BookDetailState(
        book: book ?? this.book,
        saving: saving ?? this.saving,
      );
}

/// Reemplaza a `DetailPageModel` / `DetailPageAlertModel` (Provider). Mantiene
/// el libro que se está viendo y persiste los cambios de valoración / opinión.
class BookDetailCubit extends Cubit<BookDetailState> {
  BookDetailCubit(this._repository, Book book)
      : super(BookDetailState(book: book));

  final BookRepository _repository;

  void setRating(int rating) =>
      emit(state.copyWith(book: state.book.copyWith(valoracion: rating)));

  void setOpinion(String opinion) =>
      emit(state.copyWith(book: state.book.copyWith(opinion: opinion)));

  void setBook(Book book) => emit(state.copyWith(book: book));

  Future<void> save() async {
    emit(state.copyWith(saving: true));
    await _repository.update(state.book);
    emit(state.copyWith(saving: false));
  }

  Future<void> delete() async {
    final id = state.book.id;
    if (id != null) await _repository.delete(id);
  }
}
