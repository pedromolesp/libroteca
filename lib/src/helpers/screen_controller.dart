import 'package:flutter/services.dart';
import 'package:libroteca/src/styles/colors.dart';

void setScreensControls() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: transparent));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
