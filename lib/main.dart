import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:libroteca/src/helpers/screen_controller.dart';
import 'package:libroteca/src/routes/routes.dart';
import 'package:libroteca/src/styles/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setScreensControls();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libroteca',
      theme: theme,
      initialRoute: 'loading',
      routes: getAplicationRoutes(),
    );
  }
}
