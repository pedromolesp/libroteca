import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

getAppBar(String title, bool automaticallyImplyLeading, Size size) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: Text(
      title,
      style: TextStyle(
          color: black,
          fontSize: size.width * 0.05,
          fontFamily: Fonts.muliBold),
    ),
  );
}
