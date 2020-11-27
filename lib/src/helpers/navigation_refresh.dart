import 'package:flutter/material.dart';

Future<dynamic> navigateAndRefresh(BuildContext context, Widget page) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );

  return result;
}
