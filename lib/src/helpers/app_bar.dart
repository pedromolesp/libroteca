import 'dart:io';
import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

getAppBar(String title, bool automaticallyImplyLeading, Size size,
    BuildContext context,
    {List<Widget>? actions}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
    backgroundColor: primaryColorDark,
    leading: IconButton(
        icon:
            Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context, true);
        }),
    title: Text(
      title,
      style: TextStyle(
          color: white,
          fontSize: size.width * 0.05,
          fontFamily: Fonts.muliBold),
    ),
  );
}
