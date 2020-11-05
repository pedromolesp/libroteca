import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class ItemListBook extends StatefulWidget {
  Book book;
  ItemListBook(this.book);

  @override
  _ItemListBookState createState() => _ItemListBookState();
}

class _ItemListBookState extends State<ItemListBook>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Dismissible(
      background: AnimatedContainer(
        duration: Duration(seconds: 1),
        width: size.width * 0.2,
        height: size.height * 0.08,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
        color: orangeDark,
        child: Icon(
          Icons.delete,
          color: white,
        ),
      ),
      direction: DismissDirection.endToStart,
      key: Key(widget.book.id.toString()),
      onDismissed: (direction) async {
        await DBProvider.db.deleteBook(widget.book.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
        width: size.width,
        height: size.height * 0.1,
        alignment: Alignment.centerRight,
        child: FadeTransition(
          opacity: animation,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "detail", arguments: widget.book);
            },
            child: Material(
              color: white24,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "detail",
                      arguments: widget.book);
                },
                child: Container(
                  width: size.width * 0.95,
                  height: size.height * 0.1,
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
                            shape: BoxShape.circle, color: Colors.white38),
                        child:
                            Image.asset("assets/images/book_placeholder.png"),
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
                                widget.book.titulo,
                                minFontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: black,
                                  fontFamily: Fonts.muliBold,
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                            ),
                            AutoSizeText(
                              widget.book.autor,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              minFontSize: 14,
                              style: TextStyle(
                                color: black,
                                fontFamily: Fonts.muliRegular,
                                fontSize: size.width * 0.04,
                              ),
                            ),
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
        ),
      ),
    );
  }
}
