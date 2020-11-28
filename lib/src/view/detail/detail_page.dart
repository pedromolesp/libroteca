import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/app_bar.dart';
import 'package:libroteca/src/helpers/estado_by_number_method.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class DetailBookPage extends StatefulWidget {
  @override
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  Book book;
  int rating;
  String opinion = "";
  int callOnce = 0;
  Size size;
  @override
  void initState() {
    super.initState();
    rating = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (callOnce < 1) {
      book = ModalRoute.of(context).settings.arguments;
      opinion = book.opinion ?? "";
      rating = book.valoracion;
      size = getMediaSize(context);
      callOnce++;
    }
    return Scaffold(
      backgroundColor: white,
      appBar: getAppBar(book?.titulo ?? "Detalle", true, size, context),
      body: getView(size),
    );
  }

  Container getView(size) {
    return Container(
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
              getTitleView(size),
              getAuthorView(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              getImageView(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              getPubView(size),
              SizedBox(
                height: size.height * 0.02,
              ),
              getRatingView(size),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getNumPagsView(size),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      getEditorView(size),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      getLanguajeView(size),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      getStateView(size),
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
              SizedBox(
                height: size.height * 0.02,
              ),
              getOpinionView(size)
            ],
          ),
        ],
      ),
    );
  }

  Row getStateView(size) {
    return Row(
      children: [
        (book.estado != null)
            ? Container(
                width: size.width * 0.05,
                alignment: Alignment.centerRight,
                child: Center(child: getIconByEstado(book.estado)))
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
    );
  }

  Container getImageView(size) {
    return Container(
      width: size.width * 0.3,
      height: size.width * 0.3,
      padding: EdgeInsets.all(10),
      child: Image.asset("assets/images/book_placeholder.png"),
      decoration: BoxDecoration(shape: BoxShape.circle, color: yellow),
    );
  }

  Container getAuthorView(size) {
    return Container(
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
    );
  }

  Container getTitleView(size) {
    return Container(
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
    );
  }

  Container getPubView(size) {
    return Container(
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
    );
  }

  Widget getRatingView(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.05,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            getRatingAlert(size, context, book);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.star,
                color: orangeLight,
              ),
              Icon(
                rating >= 2 ? Icons.star : Icons.star_border,
                color: orangeLight,
              ),
              Icon(
                rating >= 3 ? Icons.star : Icons.star_border,
                color: orangeLight,
              ),
              Icon(
                rating >= 4 ? Icons.star : Icons.star_border,
                color: orangeLight,
              ),
              Icon(
                rating >= 5 ? Icons.star : Icons.star_border,
                color: orangeLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row getNumPagsView(size) {
    return Row(
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
    );
  }

  Container getLanguajeView(size) {
    return Container(
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
    );
  }

  Container getEditorView(size) {
    return Container(
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

  void getRatingAlert(Size size, BuildContext context, Book book) {
    TextEditingController _opinionController = new TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        int rated = rating;
        String description = book.opinion;
        _opinionController.text = description;
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: white,
                ),
                height: size.height * 0.65,
                width: size.width * 0.9,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.03),
                child: Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowGlow();
                        return true;
                      },
                      child: Material(
                        child: ListView(
                          children: [
                            Container(
                              width: size.width * 0.9,
                              height: size.height * 0.1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.star,
                                        color: orangeLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rated = 1;
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        rated >= 2
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: orangeLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rated = 2;
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        rated >= 3
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: orangeLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rated = 3;
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        rated >= 4
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: orangeLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rated = 4;
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        rated >= 5
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: orangeLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rated = 5;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: size.height * 0.02,
                              ),
                              width: size.width,
                              height: size.height * 0.2,
                              child: TextFormField(
                                style: TextStyle(
                                  color: black,
                                  fontSize: size.width * 0.04,
                                  fontFamily: Fonts.muliBold,
                                ),
                                cursorColor: orangeDark,
                                controller: _opinionController,
                                maxLines: 15,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: orangeDark,
                                        width: size.width * 0.005),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.title,
                                    color: fillerGrey,
                                  ),
                                  hintStyle: TextStyle(
                                    color: black,
                                    fontSize: size.width * 0.04,
                                    fontFamily: Fonts.muliBold,
                                  ),
                                  labelText: "Opinión  ",
                                  labelStyle: TextStyle(
                                    color: black,
                                    fontSize: size.width * 0.04,
                                    fontFamily: Fonts.muliBold,
                                  ),
                                  fillColor: white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: orangeDark,
                                        width: size.width * 0.005),
                                  ),
                                ),
                                onChanged: (v) {
                                  description = v;
                                },
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return "Rellena el campo de título";
                                  } else
                                    return null;
                                },
                                keyboardType: TextInputType.text,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: size.height * 0.05,
                      width: size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          getButtonCancelAlert(size, context),
                          getButtonAcceptAlert(
                              size, context, description, rated),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  getButtonAcceptAlert(
      Size size, BuildContext context, String description, int rated) {
    return Center(
      child: Container(
        height: size.height * 0.065,
        width: size.width * 0.27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: red,
        ),
        margin: EdgeInsets.only(top: size.height * 0.03),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: red,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              setState(() {
                rating = rated;
                opinion = description;
              });
              book.opinion = description;
              book.valoracion = rated;
              await DBProvider.db
                  .updateBook(book)
                  .then((value) => Navigator.pop(context));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.01,
              ),
              child: Center(
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                    color: white,
                    fontSize: size.width * 0.045,
                    fontFamily: Fonts.muliBold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getButtonCancelAlert(Size size, BuildContext context) {
    return Center(
      child: Container(
        height: size.height * 0.065,
        width: size.width * 0.27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: red,
        ),
        margin: EdgeInsets.only(top: size.height * 0.03),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: red,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.01,
              ),
              child: Center(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                      color: white,
                      fontSize: size.width * 0.045,
                      fontFamily: Fonts.muliBold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getOpinionView(size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      child: AutoSizeText(
        book.opinion,
        maxLines: null,
        minFontSize: 12,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: black,
          fontFamily: Fonts.muliLight,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
