import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = getMediaSize(context);
    return Scaffold(
      backgroundColor: orangeLight,
      body: Column(
        children: [],
      ),
    );
  }

  getExportDataBaseView(Size size) {
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.07,
      child: Material(
        color: orangeDark,
        child: InkWell(
          onTap: () {
            // getApplicationSupportDirectory();
          },
          child: Text(
            "Exportar",
            style: TextStyle(color: white, fontFamily: Fonts.muliBold),
          ),
        ),
      ),
    );
  }
}
