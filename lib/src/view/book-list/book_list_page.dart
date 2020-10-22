import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/book-list/item_list_book.dart';

class BookListPage extends StatelessWidget {
  TextEditingController _searchController;
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
                    color: orangeDark,
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Biblioteca",
                          style: TextStyle(
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
                    color: orangeDark,
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Leídos",
                          style: TextStyle(
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
        body: FutureBuilder(
          future: DBProvider.db.getAllBooks(),
          builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.hasData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Book> books = [];
              Book book = new Book(
                  autor: "Joan Manuel Gisbert",
                  edicion: "1",
                  editorial: "Alfaguara",
                  estado: 1,
                  fechaPublicacion: "2005-02-02",
                  genero: "Terror",
                  id: 0,
                  idioma: "Español",
                  leido: "Si",
                  nombrePrestamo: "",
                  paginas: 240,
                  tapa: 0,
                  titulo: "Los armarios negros");
              books.add(book);
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
        ));
  }

  _addBook(BuildContext context) {
    Navigator.pushNamed(context, "create");
  }
}
