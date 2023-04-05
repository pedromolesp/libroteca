import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';

ThemeData theme = new ThemeData(
    primaryColor: primaryColor,
    backgroundColor: primaryBackgroundColor,
    iconTheme: IconThemeData(
      color: black,
    ),
    inputDecorationTheme: InputDecorationTheme(
        focusColor: primaryColorDark,
        iconColor: primaryColor,
        suffixIconColor: black,
        prefixIconColor: black,
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColorDark,
            ),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: red,
            ),
            borderRadius: BorderRadius.circular(10))),
    tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: white,
        unselectedLabelStyle: TextStyle(color: white),
        labelStyle: TextStyle(color: primaryColor)));
