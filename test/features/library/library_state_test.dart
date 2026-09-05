import 'package:flutter_test/flutter_test.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';

void main() {
  final read = const Book(
    id: 1,
    titulo: 'Rayuela',
    autor: 'Julio Cortázar',
    leido: 'Si',
    valoracion: 0,
  );
  final unread = const Book(
    id: 2,
    titulo: 'Ficciones',
    autor: 'Jorge Luis Borges',
    leido: 'No',
    valoracion: 0,
  );
  final rated = const Book(
    id: 3,
    titulo: 'Pedro Páramo',
    autor: 'Juan Rulfo',
    leido: 'No',
    valoracion: 5,
  );
  final books = [read, unread, rated];

  group('LibraryState.visibleBooks', () {
    test('LibraryTab.all sin búsqueda muestra todos, más recientes primero',
        () {
      final state = LibraryState(books: books);
      expect(state.visibleBooks, [rated, unread, read]);
    });

    test('LibraryTab.read solo muestra los marcados como leídos', () {
      final state = LibraryState(books: books, tab: LibraryTab.read);
      expect(state.visibleBooks, [read]);
    });

    test('LibraryTab.rated solo muestra los que tienen valoración > 0', () {
      final state = LibraryState(books: books, tab: LibraryTab.rated);
      expect(state.visibleBooks, [rated]);
    });

    test('filtra por título sin distinguir mayúsculas/minúsculas', () {
      final state = LibraryState(books: books, query: 'RAYUELA');
      expect(state.visibleBooks, [read]);
    });

    test('filtra por autor', () {
      final state = LibraryState(books: books, query: 'borges');
      expect(state.visibleBooks, [unread]);
    });

    test('la búsqueda se combina con la pestaña activa', () {
      final state = LibraryState(
        books: books,
        tab: LibraryTab.read,
        query: 'ficciones',
      );
      expect(state.visibleBooks, isEmpty);
    });

    test('libros sin título/autor no rompen el filtro', () {
      const noTitle = Book(id: 4);
      final state = LibraryState(books: [...books, noTitle], query: 'x');
      expect(state.visibleBooks, isEmpty);
    });
  });
}
