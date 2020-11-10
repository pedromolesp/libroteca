import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = getMediaSize(context);
    return Scaffold(
      backgroundColor: orangeLight,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: orangeDark,
        centerTitle: true,
        title: Container(
          width: size.width,
          child: Text(
            "Preferencias",
            style: TextStyle(
                color: black,
                fontFamily: Fonts.muliBold,
                fontSize: size.width * 0.05),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          getExportDataBaseView(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          getImportDataBaseView(size)
        ],
      ),
    );
  }

  getExportDataBaseView(Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.07,
        child: Material(
          color: orangeDark,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () {
              exportDatabase();
            },
            child: Center(
              child: Text(
                "Exportar",
                style: TextStyle(color: white, fontFamily: Fonts.muliBold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getImportDataBaseView(Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.07,
        child: Material(
          color: orangeDark,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Text(
                "Importar",
                style: TextStyle(
                  color: white,
                  fontFamily: Fonts.muliBold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  exportDatabase() async {
    final PermissionHandler _permissionHandler = PermissionHandler();

    File file;
    DateTime date = DateTime.now();
    Uint8List bytes;

    String json = "";
    await _permissionHandler
        .requestPermissions([PermissionGroup.storage]).then((result) async {
      switch (result[PermissionGroup.storage]) {
        case PermissionStatus.granted:
          try {
            if (Platform.isAndroid) {
              await getApplicationSupportDirectory().then((e) async {
                print(e.path);

                final String path = ('${e.path}/$date-LIBROTECA.json')
                    .replaceAll(RegExp(r"\s\b|\b\s"), "-");
                final File file = File(path);
                await DBProvider.db.getAllBooks().then((books) async {
                  json = jsonEncode(books);
                  file.writeAsString(json);
                  // await OpenFile.open(path);
                  // print(json);
                });
              });
            }
          } catch (e) {
            print("Error al descargar el pdf $e");
          }

          break;
        case PermissionStatus.denied:
          break;

        case PermissionStatus.restricted:
          break;
      }
    });
    //   await getApplicationSupportDirectory().then((direction) {
    //     file = new File("${direction.path}/$date-LIBROTECA.json");
    //   });
    //   await DBProvider.db.getAllBooks().then((books) {
    //     json = jsonEncode(books);
    //     file.writeAsString(json);
    //     // print(json);
    //   });
  }

  importDatabase() async {
    // File file;
    // String json = "";
    // FilePickerResult result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   file = File(result.files.single.path);
    //   file.readAsString().then((value) => json = jsonDecode(value));
    //   print(json);
    // }
  }
}
