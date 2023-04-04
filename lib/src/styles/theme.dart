import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';

ThemeData theme = new ThemeData(
    primaryColor: primaryColor,
    backgroundColor: primaryBackgroundColor,
    tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: white,
        unselectedLabelStyle: TextStyle(color: white),
        labelStyle: TextStyle(color: primaryColor)));
