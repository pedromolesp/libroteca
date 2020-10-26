import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/book-list/item_list_book.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  TextEditingController _searchController;

  int tabLibraryRead = 0;

  String search = "";

  @override
  Widget build(BuildContext context) {
    _searchController = new TextEditingController(text: search);
    Size size = getMediaSize(context);
    return Scaffold(
      backgroundColor: orangeLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: whiteRed,
        ),
        backgroundColor: orangeDark,
        onPressed: () {
          _addBook(context);
        },
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: orangeDark,
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
                  color: tabLibraryRead == 0 ? orangeLight : orangeDark,
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
                  color: tabLibraryRead == 1 ? orangeLight : orangeDark,
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
      body: tabLibraryRead == 0 ? LibraryList() : LibraryReadList(),
    );
  }

  _addBook(BuildContext context) {
    Navigator.pushNamed(context, "create");
  }
}

class LibraryList extends StatelessWidget {
  const LibraryList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBProvider.db.getAllBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasData == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Book> books = [];
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
            books = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ItemListBook(books[index]);
            },
            itemCount: books.length,
          );
        }
      },
    );
  }
}

class LibraryReadList extends StatelessWidget {
  const LibraryReadList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBProvider.db.getAllReadBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasData == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Book> books = [];
          if (snapshot.data != null && snapshot.data.length > 0)
            books = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ItemListBook(books[index]);
            },
            itemCount: books.length,
          );
        }
      },
    );
  }
}
