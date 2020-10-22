import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/app_bar.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';

class CreateBook extends StatelessWidget {
  TextStyle ts;
  TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();

  String title = "";

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    ts = TextStyle(
      color: black,
      fontSize: size.width * 0.035,
      fontFamily: Fonts.muliBold,
    );
    return Scaffold(
      backgroundColor: orangeLight,
      appBar: getAppBar("Añadir libro", true, size),
      body: Container(
        width: size.width,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              getTitleForm(size),
            ],
          ),
        ),
      ),
    );
  }

  getTitleForm(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.05),
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: TextFormField(
        style: ts,
        cursorColor: orangeDark,
        controller: _titleController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: orangeDark, width: size.width * 0.005),
          ),
          suffixIcon: Icon(
            Icons.title,
            color: fillerGrey,
          ),
          hintStyle: ts,
          labelText: "Título  ",
          labelStyle: ts,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: orangeDark, width: size.width * 0.005),
          ),
        ),
        onChanged: (v) {
          title = v;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }
}
