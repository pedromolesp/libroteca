import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class DetailBookPage extends StatelessWidget {
  Book book;
  @override
  Widget build(BuildContext context) {
    book = ModalRoute.of(context).settings.arguments;
    final size = getMediaSize(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Container(
          width: size.width * 0.8,
          child: AutoSizeText(
            book?.titulo ?? "Detalle",
            maxLines: 1,
            minFontSize: 16,
            maxFontSize: 22,
            style: TextStyle(
              fontFamily: Fonts.muliBold,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Center(
              child: Container(
                width: size.width * 0.8,
                child: AutoSizeText(
                  // book?.titulo ??
                  "Esta parte está en obras",
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  minFontSize: 16,
                  maxFontSize: 26,
                  style: TextStyle(
                      fontFamily: Fonts.muliBold, fontSize: size.width * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
