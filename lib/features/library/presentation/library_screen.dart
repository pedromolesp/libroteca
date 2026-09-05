import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/ads/banner_ad_view.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/config/l10n/l10n_extension.dart';
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
    final l10n = context.l10n;
    final titles = [l10n.libraryTitle, l10n.ratedTitle, l10n.settingsTitle];
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title: Text(
          _index == 0 ? AppConstants.appName : titles[_index],
          style: const TextStyle(color: whiteRed, fontFamily: Fonts.muliBold),
        ),
        actions: [
          IconButton(
            tooltip: l10n.friendsTitle,
            icon: const Icon(Icons.group_outlined, color: whiteRed),
            onPressed: () => context.pushNamed(RouteNames.friends),
          ),
        ],
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
                children: [
                  _BookListTab(onAddBook: () => _addBook(context)),
                  const _RatedTab(),
                  const PreferencesScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        // El NavigationBar de M3 no proyecta sombra real (solo tinte de
        // elevación); se añade una sombra hacia arriba para despegarlo del
        // fondo claro.
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: primaryColorDark.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: l10n.navLibrary,
            ),
            NavigationDestination(
              icon: const Icon(Icons.star_outline),
              selectedIcon: const Icon(Icons.star),
              label: l10n.navRated,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}

/// Pestaña "Mi biblioteca": buscador + orden + conmutador Biblioteca / Leídos
/// + lista.
class _BookListTab extends StatefulWidget {
  const _BookListTab({required this.onAddBook});

  final VoidCallback onAddBook;

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
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColorDark.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: cubit.setQuery,
                        decoration: InputDecoration(
                          hintText: context.l10n.searchBookHint,
                          filled: true,
                          fillColor: context.colors.surface,
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
                  ),
                  const SizedBox(width: 8),
                  _SortButton(selected: state.sort, onChanged: cubit.setSort),
                ],
              ),
            ),
            _SegmentedToggle(
              selected: state.tab,
              onChanged: cubit.setTab,
            ),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.visibleBooks.isEmpty
                      ? (state.query.isEmpty && state.tab == LibraryTab.all
                          ? _EmptyLibraryOnboarding(onAddBook: widget.onAddBook)
                          : _BooksList(
                              books: const [],
                              loading: false,
                              emptyMessage: context.l10n.noResultsHint,
                            ))
                      : _BooksList(books: state.visibleBooks, loading: false),
            ),
          ],
        );
      },
    );
  }
}

/// Botón de orden: icono + menú desplegable con las opciones de [LibrarySort].
class _SortButton extends StatelessWidget {
  const _SortButton({required this.selected, required this.onChanged});

  final LibrarySort selected;
  final ValueChanged<LibrarySort> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String labelFor(LibrarySort s) => switch (s) {
          LibrarySort.recent => l10n.sortRecent,
          LibrarySort.titleAsc => l10n.sortTitle,
          LibrarySort.authorAsc => l10n.sortAuthor,
          LibrarySort.ratingDesc => l10n.sortRating,
        };

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColorDark.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: PopupMenuButton<LibrarySort>(
        tooltip: l10n.sortLabel,
        initialValue: selected,
        onSelected: onChanged,
        icon: const Icon(Icons.sort, color: primaryColorDark),
        itemBuilder: (context) => [
          for (final s in LibrarySort.values)
            PopupMenuItem(
              value: s,
              child: Row(
                children: [
                  if (s == selected)
                    const Icon(Icons.check, size: 18, color: primaryColorDark)
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 10),
                  Text(labelFor(s)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Estado vacío accionable de la biblioteca (onboarding): explica qué hacer y
/// ofrece un botón directo para añadir el primer libro.
class _EmptyLibraryOnboarding extends StatelessWidget {
  const _EmptyLibraryOnboarding({required this.onAddBook});

  final VoidCallback onAddBook;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 56, color: primaryColorDark.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              l10n.emptyLibraryTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: Fonts.muliBold, fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyLibraryHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.onSurfaceMuted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColorDark,
                foregroundColor: whiteRed,
              ),
              onPressed: onAddBook,
              icon: const Icon(Icons.add),
              label: Text(l10n.emptyLibraryCta),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({required this.selected, required this.onChanged});

  final LibraryTab selected;
  final ValueChanged<LibraryTab> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget segment(String label, LibraryTab tab) {
      final active = selected == tab;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(tab),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: active ? primaryColorDark : transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: active ? whiteRed : primaryColorDark,
                  fontFamily: Fonts.muliBold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      decoration: BoxDecoration(
        color: context.colors.trackBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          segment(l10n.segmentAll, LibraryTab.all),
          segment(l10n.segmentRead, LibraryTab.read),
        ],
      ),
    );
  }
}

/// Pestaña "Valorados": los libros con valoración > 0.
class _RatedTab extends StatelessWidget {
  const _RatedTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final rated = state.books.where((b) => b.isRated).toList();
          return _BooksList(
            books: rated,
            loading: state.loading,
            emptyMessage: context.l10n.emptyRatedHint,
          );
        },
      ),
    );
  }
}

class _BooksList extends StatelessWidget {
  const _BooksList({
    required this.books,
    required this.loading,
    this.emptyMessage,
  });

  final List<Book> books;
  final bool loading;

  /// Texto del estado vacío; si se omite usa [emptyLibrary].
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage ?? context.l10n.emptyLibrary,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.onSurfaceMuted),
          ),
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
