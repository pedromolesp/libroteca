import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_controller.dart';
import 'package:libroteca/src/routes/routes.dart';
import 'package:libroteca/src/styles/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setScreensControls();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libroteca',
      theme: theme,
      initialRoute: 'loading',
      routes: getAplicationRoutes(),
    );
  }
}
