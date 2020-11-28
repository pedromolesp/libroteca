import 'package:flutter/material.dart';

Future<dynamic> navigateAndRefresh(BuildContext context, Widget page,
    {dynamic arguments}) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments)),
  );

  return result;
}
