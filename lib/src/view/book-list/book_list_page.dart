import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libroteca/src/data/controllers/api_request.dart';
import 'package:libroteca/src/data/controllers/getx/book_controller.dart';
import 'package:libroteca/src/data/controllers/getx/book_list_view_controller.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/models/google_api_book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/book-list/item_grid_book.dart';
import 'package:libroteca/src/view/book-list/item_list_book.dart';

class BookListPage extends StatelessWidget {
  String search = "";
  bool dragging = false;
  final BookViewController bookViewController = Get.put(BookViewController());

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return GetX<BookViewController>(
      init: bookViewController,
      builder: (BookViewController bookViewController) {
        return Scaffold(
          backgroundColor: primaryColorLight,
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: whiteRed,
            ),
            backgroundColor: primaryColorDark,
            onPressed: () {
              // Get.to(
              //   () => CreateEditBook(),
              // );
              Navigator.pushNamed(context, "create");
            },
          ),
          appBar: buildAppBar(
            size,
            bookViewController,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: BookList(
              tabSelected: bookViewController.tabSelected.value,
            ),
          ),
        );

        // BookList(DBProvider.db.getReadBooks()),
      },
    );
  }

  AppBar buildAppBar(Size size, BookViewController bookViewController) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: primaryColorDark,
      centerTitle: true,
      title: Container(
        width: size.width,
        height: size.height * 0.08,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: size.width * 0.4,
              height: size.height * 0.07,
              child: Material(
                color: bookViewController.tabSelected.value == 0
                    ? orangeLight
                    : primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: InkWell(
                  onTap: () {
                    if (bookViewController.tabSelected.value != 0) {
                      bookViewController.change(0);
                    }
                  },
                  child: Center(
                    child: Text(
                      "Biblioteca",
                      style: TextStyle(
                          color: bookViewController.tabSelected.value == 0
                              ? black
                              : white,
                          fontFamily: Fonts.muliBold,
                          fontSize: size.width * 0.05),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            ),
            Container(
              width: size.width * 0.4,
              height: size.height * 0.07,
              child: Material(
                color: bookViewController.tabSelected.value == 1
                    ? orangeLight
                    : primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: InkWell(
                  onTap: () {
                    if (bookViewController.tabSelected.value != 1) {
                      bookViewController.change(1);
                    }
                  },
                  child: Center(
                    child: Text(
                      "Leídos",
                      style: TextStyle(
                          color: bookViewController.tabSelected.value == 1
                              ? black
                              : white,
                          fontFamily: Fonts.muliBold,
                          fontSize: size.width * 0.05),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}

class BookList extends StatefulWidget {
  String listKind;
  int? tabSelected;

  BookList({
    this.listKind = "list",
    this.tabSelected,
    Key? key,
  });

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  Future<List<Book>>? booksRequest;

  List<Book?> books = [];

  TextEditingController? _controller;

  String search = "";

  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    final size = getMediaSize(context);
    _controller = new TextEditingController(text: search);

    return GetX<BookController>(
      init: bookController,
      builder: (ctrl) {
        if (widget.tabSelected == 0) {
          bookController.initBookListFromDB();
          books = bookController.bookList.value;
        } else {
          bookController.initReadBookListFromDB();
          books = bookController.bookListRead.value;
        }
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Builder(
            builder: (BuildContext context) {
              if (books != null && books.length > 0)
                books = filterBySearch(books);
              if (widget.listKind == null || widget.listKind == "list") {
                return Stack(
                  children: [
                    getListView(size),
                    getSearchView(size),
                  ],
                );
              } else if (widget.listKind == "grid") {
                return Stack(
                  children: [
                    // getGridView(size),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.03),
                      child: getSearchView(size),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  // Widget getGridView(size) {
  Widget getListView(Size size) {
    return ListView.builder(
      padding:
          EdgeInsets.only(top: size.height * 0.13, bottom: size.height * 0.05),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ItemListBook(books[index]);
      },
      itemCount: books.length,
    );
  }

  getSearchView(Size size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.07,
              width: size.width * 0.7,
              margin: EdgeInsets.only(top: size.height * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        color: black20,
                        offset: Offset(0.0, 1.0),
                        spreadRadius: 1),
                  ]),
              padding: EdgeInsets.all(size.height * 0.01),
              child: Center(
                child: Material(
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: Fonts.muliBold,
                      color: textActiveColor,
                    ),
                    controller: _controller,
                    cursorColor: secondaryColor,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontFamily: Fonts.muliBold,
                        color: textActiveColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {},
                      ),
                      labelText: "Busca un libro  ",
                      labelStyle: TextStyle(
                        fontFamily: Fonts.muliBold,
                        color: textActiveColor,
                      ),
                      fillColor: white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: secondaryColor, width: size.width * 0.005),
                      ),
                    ),
                    onChanged: (v) async {
                      if (v.length > 1) {
                        setState(() {
                          search = v;
                        });
                      }
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
          height: size.height * 0.6,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 3,
                    color: black20,
                    offset: Offset(0.0, 2.0))
              ]),
          child: FutureBuilder(
              future: ApiRequest().fetchGoogleApiBook(search),
              builder: (context, snapshot) {
                return ListView.builder(itemBuilder: (context, index) {
                  if (snapshot.data != null && snapshot.data!.items != null) {
                    return ItemGridBook(snapshot.data?.items![index]);
                  } else {
                    return SizedBox.shrink();
                  }
                });
              }),
        )
      ],
    );
  }

  List<Book?> filterBySearch(List<Book?> books) {
    List<Book?> booksFilter = [];
    if (search.isEmpty) {
      return books;
    } else {
      books.forEach((book) {
        if (book!.autor!.toLowerCase().contains(search) ||
            book.titulo!.toLowerCase().contains(search)) {
          booksFilter.add(book);
        }
      });
      return booksFilter;
    }
  }
}
