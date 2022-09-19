import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/navigation_refresh.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/book-list/item_grid_book.dart';
import 'package:libroteca/src/view/book-list/item_list_book.dart';
import 'package:libroteca/src/view/create/create_book.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  TextEditingController _searchController;

  int tabLibraryRead = 0;

  String search = "";
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    _searchController = new TextEditingController(text: search);
    Size size = getMediaSize(context);
    return Scaffold(
      backgroundColor: primaryColorLight,
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: whiteRed,
        ),
        backgroundColor: primaryColorDark,
        onPressed: () {
          _addBook(context);
        },
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: primaryColorDark,
        centerTitle: true,
        title: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.4,
                height: size.height * 0.1,
                child: Material(
                  color: tabLibraryRead == 0 ? orangeLight : primaryColor,
                  child: InkWell(
                    onTap: () {
                      tabLibraryRead != 0
                          ? setState(() {
                              tabLibraryRead = 0;
                            })
                          : {};
                    },
                    child: Center(
                      child: Text(
                        "Biblioteca",
                        style: TextStyle(
                            color: tabLibraryRead == 0 ? black : white,
                            fontFamily: Fonts.muliBold,
                            fontSize: size.width * 0.05),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.4,
                height: size.height * 0.1,
                child: Material(
                  color: tabLibraryRead == 1 ? orangeLight : primaryColor,
                  child: InkWell(
                    onTap: () {
                      tabLibraryRead != 1
                          ? setState(() {
                              tabLibraryRead = 1;
                            })
                          : {};
                    },
                    child: Center(
                      child: Text(
                        "Leídos",
                        style: TextStyle(
                            color: tabLibraryRead == 1 ? black : white,
                            fontFamily: Fonts.muliBold,
                            fontSize: size.width * 0.05),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: tabLibraryRead == 0
          ? BookList(DBProvider.db.getAllBooks())
          : BookList(DBProvider.db.getReadBooks()),
    );
  }

  _addBook(BuildContext context) {
    navigateAndRefresh(context, CreateEditBook()).then((value) {
      if (value) {
        setState(() {});
      }
    });
  }
}

class BookList extends StatefulWidget {
  Future<List<Book>> booksRequest;
  String listKind;
  BookList(
    this.booksRequest, {
    this.listKind,
    Key key,
  }) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> books = [];
  TextEditingController _controller;
  String search;
  @override
  void initState() {
    super.initState();
    search = "";
  }

  @override
  Widget build(BuildContext context) {
    final size = getMediaSize(context);
    _controller = new TextEditingController(text: search);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: FutureBuilder(
        future: widget.booksRequest,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.hasData == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Book book = new Book(
            //     autor: "Joan Manuel Gisbert",
            //     edicion: "1",
            //     editorial: "Alfaguara",
            //     estado: 1,
            //     fechaPublicacion: "2005-02-02",
            //     genero: "Terror",
            //     id: 0,
            //     idioma: "Español",
            //     leido: "Si",
            //     nombrePrestamo: "",
            //     paginas: 240,
            //     tapa: 0,
            //     titulo: "Los armarios negros");
            // books.add(book);

            if (snapshot.data != null && snapshot.data.length > 0)
              books = filterBySearch(snapshot.data);
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
                  getGridView(size),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.03),
                    child: getSearchView(size),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  Widget getGridView(size) {
    return GridView.builder(
      itemCount: books.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(
          left: size.width * 0.01,
          right: size.width * 0.01,
          top: size.height * 0.15,
          bottom: size.height * 0.05),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ItemGridBook(books[index]);
      },
    );
  }

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.1,
          width: size.width * 0.7,
          margin: EdgeInsets.only(top: size.height * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: primaryBackgroundColor,
              boxShadow: [
                BoxShadow(
                    blurRadius: 7,
                    color: black20,
                    offset: Offset(0.0, 2.0),
                    spreadRadius: 1),
              ]),
          padding: EdgeInsets.all(size.height * 0.01),
          child: Material(
            child: TextFormField(
              style: TextStyle(
                fontFamily: Fonts.muliBold,
                color: textActiveColor,
              ),
              controller: _controller,
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: secondaryColor, width: size.width * 0.005),
                ),
                hintStyle: TextStyle(
                  fontFamily: Fonts.muliBold,
                  color: textActiveColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      search = "";
                    });
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
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
              onChanged: (v) {
                setState(() {
                  search = v;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      ],
    );
  }

  List<Book> filterBySearch(List<Book> books) {
    List<Book> booksFilter = [];
    if (search.isEmpty) {
      return books;
    } else {
      books.forEach((book) {
        if (book.autor.toLowerCase().contains(search) ||
            book.titulo.toLowerCase().contains(search)) {
          booksFilter.add(book);
        }
      });
      return booksFilter;
    }
  }
}
