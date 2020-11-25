import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/estado_by_number_method.dart';
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
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            top: size.height * 0.03,
            right: size.width * 0.05,
            left: size.width * 0.05),
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    book.titulo,
                    minFontSize: 12,
                    maxFontSize: 22,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: black,
                      fontSize: size.width * 0.045,
                      fontFamily: Fonts.muliBlack,
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    book.autor,
                    minFontSize: 12,
                    maxFontSize: 22,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: black,
                      fontSize: size.width * 0.045,
                      fontFamily: Fonts.muliRegular,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                  padding: EdgeInsets.all(10),
                  child: Image.asset("assets/images/book_placeholder.png"),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: yellow),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.9,
                  child: AutoSizeText(
                    "Publicación: " +
                        (book.fechaPublicacion.isNotEmpty
                            ? book.fechaPublicacion
                            : "No ha sido indicada una fecha"),
                    minFontSize: 12,
                    maxFontSize: 22,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: size.width * 0.035,
                      fontFamily: Fonts.muliBold,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.35,
                              child: AutoSizeText(
                                "Nº páginas: " +
                                    (book.paginas is int
                                        ? book.paginas.toString()
                                        : "Nº páginas no indicado"),
                                minFontSize: 12,
                                maxFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: black,
                                  fontSize: size.width * 0.035,
                                  fontFamily: Fonts.muliRegular,
                                ),
                              ),
                            ),
                            book.paginas is int
                                ? Container(
                                    width: size.width * 0.05,
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.lens,
                                      color: getColorByNumOfPages(book.paginas),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          width: size.width * 0.45,
                          child: AutoSizeText(
                            "Editorial: " +
                                (book.editorial.isNotEmpty
                                    ? book.editorial
                                    : "No ha sido indicada una editorial"),
                            minFontSize: 12,
                            maxFontSize: 22,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: black,
                              fontSize: size.width * 0.035,
                              fontFamily: Fonts.muliRegular,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          width: size.width * 0.45,
                          child: AutoSizeText(
                            "Idioma: " +
                                (book.idioma.isNotEmpty
                                    ? book.idioma
                                    : "No ha sido indicado un idioma"),
                            minFontSize: 12,
                            maxFontSize: 22,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: black,
                              fontSize: size.width * 0.035,
                              fontFamily: Fonts.muliRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            (book.estado != null)
                                ? Container(
                                    width: size.width * 0.05,
                                    alignment: Alignment.centerRight,
                                    child: Center(
                                        child: getIconByEstado(book.estado)))
                                : Container(),
                            Container(
                              width: size.width * 0.35,
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                "Estado: " +
                                    (book.estado != null
                                        ? getEstadoByNumber(book.estado)
                                        : "Estado no indicado"),
                                minFontSize: 12,
                                maxFontSize: 22,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: black,
                                  fontSize: size.width * 0.035,
                                  fontFamily: Fonts.muliRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        getEditionView(size),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        getGenView(size),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        getPaperTypeView(size)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container getPaperTypeView(size) {
    return Container(
                        width: size.width * 0.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              width: size.width * 0.05,
                              child: Image.asset(book.tapa == 1
                                  ? "assets/images/diamond.png"
                                  : "assets/images/papel.png"),
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                "Tapa: " +
                                    (book.tapa != null
                                        ? (book.tapa == 1 ? "Dura" : "Blanda")
                                        : "No ha sido indicado un tipo de tapa"),
                                minFontSize: 12,
                                maxFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: black,
                                  fontSize: size.width * 0.035,
                                  fontFamily: Fonts.muliRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
  }

  Container getGenView(size) {
    return Container(
                        width: size.width * 0.45,
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          "Género: " +
                              (book.genero.isNotEmpty
                                  ? book.genero
                                  : "No ha sido indicado un género"),
                          minFontSize: 12,
                          maxFontSize: 22,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: black,
                            fontSize: size.width * 0.035,
                            fontFamily: Fonts.muliRegular,
                          ),
                        ),
                      );
  }

  Container getEditionView(size) {
    return Container(
                        width: size.width * 0.45,
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          "Edición: " +
                              (book.edicion.isNotEmpty
                                  ? book.edicion
                                  : "No ha sido indicada una edición"),
                          minFontSize: 12,
                          maxFontSize: 22,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: black,
                            fontSize: size.width * 0.035,
                            fontFamily: Fonts.muliRegular,
                          ),
                        ),
                      );
  }

  //Este método devuelve un objeto tipo Icon al
  //pasarle un número de estado del libro
  Widget getIconByEstado(int number) {
    Icon icon;
    switch (number) {
      case 0:
        icon = new Icon(
          Icons.close,
          color: red,
        );
        break;
      case 1:
        icon = new Icon(
          Icons.check,
          color: Colors.green,
        );
        break;
      case 2:
        icon = new Icon(
          Icons.face,
          color: orangeDark,
        );
        break;
    }
    return icon;
  }

  Color getColorByNumOfPages(int number) {
    if (number < 100) {
      return Colors.lightGreen;
    } else if (number >= 100 && number < 200) {
      return Colors.green;
    } else if (number >= 200 && number < 400) {
      return yellow;
    } else if (number >= 400 && number < 500) {
      return orangeDark;
    } else if (number >= 500) {
      return red;
    } else {
      return fillerGrey;
    }
  }
}
