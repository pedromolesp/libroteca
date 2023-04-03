import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:libroteca/src/data/controllers/providers/detail_page_model.dart';
import 'package:libroteca/src/helpers/screen_controller.dart';
import 'package:libroteca/src/routes/routes.dart';
import 'package:libroteca/src/styles/theme.dart';
import 'package:provider/provider.dart' as prov;
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setScreensControls();
    return Provider(
        create: (BuildContext context) {},
        child: prov.MultiProvider(
            providers: [
              prov.ChangeNotifierProvider<DetailPageModel>(
                create: (_) => new DetailPageModel(),
              ),
              prov.ChangeNotifierProvider<DetailPageAlertModel>(
                create: (_) => new DetailPageAlertModel(),
              ),
            ],
            builder: (context, _) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Libroteca',
                theme: theme,
                initialRoute: 'loading',
                routes: getAplicationRoutes(),
              );
            }));
  }
}
