import 'dart:convert';

import 'package:libroteca/src/models/google_api_book.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  Future<GoogleApiBookSearch?> fetchGoogleApiBook(String name) async {
    Uri uri = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$name');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GoogleApiBookSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
