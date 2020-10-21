import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/widgets/logo_widget.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4)).then((e) {
        Navigator.pushReplacementNamed(context, 'base');
      });
    });
    return Container(
      width: size.width,
      height: size.height,
      color: orangeDark,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(
              size: size,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              "Libroteca",
              style: TextStyle(
                  color: whiteRed,
                  decoration: TextDecoration.none,
                  fontFamily: Fonts.muliBlack,
                  fontSize: size.width * 0.05),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
