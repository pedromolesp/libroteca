import 'package:flutter/material.dart';
import 'package:libroteca/src/view/base_page.dart';
import 'package:libroteca/src/view/create/create_book.dart';
import 'package:libroteca/src/view/loading.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    'loading': (BuildContext context) => LoadingPage(),
    'base': (BuildContext context) => BasePage(),
    'create': (BuildContext context) => CreateBook()
  };
}
