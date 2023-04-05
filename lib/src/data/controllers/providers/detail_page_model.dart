import 'package:flutter/material.dart';
import 'package:libroteca/src/models/book.dart';

class DetailPageModel extends ChangeNotifier {
  Book? _book;

  Book? get book => this._book;

  set book(Book? valor) {
    this._book = valor;
    notifyListeners();
  }

  initBookModelParams(Book book) {}
}

class DetailPageAlertModel extends ChangeNotifier {
  int _rating = 0;
  int get rating => this._rating;
  set rating(int valor) {
    this._rating = valor;
    notifyListeners();
  }
}
