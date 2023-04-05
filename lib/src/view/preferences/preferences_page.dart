import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libroteca/src/data/db_provider.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/models/book.dart';
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
        backgroundColor: primaryColorDark,
        centerTitle: true,
        title: Container(
          width: size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Preferencias",
            style: TextStyle(
                color: white,
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
          color: primaryColor,
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
          color: primaryColor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () {
              importDatabase();
            },
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
    Permission _permission = Permission.storage;
    File file;
    DateTime date = DateTime.now();
    Uint8List bytes;
    String json = "";
    String pathAndroid = "/storage/emulated/0/Download";

    await _permission.request().then((result) async {
      switch (result) {
        case PermissionStatus.granted:
          {
            print("permisiongranted");
            try {
              if (Platform.isAndroid) {
                final String path = ('$pathAndroid/LIBROTECA-$date.json')
                    .replaceAll(RegExp(r"\s\b|\b\s"), "-");
                final File file = File(path);
                print(file.path);
                await DBProvider.db.getAllBooks().then((books) async {
                  print("dentro");

                  if (books.length > 0) {
                    json = jsonEncode(books);
                    file.writeAsString(json);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Aún no hay datos",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                });
              } else {
                await getDownloadsDirectory().then((value) async {
                  final String path = ('${value!.path}/LIBROTECA-$date.json')
                      .replaceAll(RegExp(r"\s\b|\b\s"), "-");
                  final File file = File(path);
                  await DBProvider.db.getAllBooks().then((books) async {
                    if (books.length > 0) {
                      json = jsonEncode(books);
                      file.writeAsString(json);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Aún no hay datos",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  });
                });
              }
            } catch (e) {
              print("Error al descargar el pdf $e");
            }
          }

          break;
        case PermissionStatus.denied:
          print("permision denied exportando");
          break;
        case PermissionStatus.restricted:
          print("permision restricted exportando");
          break;
        case PermissionStatus.limited:
          print("permision limitado exportando");
          break;
        case PermissionStatus.permanentlyDenied:
          print("permision permantly denied exportando");
          break;
      }
    });
  }

  importDatabase() async {
    //TODO: comprobar si el isbn es único
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    List<BookToExport> books;
    if (result != null) {
      File file = File(result.files.single.path!);
      dynamic database = await file.readAsString();
      final jsonDecoded = json.decode(database);
      books = BookToExports.fromJsonList(jsonDecoded).items;
      await DBProvider.db.insertBooksImport(books);
    }
  }
}
