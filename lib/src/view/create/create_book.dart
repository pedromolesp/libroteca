import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:libroteca/src/data/controllers/api_request.dart';
import 'package:libroteca/src/data/controllers/getx/book_controller.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/app_bar.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
import 'package:libroteca/src/models/google_api_book.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class CreateEditBook extends StatefulWidget {
  @override
  _CreateEditBookState createState() => _CreateEditBookState();
}

class _CreateEditBookState extends State<CreateEditBook> {
  TextStyle? ts;

  TextEditingController? _tituloController;
  TextEditingController? _isbnController;
  TextEditingController? _yearController;

  TextEditingController? _autorController;
  TextEditingController? _editorialController;
  TextEditingController? _generoController;
  TextEditingController? _paginasController;
  TextEditingController? _edicionController;

  final _formKey = GlobalKey<FormState>();
  ScrollController? _scrollController;
  String? titulo = "";
  String? isbn = "";
  String? autor = "";
  String? editorial = "";
  String? genero = "";
  String? edicion = "";
  String? leido = "No";
  String? idioma = "";
  String paginas = "";
  int? estado = 1;
  int? tapa = 0;
  String year = DateTime.now().year.toString();
  int executeOnce = 0;
  late Book book;
  Book? bookUpdate;

  int newOrUpdate = 0;
  BookController bookController = Get.put(BookController());

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    Size size = getMediaSize(context);
    if ((argument is Book) && executeOnce == 0) {
      newOrUpdate = 1;
      book = argument;
      titulo = book.titulo;
      autor = book.autor;
      isbn = book.isbn;
      editorial = book.editorial;
      genero = book.genero;
      year = int.parse(book.fechaPublicacion!).toString();
      edicion = book.edicion;
      leido = book.leido;
      idioma = book.idioma;
      paginas = book.paginas.toString();
      estado = book.estado;
      tapa = book.tapa;
      executeOnce++;
    }
    _yearController = new TextEditingController(text: year.toString());
    _tituloController = new TextEditingController(text: titulo);
    _autorController = new TextEditingController(text: autor);
    _editorialController = new TextEditingController(text: editorial);
    _generoController = new TextEditingController(text: genero);
    _paginasController = new TextEditingController(text: paginas.toString());
    _edicionController = new TextEditingController(text: edicion);
    _isbnController = new TextEditingController(text: isbn);

    ts = TextStyle(
      color: black,
      fontSize: size.width * 0.04,
      fontFamily: Fonts.muliBold,
    );

    return Scaffold(
      backgroundColor: white,
      appBar: getAppBar(newOrUpdate == 0 ? "Añadir libro" : "Editar libro",
          true, size, context),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView(
          controller: _scrollController,
          children: [
            Container(
              width: size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    getTitleForm(size),
                    getAutorForm(size),
                    getPaginasForm(size),
                    getRadioLeido(size),
                    getRadioTapa(size),
                    getYearForm(size),
                    getEdicionForm(size),
                    getEditorialForm(size),
                    getIsbnForm(size),
                    getGeneroForm(size),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    getButton(size, context),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRadioLeido(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.01,
        ),
        Center(
          child: Container(
            width: size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setValueLeido("No");
                    },
                    child: Column(
                      children: <Widget>[
                        Radio(
                          value: "No",
                          groupValue: leido,
                          activeColor: black,
                          onChanged: (dynamic value) {
                            setValueLeido(value);
                          },
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Center(
                                    child: Icon(
                                  Icons.cancel,
                                  color: red,
                                )),
                                decoration: BoxDecoration(
                                  color: orangeLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "No leído",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: black,
                            fontFamily: Fonts.muliBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setValueLeido("Si");
                    },
                    child: Column(
                      children: <Widget>[
                        Radio(
                          value: "Si",
                          groupValue: leido,
                          activeColor: black,
                          onChanged: (dynamic value) {
                            setValueLeido(value);
                          },
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Center(
                                    child: Icon(
                                  Icons.check_circle,
                                  color: green,
                                )),
                                decoration: BoxDecoration(
                                  color: orangeLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Leído",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: black,
                            fontFamily: Fonts.muliBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getRadioTapa(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.01,
        ),
        Center(
          child: Container(
            width: size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setValueTapa(0);
                    },
                    child: Column(
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: tapa,
                          activeColor: black,
                          onChanged: (dynamic value) {
                            setValueTapa(value);
                          },
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Center(
                                    child: Icon(
                                  Icons.mood_bad,
                                  color: red,
                                )),
                                decoration: BoxDecoration(
                                  color: orangeLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Blanda",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: black,
                            fontFamily: Fonts.muliBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setValueTapa(1);
                    },
                    child: Column(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: tapa,
                          activeColor: black,
                          onChanged: (dynamic value) {
                            setValueTapa(value);
                          },
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Center(
                                    child: Icon(
                                  Icons.mood,
                                  color: green,
                                )),
                                decoration: BoxDecoration(
                                  color: orangeLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Dura",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: black,
                            fontFamily: Fonts.muliBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  setValueLeido(dynamic val) {
    setState(() {
      leido = val;
    });
  }

  setValueTapa(dynamic val) {
    setState(() {
      tapa = val;
    });
  }

  getTitleForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.1,
          left: size.width * 0.1),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _tituloController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.title,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Título  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) async {
          titulo = v;
        },
        validator: (v) {
          if (v!.isEmpty) {
            return "Rellena el campo de título";
          } else
            return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  getIsbnForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.1,
          left: size.width * 0.1),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _isbnController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.emoji_symbols,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "ISBN  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          isbn = v;
        },
        validator: (v) {
          if (v!.length > 0) {
            if (v.length < 9) return "Rellena el campo de isbn";
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  getYearForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.05,
          right: size.width * 0.3,
          left: size.width * 0.3),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _yearController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.date_range,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Año  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          year = v;
        },
        keyboardType: TextInputType.number,
      ),
    );
  }

  getAutorForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.1,
          left: size.width * 0.1),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _autorController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.edit,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Autor  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          autor = v;
        },
        validator: (v) {
          if (v!.isEmpty) {
            return "Rellena el campo de autor";
          } else
            return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  getEditorialForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.1,
          left: size.width * 0.1),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _editorialController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.book,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Editorial  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          editorial = v;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  getGeneroForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.1,
          left: size.width * 0.1),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _generoController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.texture,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Género  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          genero = v;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  getPaginasForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.32,
          left: size.width * 0.32),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _paginasController,
        maxLength: 5,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.find_in_page,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Páginas  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          paginas = v;
        },
        keyboardType: TextInputType.number,
      ),
    );
  }

  getEdicionForm(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.02,
          right: size.width * 0.3,
          left: size.width * 0.3),
      width: size.width,
      child: TextFormField(
        style: ts,
        cursorColor: primaryColor,
        controller: _edicionController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.explicit,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Edición  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: primaryColor, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          edicion = v;
        },
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget getButton(Size size, BuildContext context) {
    return Container(
      width: size.width * 0.5,
      margin: EdgeInsets.only(right: size.width * 0.1, left: size.width * 0.1),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: primaryColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () async {
            int pags = int.parse(paginas);
            int yearNumber = int.parse(year);
            if (newOrUpdate == 0) {
              //rellenar datos minimos * definir campos obligatorios
              if (this._formKey.currentState!.validate() && pags > 0) {
                book = new Book(
                    autor: autor!.trim(),
                    edicion: edicion ?? "",
                    editorial: editorial!.trim(),
                    estado: estado,
                    isbn: isbn ?? "",
                    fechaPublicacion: yearNumber.toString(),
                    genero: genero!.trim(),
                    idioma: idioma!.trim(),
                    leido: leido,
                    paginas: pags,
                    tapa: tapa,
                    titulo: titulo!.trim(),
                    nombrePrestamo: "",
                    opinion: "",
                    valoracion: 0);

                await DBProvider.db.insertBook(book).then((value) async {
                  if (value > 0) {
                    setState(() {
                      titulo = "";
                      autor = "";
                      editorial = "";
                      genero = "";
                      isbn = "";
                      year = DateTime.now().year.toString();
                      edicion = "";
                      leido = "";
                      idioma = "";
                      paginas = "0";
                      estado = 1;
                      tapa = 0;
                    });
                    Book? bookCreatedFromBD =
                        await DBProvider.db.getBookById(value);
                    bookController.addBook(bookCreatedFromBD);
                    Fluttertoast.showToast(
                      msg: "Libro añadido",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                });
              } else {
                Fluttertoast.showToast(
                  msg: "Los datos deben rellenarse correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            } else {
              if (this._formKey.currentState!.validate() && pags > 0) {
                bookUpdate = new Book(
                  id: book.id,
                  autor: autor!.trim(),
                  edicion: edicion,
                  editorial: editorial!.trim(),
                  estado: estado,
                  fechaPublicacion: yearNumber.toString(),
                  genero: genero!.trim(),
                  idioma: idioma!.trim(),
                  leido: leido,
                  paginas: pags,
                  tapa: tapa,
                  titulo: titulo!.trim(),
                  nombrePrestamo: book.nombrePrestamo,
                  opinion: book.opinion,
                  valoracion: book.valoracion,
                );

                await DBProvider.db.insertBook(book).then((value) {
                  if (value > 0) {
                    setState(() {
                      titulo = "";
                      autor = "";
                      editorial = "";
                      genero = "";
                      year = DateTime.now().year.toString();
                      edicion = "";
                      leido = "No";
                      idioma = "";
                      paginas = "0";
                      estado = 1;
                      tapa = 0;
                    });
                    Fluttertoast.showToast(
                      msg: "Libro añadido",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    Navigator.pop(context, true);
                  }
                });
              } else {
                Fluttertoast.showToast(
                  msg: "Los datos deben rellenarse correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            }
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              child: Text(
                newOrUpdate == 0 ? 'Añadir' : 'Actualizar',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontFamily: Fonts.muliBold,
                  color: white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
