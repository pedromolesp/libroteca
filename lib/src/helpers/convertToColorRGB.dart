import 'package:flutter/material.dart';

convertRGBOStringToColor(List<String> list) {
  return Color.fromRGBO(int.parse(list[0]), int.parse(list[1]),
      int.parse(list[2]), double.parse(list[0]));
}
