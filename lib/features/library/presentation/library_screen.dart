import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/ads/banner_ad_view.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/catalog/domain/model/google_book.dart';
import 'package:tomora/features/catalog/presentation/book_search_sheet.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';
import 'package:tomora/features/library/presentation/widgets/book_list_item.dart';
import 'package:tomora/features/preferences/presentation/preferences_screen.dart';

/// Casa del usuario con sesión iniciada: un [NavigationBar] inferior que
/// alterna entre la biblioteca, los libros valorados y los ajustes. La barra
/// abajo (en vez de pestañas arriba) deja los destinos principales al alcance
/// del pulgar y sigue la convención de plataforma en iOS y Android.
///
/// Provee un único [LibraryCubit] a las tres secciones y carga los libros
/// **una vez** al entrar (antes se llamaba a la BD en cada `build`, lo que
/// provocaba un bucle de rebuild).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LibraryCubit>()..load(),
      child: const _LibraryShell(),
    );
  }
}

class _LibraryShell extends StatefulWidget {
  const _LibraryShell();

  @override
  State<_LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<_LibraryShell> {
  int _index = 0;

  /// FAB: ofrece buscar en Google Books para prerrellenar, o crear en blanco.
  Future<void> _addBook(BuildContext context) async {
    final cubit = context.read<LibraryCubit>();
    final picked = await BookSearchSheet.show(context);
    if (!context.mounted) return;
    await context.pushNamed(
      RouteNames.bookNew,
      extra: picked == null ? null : _bookFromGoogle(picked),
    );
    if (context.mounted) cubit.load();
  }

  Book _bookFromGoogle(GoogleBook g) => Book(
        titulo: g.title,
        autor: g.authorsLabel,
        editorial: g.publisher,
        genero: g.categories.isNotEmpty ? g.categories.first : null,
        fechaPublicacion: g.publishedDate,
        paginas: g.pageCount,
        isbn: g.isbn13,
        idioma: g.language,
        leido: 'No',
        estado: 1,
        tapa: 0,
        valoracion: 0,
      );

  @override
  Widget build(BuildContext context) {
    const titles = ['Mi biblioteca', 'Valorados', 'Ajustes'];
    return Scaffold(
      backgroundColor: primaryColorLight,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title: Text(
          _index == 0 ? AppConstants.appName : titles[_index],
          style: const TextStyle(color: whiteRed, fontFamily: Fonts.muliBold),
        ),
      ),
      floatingActionButton: _index == 2
          ? null
          : FloatingActionButton(
              backgroundColor: primaryColorDark,
              onPressed: () => _addBook(context),
              child: const Icon(Icons.add, color: whiteRed),
            ),
      body: SafeArea(
        child: Column(
          children: [
            const BannerAdView(),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  _BookListTab(),
                  _RatedTab(),
                  PreferencesScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Valorados',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

/// Pestaña "Mi biblioteca": buscador + conmutador Biblioteca / Leídos + lista.
class _BookListTab extends StatefulWidget {
  const _BookListTab();

  @override
  State<_BookListTab> createState() => _BookListTabState();
}

class _BookListTabState extends State<_BookListTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        final cubit = context.read<LibraryCubit>();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: cubit.setQuery,
                decoration: InputDecoration(
                  hintText: 'Busca un libro',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state.query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            cubit.setQuery('');
                          },
                        ),
                ),
              ),
            ),
            _SegmentedToggle(
              selected: state.tab,
              onChanged: cubit.setTab,
            ),
            Expanded(
              child: _BooksList(
                books: state.visibleBooks,
                loading: state.loading,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({required this.selected, required this.onChanged});

  final LibraryTab selected;
  final ValueChanged<LibraryTab> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget button(String label, LibraryTab tab) {
      final active = selected == tab;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(tab),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: active ? orangeLight : primaryColor,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: active ? black : white,
                  fontFamily: Fonts.muliBold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        button('Biblioteca', LibraryTab.all),
        button('Leídos', LibraryTab.read),
      ],
    );
  }
}

/// Pestaña "Valorados": los libros con valoración > 0.
class _RatedTab extends StatelessWidget {
  const _RatedTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: orangeLight,
      child: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final rated = state.books.where((b) => b.isRated).toList();
          return _BooksList(books: rated, loading: state.loading);
        },
      ),
    );
  }
}

class _BooksList extends StatelessWidget {
  const _BooksList({required this.books, required this.loading});

  final List<Book> books;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (books.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Aún no has añadido ningún libro',
              textAlign: TextAlign.center),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: books.length,
      itemBuilder: (context, index) => BookListItem(book: books[index]),
    );
  }
}
