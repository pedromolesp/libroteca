import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class ItemGridBook extends StatefulWidget {
  Book? book;
  ItemGridBook(this.book);

  @override
  _ItemGridBookState createState() => _ItemGridBookState();
}

class _ItemGridBookState extends State<ItemGridBook>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation? animation;
  Book? book;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    book = widget.book;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return getBodyView(size, context);
  }

  Widget getBodyView(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.01),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: white.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            openDialogOpinion(size, context, book);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  book!.titulo!,
                  maxLines: 2,
                  maxFontSize: 22,
                  minFontSize: 12,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Fonts.muliBold,
                    fontSize: size.width * 0.04,
                    color: textActiveColor,
                  ),
                ),
                AutoSizeText(
                  book!.autor!,
                  maxLines: 2,
                  maxFontSize: 22,
                  minFontSize: 12,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Fonts.muliSemiBold,
                    fontSize: size.width * 0.04,
                    color: textSecondaryColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                getRatingView(size),
                getRate(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRatingView(Size size) {
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.05,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star,
            color: orangeLight,
          ),
          Icon(
            book!.valoracion! >= 2 ? Icons.star : Icons.star_border,
            color: orangeLight,
          ),
          Icon(
            book!.valoracion! >= 3 ? Icons.star : Icons.star_border,
            color: orangeLight,
          ),
          Icon(
            book!.valoracion! >= 4 ? Icons.star : Icons.star_border,
            color: orangeLight,
          ),
          Icon(
            book!.valoracion! >= 5 ? Icons.star : Icons.star_border,
            color: orangeLight,
          ),
        ],
      ),
    );
  }

  getRate(Size size) {
    return Container(
      height: size.height * 0.05,
      child: AutoSizeText(
        book!.opinion!,
        maxLines: 2,
        maxFontSize: 22,
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: Fonts.muliRegular,
          fontSize: size.width * 0.04,
          color: textSecondaryColor,
        ),
      ),
    );
  }

  void openDialogOpinion(Size size, BuildContext context, Book? book) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: white,
            ),
            height: size.height * 0.75,
            width: size.width * 0.9,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Opinión de ${book!.titulo}',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontFamily: Fonts.muliBlack,
                    color: black,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                getRatingView(size),
                Container(
                  height: size.height * 0.4,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView(
                        padding: EdgeInsets.only(right: size.width * 0.03),
                        controller: _scrollController,
                        children: [
                          AutoSizeText(
                            book.opinion!,
                            maxLines: null,
                            textAlign: TextAlign.justify,
                            minFontSize: 12,
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: black,
                              fontFamily: Fonts.muliLight,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    getButtonBackAlert(size, context),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  getButtonBackAlert(Size size, BuildContext context) {
    return Center(
      child: Container(
        height: size.height * 0.065,
        width: size.width * 0.27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: primaryColor,
        ),
        margin: EdgeInsets.only(top: size.height * 0.03),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: primaryColor,
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
                  "Volver",
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
}
