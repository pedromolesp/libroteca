import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/catalog/domain/model/google_book.dart';
import 'package:tomora/features/catalog/presentation/bloc/book_search_cubit.dart';

/// Hoja modal para buscar en Google Books y elegir un libro con el que
/// prerrellenar el formulario. Sustituye al `FutureBuilder` en línea de la
/// lista, que creaba un future por rebuild y usaba un `ListView.builder` sin
/// `itemCount` (→ `RangeError`).
class BookSearchSheet extends StatelessWidget {
  const BookSearchSheet({super.key});

  /// Abre la hoja y devuelve el libro elegido, o `null` si se cierra.
  static Future<GoogleBook?> show(BuildContext context) {
    return showModalBottomSheet<GoogleBook>(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const BookSearchSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookSearchCubit>(),
      child: const _SheetBody(),
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                onChanged: context.read<BookSearchCubit>().queryChanged,
                decoration: const InputDecoration(
                  hintText: 'Título, autor o ISBN',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Expanded(child: _Results()),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookSearchCubit, BookSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStatus.idle:
            return const _Hint('Escribe para buscar en Google Books');
          case SearchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case SearchStatus.empty:
            return const _Hint('Sin resultados');
          case SearchStatus.error:
            return _ErrorHint(
              message: state.errorMessage ?? 'No se pudo buscar.',
              onRetry: context.read<BookSearchCubit>().retry,
            );
          case SearchStatus.success:
            return ListView.separated(
              itemCount: state.results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final book = state.results[index];
                return ListTile(
                  leading: book.thumbnail != null
                      ? Image.network(book.thumbnail!,
                          width: 40, fit: BoxFit.cover)
                      : const Icon(Icons.menu_book),
                  title: Text(book.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(book.authorsLabel,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(context).pop(book),
                );
              },
            );
        }
      },
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: greyText, fontFamily: Fonts.muliRegular),
        ),
      ),
    );
  }
}

class _ErrorHint extends StatelessWidget {
  const _ErrorHint({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: greyText,
                fontFamily: Fonts.muliRegular,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
