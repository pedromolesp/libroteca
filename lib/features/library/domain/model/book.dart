/// Un libro de la biblioteca del usuario.
///
/// Inmutable: usa [copyWith] para derivar cambios. Las claves de [toMap] /
/// [fromMap] coinciden con el esquema de la tabla `book` en sqflite
/// (`fecha_publicacion`, `nombre_prestamo`, ...), por compatibilidad con bases
/// de datos existentes.
class Book {
  const Book({
    this.id,
    this.isbn,
    this.titulo,
    this.autor,
    this.editorial,
    this.genero,
    this.fechaPublicacion,
    this.paginas,
    this.edicion,
    this.leido,
    this.estado,
    this.nombrePrestamo,
    this.tapa,
    this.idioma,
    this.valoracion,
    this.opinion,
  });

  final int? id;
  final String? isbn;
  final String? titulo;
  final String? autor;
  final String? editorial;
  final String? genero;
  final String? fechaPublicacion;
  final int? paginas;
  final String? edicion;
  final String? leido;
  final int? estado;
  final String? nombrePrestamo;
  final int? tapa;
  final String? idioma;
  final int? valoracion;
  final String? opinion;

  bool get isRead => leido == 'Si';
  bool get isRated => (valoracion ?? 0) > 0;

  Book copyWith({
    int? id,
    String? isbn,
    String? titulo,
    String? autor,
    String? editorial,
    String? genero,
    String? fechaPublicacion,
    int? paginas,
    String? edicion,
    String? leido,
    int? estado,
    String? nombrePrestamo,
    int? tapa,
    String? idioma,
    int? valoracion,
    String? opinion,
  }) {
    return Book(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      editorial: editorial ?? this.editorial,
      genero: genero ?? this.genero,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      paginas: paginas ?? this.paginas,
      edicion: edicion ?? this.edicion,
      leido: leido ?? this.leido,
      estado: estado ?? this.estado,
      nombrePrestamo: nombrePrestamo ?? this.nombrePrestamo,
      tapa: tapa ?? this.tapa,
      idioma: idioma ?? this.idioma,
      valoracion: valoracion ?? this.valoracion,
      opinion: opinion ?? this.opinion,
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: (map['id'] as num?)?.toInt(),
      isbn: map['isbn'] as String?,
      titulo: map['titulo'] as String?,
      autor: map['autor'] as String?,
      editorial: map['editorial'] as String?,
      genero: map['genero'] as String?,
      fechaPublicacion: map['fecha_publicacion'] as String?,
      paginas: (map['paginas'] as num?)?.toInt(),
      edicion: map['edicion'] as String?,
      leido: map['leido'] as String?,
      estado: (map['estado'] as num?)?.toInt(),
      nombrePrestamo: map['nombre_prestamo'] as String?,
      tapa: (map['tapa'] as num?)?.toInt(),
      idioma: map['idioma'] as String?,
      valoracion: (map['valoracion'] as num?)?.toInt(),
      opinion: map['opinion'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isbn': isbn,
      'titulo': titulo,
      'autor': autor,
      'editorial': editorial,
      'genero': genero,
      'fecha_publicacion': fechaPublicacion,
      'paginas': paginas,
      'edicion': edicion,
      'leido': leido,
      'estado': estado,
      'nombre_prestamo': nombrePrestamo,
      'tapa': tapa,
      'idioma': idioma,
      'valoracion': valoracion,
      'opinion': opinion,
    };
  }

  /// Mapa sin `id` — para exportar / importar entre dispositivos.
  Map<String, dynamic> toExportMap() => toMap()..remove('id');
}

/// Lista de libros deserializada desde un JSON exportado.
class BookList {
  BookList();

  BookList.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (final item in jsonList) {
      items.add(Book.fromMap(Map<String, dynamic>.from(item as Map)));
    }
  }

  final List<Book> items = [];
}
