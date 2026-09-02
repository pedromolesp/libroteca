/// Resultado de una búsqueda en la API de Google Books, aplanado a lo que la
/// app necesita (el JSON original es enorme; el modelo antiguo mapeaba ~490
/// líneas de campos que la UI nunca usaba).
class GoogleBooksResult {
  const GoogleBooksResult({this.items = const []});

  final List<GoogleBook> items;

  factory GoogleBooksResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return GoogleBooksResult(
      items: rawItems
          .map((e) => GoogleBook.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GoogleBook {
  const GoogleBook({
    required this.id,
    required this.title,
    this.authors = const [],
    this.categories = const [],
    this.ratingsCount = 0,
    this.averageRating = 0,
    this.thumbnail,
    this.description,
    this.publishedDate,
    this.pageCount,
    this.publisher,
    this.isbn13,
    this.language,
  });

  final String id;
  final String title;
  final List<String> authors;
  final List<String> categories;
  final int ratingsCount;
  final double averageRating;
  final String? thumbnail;
  final String? description;
  final String? publishedDate;
  final int? pageCount;
  final String? publisher;
  final String? isbn13;
  final String? language;

  String get authorsLabel => authors.join(', ');

  factory GoogleBook.fromJson(Map<String, dynamic> json) {
    final volume = json['volumeInfo'] as Map<String, dynamic>? ?? const {};
    final images = volume['imageLinks'] as Map<String, dynamic>?;
    final identifiers =
        (volume['industryIdentifiers'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();
    final isbn13 = identifiers.firstWhere(
      (i) => i['type'] == 'ISBN_13',
      orElse: () => const {},
    )['identifier'] as String?;

    return GoogleBook(
      id: json['id'] as String? ?? '',
      title: volume['title'] as String? ?? 'Sin título',
      authors: (volume['authors'] as List<dynamic>? ?? const []).cast<String>(),
      categories:
          (volume['categories'] as List<dynamic>? ?? const []).cast<String>(),
      ratingsCount: (volume['ratingsCount'] as num?)?.toInt() ?? 0,
      averageRating: (volume['averageRating'] as num?)?.toDouble() ?? 0,
      thumbnail: (images?['thumbnail'] ?? images?['smallThumbnail']) as String?,
      description: volume['description'] as String?,
      publishedDate: volume['publishedDate'] as String?,
      pageCount: (volume['pageCount'] as num?)?.toInt(),
      publisher: volume['publisher'] as String?,
      isbn13: isbn13,
      language: volume['language'] as String?,
    );
  }
}
