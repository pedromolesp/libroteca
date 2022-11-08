import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/view/book-list/book_list_page.dart';

class BookRatedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: orangeLight,
      child: BookList(
        listKind: "grid",
      ),
    );
  }
}
