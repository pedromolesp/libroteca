import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/bloc/book_detail_cubit.dart';

/// Detalle de un libro. Portado de `DetailBookPage`:
///  - era un `StatelessWidget` con estado mutable (`book`, `rating`, `callOnce`,
///    `_scrollController` sin liberar) — ahora `StatefulWidget` + [BookDetailCubit];
///  - los `book!.campo = ...` (que no compilan contra un modelo inmutable) pasan
///    por el cubit (`setRating` / `setOpinion` / `save`);
///  - las 15 funciones `getXxxView` casi idénticas se reducen a un `_InfoRow`.
class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book? book;

  @override
  Widget build(BuildContext context) {
    final b = book;
    if (b == null) {
      return const Scaffold(body: Center(child: Text('Libro no encontrado')));
    }
    return BlocProvider(
      create: (_) => BookDetailCubit(getIt<BookRepository>(), b),
      child: const _DetailScaffold(),
    );
  }
}

class _DetailScaffold extends StatefulWidget {
  const _DetailScaffold();

  @override
  State<_DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<_DetailScaffold> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  String _titleCase(String? raw) {
    final t = (raw ?? '').trim();
    if (t.isEmpty) return AppConstants.appName;
    return t[0].toUpperCase() + t.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailCubit, BookDetailState>(
      builder: (context, state) {
        final book = state.book;
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: primaryColorDark,
            title: Text(
              _titleCase(book.titulo),
              style: const TextStyle(color: white, fontFamily: Fonts.muliBold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: white),
                onPressed: () async {
                  await context.pushNamed(
                    RouteNames.bookEdit,
                    pathParameters: {'id': '${book.id}'},
                    extra: book,
                  );
                  if (context.mounted) {
                    final fresh =
                        await getIt<BookRepository>().getById(book.id ?? -1);
                    if (fresh != null && context.mounted) {
                      context.read<BookDetailCubit>().setBook(fresh);
                    }
                  }
                },
              ),
            ],
          ),
          body: Scrollbar(
            controller: _scroll,
            thumbVisibility: true,
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: AutoSizeText(
                    book.titulo ?? 'Sin título',
                    maxLines: 2,
                    style: const TextStyle(
                      color: black,
                      fontSize: 22,
                      fontFamily: Fonts.muliBlack,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    book.autor ?? 'Autor desconocido',
                    style: const TextStyle(
                        color: black, fontFamily: Fonts.muliRegular),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: yellow),
                    child: Image.asset(AppAssets.bookPlaceholder),
                  ),
                ),
                const SizedBox(height: 24),
                _RatingBar(
                  rating: state.rating,
                  onTap: () => _openRatingDialog(context),
                ),
                const SizedBox(height: 12),
                _ReadToggle(
                  isRead: book.isRead,
                  onToggle: () {
                    final cubit = context.read<BookDetailCubit>();
                    cubit.setBook(
                      book.copyWith(leido: book.isRead ? 'No' : 'Si'),
                    );
                    cubit.save();
                  },
                ),
                const Divider(height: 32),
                _InfoRow('Publicación', book.fechaPublicacion),
                _InfoRow('Nº páginas', book.paginas?.toString()),
                _InfoRow('Editorial', book.editorial),
                _InfoRow('Idioma', book.idioma),
                _InfoRow('Estado', _estadoLabel(book.estado)),
                _InfoRow('Edición', book.edicion),
                _InfoRow('Género', book.genero),
                _InfoRow('Tapa', _tapaLabel(book.tapa)),
                const Divider(height: 32),
                const Text(
                  'Opinión',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: Fonts.muliBold,
                    color: black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (book.opinion?.isNotEmpty ?? false)
                      ? book.opinion!
                      : 'Aún no has escrito una opinión',
                  style: TextStyle(
                    color:
                        (book.opinion?.isNotEmpty ?? false) ? black : greyText,
                    fontFamily: Fonts.muliLight,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openRatingDialog(BuildContext context) async {
    final cubit = context.read<BookDetailCubit>();
    final result = await showDialog<({int rating, String opinion})>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _RatingDialog(
        initialRating: cubit.state.rating,
        initialOpinion: cubit.state.opinion,
      ),
    );
    if (result == null) return;
    cubit
      ..setRating(result.rating)
      ..setOpinion(result.opinion);
    await cubit.save();
  }

  static String? _estadoLabel(int? estado) => switch (estado) {
        0 => 'No disponible',
        1 => 'En posesión',
        2 => 'Prestado',
        _ => null,
      };

  static String? _tapaLabel(int? tapa) => switch (tapa) {
        0 => 'Blanda',
        1 => 'Dura',
        _ => null,
      };
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text('$label:',
                style:
                    const TextStyle(fontFamily: Fonts.muliBold, color: black)),
          ),
          Expanded(
            child: Text(
              (value == null || value!.isEmpty) ? 'No indicado' : value!,
              style:
                  const TextStyle(fontFamily: Fonts.muliRegular, color: black),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.rating, required this.onTap});

  final int rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  color: primaryColorDark,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadToggle extends StatelessWidget {
  const _ReadToggle({required this.isRead, required this.onToggle});

  final bool isRead;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Leído', style: TextStyle(fontFamily: Fonts.muliBold)),
        const SizedBox(height: 4),
        Material(
          color: (isRead ? green : red).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                isRead ? Icons.check : Icons.close,
                color: isRead ? green : red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog({
    required this.initialRating,
    required this.initialOpinion,
  });

  final int initialRating;
  final String initialOpinion;

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  late int _rating = widget.initialRating;
  late final TextEditingController _opinion =
      TextEditingController(text: widget.initialOpinion);

  @override
  void dispose() {
    _opinion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      title: const Text('Tu valoración'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    i <= _rating ? Icons.star : Icons.star_border,
                    color: orangeLight,
                  ),
                  onPressed: () => setState(() => _rating = i),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _opinion,
            maxLines: 5,
            cursorColor: primaryColor,
            decoration: const InputDecoration(labelText: 'Opinión'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () => Navigator.of(context).pop(
            (rating: _rating, opinion: _opinion.text.trim()),
          ),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
