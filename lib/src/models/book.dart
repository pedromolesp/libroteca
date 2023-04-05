class Book {
  int? id;
  String? isbn;
  String? titulo;
  String? autor;
  String? editorial;
  String? genero;
  String? fechaPublicacion;
  int? paginas;
  String? edicion;
  String? leido;
  int? estado;
  String? nombrePrestamo;
  int? tapa;
  String? idioma;
  int? valoracion;
  String? opinion;

  Book({
    this.id,
    this.titulo,
    this.autor,
    this.editorial,
    this.paginas,
    this.edicion,
    this.isbn,
    this.leido,
    this.fechaPublicacion,
    this.genero,
    this.estado,
    this.nombrePrestamo,
    this.tapa,
    this.idioma,
    this.opinion,
    this.valoracion,
  });

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    autor = json['autor'];
    editorial = json['editorial'];
    paginas = json['paginas'];
    edicion = json['edicion'];
    leido = json['leido'];
    genero = json['genero'];
    fechaPublicacion = json['fecha_publicacion'];
    estado = json['estado'];
    nombrePrestamo = json['nombre_prestamo'];
    tapa = json['tapa'];
    isbn = json['isbn'];
    idioma = json['idioma'];
    valoracion = json['valoracion'];
    opinion = json['opinion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['isbn'] = this.isbn;
    data['autor'] = this.autor;
    data['editorial'] = this.editorial;
    data['paginas'] = this.paginas;
    data['edicion'] = this.edicion;
    data['leido'] = this.leido;
    data['genero'] = this.genero;
    data['fecha_publicacion'] = this.fechaPublicacion;
    data['estado'] = this.estado;
    data['nombre_prestamo'] = this.nombrePrestamo;
    data['tapa'] = this.tapa;
    data['idioma'] = this.idioma;
    data['valoracion'] = this.valoracion;
    data['opinion'] = this.opinion;
    return data;
  }
}

class Books {
  List<Book> items = [];

  Books();

  Books.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final campain = Book.fromJson(item);
      items.add(campain);
    }
  }
}

class BookToExport {
  String? isbn;

  String? titulo;
  String? autor;
  String? editorial;
  String? genero;
  String? fechaPublicacion;
  int? paginas;
  String? edicion;
  String? leido;
  int? estado;
  String? nombrePrestamo;
  int? tapa;
  String? idioma;
  int? valoracion;
  String? opinion;

  BookToExport({
    this.titulo,
    this.autor,
    this.editorial,
    this.paginas,
    this.isbn,
    this.edicion,
    this.leido,
    this.fechaPublicacion,
    this.genero,
    this.estado,
    this.nombrePrestamo,
    this.tapa,
    this.idioma,
    this.opinion,
    this.valoracion,
  });

  BookToExport.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    autor = json['autor'];
    editorial = json['editorial'];
    paginas = json['paginas'];
    edicion = json['edicion'];
    isbn = json['isbn'];
    leido = json['leido'];
    genero = json['genero'];
    fechaPublicacion = json['fecha_publicacion'];
    estado = json['estado'];
    nombrePrestamo = json['nombre_prestamo'];
    tapa = json['tapa'];
    idioma = json['idioma'];
    valoracion = json['valoracion'];
    opinion = json['opinion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['isbn'] = this.isbn;
    data['autor'] = this.autor;
    data['editorial'] = this.editorial;
    data['paginas'] = this.paginas;
    data['edicion'] = this.edicion;
    data['leido'] = this.leido;
    data['genero'] = this.genero;
    data['fecha_publicacion'] = this.fechaPublicacion;
    data['estado'] = this.estado;
    data['nombre_prestamo'] = this.nombrePrestamo;
    data['tapa'] = this.tapa;
    data['idioma'] = this.idioma;
    data['valoracion'] = this.valoracion;
    data['opinion'] = this.opinion;
    return data;
  }
}

class BookToExports {
  List<BookToExport> items = [];

  BookToExports();

  BookToExports.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final book = BookToExport.fromJson(item);
      items.add(book);
    }
  }
}
