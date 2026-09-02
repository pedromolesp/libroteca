import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';

/// Fila de la lista de la biblioteca. Portada de `ItemListBook`; la navegación
/// ya no depende de `then((value){ if (value) ... })` (donde `value` podía ser
/// `null` y reventaba): al volver del detalle se recarga vía [LibraryCubit].
class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      alignment: Alignment.centerRight,
      child: Material(
        color: white24,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: InkWell(
          onTap: () async {
            await context.pushNamed(
              RouteNames.bookDetail,
              pathParameters: {'id': '${book.id}'},
              extra: book,
            );
            if (context.mounted) context.read<LibraryCubit>().load();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.015,
              horizontal: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: size.height * 0.08,
                  height: size.height * 0.08,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: fillerGrey,
                        offset: Offset(0, 1),
                        spreadRadius: 0.2,
                      ),
                    ],
                  ),
                  child: Image.asset(AppAssets.bookPlaceholder),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        book.titulo ?? 'Sin título',
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: black,
                          fontFamily: Fonts.muliBold,
                          fontSize: 18,
                        ),
                      ),
                      AutoSizeText(
                        book.autor ?? 'Autor desconocido',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        minFontSize: 14,
                        style: TextStyle(
                          color: black,
                          fontFamily: Fonts.muliRegular,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      const Divider(height: 1, color: primaryColor),
                      Row(
                        children: [
                          Icon(
                            book.isRead ? Icons.check : Icons.close,
                            color: book.isRead ? green : red,
                            size: size.height * 0.02,
                          ),
                          Icon(
                            book.isRated ? Icons.star : Icons.star_border,
                            color: black,
                            size: size.height * 0.02,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
