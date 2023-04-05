import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/navigation_refresh.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/detail/detail_page.dart';

class ItemListBook extends StatefulWidget {
  Book? book;
  ItemListBook(this.book);

  @override
  _ItemListBookState createState() => _ItemListBookState();
}

class _ItemListBookState extends State<ItemListBook>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  Book? book;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller.forward();
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

  Container getBodyView(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      width: size.width,
      height: size.height * 0.1,
      alignment: Alignment.centerRight,
      child: FadeTransition(
        opacity: animation as Animation<double>,
        child: Material(
          color: white24,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: InkWell(
            onTap: () {
              navigateAndRefresh(context, DetailBookPage(), arguments: book)
                  .then((value) {
                if (value) {
                  setState(() {});
                }
              });
            },
            child: Container(
              width: size.width * 0.95,
              height: size.height * 0.13,
              decoration: BoxDecoration(
                color: white24,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.height * 0.08,
                    height: size.height * 0.08,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white70,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: fillerGrey,
                            offset: Offset(0.0, 1.0),
                            spreadRadius: 0.2)
                      ],
                    ),
                    child: Image.asset("assets/images/book_placeholder.png"),
                  ),
                  Container(
                    width: size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.6,
                          child: AutoSizeText(
                            widget.book!.titulo!,
                            minFontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: black,
                              fontFamily: Fonts.muliBold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          widget.book!.autor!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          minFontSize: 14,
                          style: TextStyle(
                            color: black,
                            fontFamily: Fonts.muliRegular,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Divider(
                          height: 1,
                          color: primaryColor,
                        ),
                        Container(
                          width: size.width * 0.6,
                          child: Row(
                            children: [
                              Icon(
                                book!.leido == "Si" ? Icons.check : Icons.close,
                                color: book!.leido == "Si" ? green : red,
                                size: size.height * 0.02,
                              ),
                              Icon(
                                book!.valoracion != null &&
                                        book!.valoracion! > 0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: black,
                                size: size.height * 0.02,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.05,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
