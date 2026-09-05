import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomora/features/catalog/domain/model/google_book.dart';

/// Se lanza cuando la API de Google Books no devuelve un `200 OK` (cuota
/// agotada `429`, error de red, timeout, JSON ilegible...). La capa de
/// presentación la distingue de "0 resultados" para mostrar un aviso con
/// reintento en vez de un falso "sin resultados".
class GoogleBooksException implements Exception {
  const GoogleBooksException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// La cuota diaria anónima de Google Books (compartida por todo el mundo que
  /// llama sin `key`) está agotada. Se resuelve usando una API key propia.
  bool get isQuotaExceeded => statusCode == 429;

  @override
  String toString() => 'GoogleBooksException($statusCode): $message';
}

/// Cliente de la API de Google Books (`volumes`).
///
/// **Requiere API key.** Sin `key`, las peticiones caen en el proyecto anónimo
/// compartido de Google (`project_number:624717413613`), cuya cuota diaria se
/// agota constantemente y responde `429` a todo el mundo — que es la causa de
/// que la búsqueda "deje de funcionar" sin motivo aparente. La key se inyecta
/// en compilación:
///
/// ```sh
/// flutter run --dart-define=GOOGLE_BOOKS_API_KEY=AIza...
/// ```
///
/// Consíguela en <https://console.cloud.google.com/apis/credentials> con la
/// "Books API" habilitada (1000 consultas/día gratis).
class GoogleBooksApi {
  GoogleBooksApi({http.Client? client, String? apiKey})
      : _client = client ?? http.Client(),
        _apiKey = apiKey ?? _apiKeyFromEnv;

  final http.Client _client;
  final String _apiKey;

  static const _apiKeyFromEnv = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  static const _base = 'https://www.googleapis.com/books/v1/volumes';
  static const _timeout = Duration(seconds: 10);

  /// País del usuario. Google Books lo exige en varias regiones para servir
  /// resultados; sin él la respuesta puede venir vacía.
  static const _country = 'ES';

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Devuelve los resultados (posiblemente vacíos si no hay coincidencias).
  /// Lanza [GoogleBooksException] si la petición falla.
  Future<GoogleBooksResult> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const GoogleBooksResult();

    final uri = Uri.parse(_base).replace(queryParameters: {
      'q': trimmed,
      'country': _country,
      'maxResults': '20',
      if (hasApiKey) 'key': _apiKey,
    });

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (error) {
      throw GoogleBooksException(
          'No se pudo conectar con Google Books: $error');
    }

    if (response.statusCode != 200) {
      throw GoogleBooksException(
        _messageFor(response),
        statusCode: response.statusCode,
      );
    }

    try {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return GoogleBooksResult.fromJson(body);
    } catch (error) {
      throw GoogleBooksException('Respuesta ilegible de Google Books: $error');
    }
  }

  String _messageFor(http.Response response) {
    if (response.statusCode == 429) {
      return 'Google Books ha rechazado la petición por cuota agotada (429). '
          'Configura GOOGLE_BOOKS_API_KEY para usar tu propia cuota.';
    }
    try {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final error = body['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
    } catch (_) {
      // cae al mensaje genérico
    }
    return 'Google Books respondió ${response.statusCode}.';
  }
}
