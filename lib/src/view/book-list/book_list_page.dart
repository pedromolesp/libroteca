import 'package:flutter/material.dart';
import 'package:libroteca/src/styles/colors.dart';

class BookListPage extends StatelessWidget {
  TextEditingController _searchController;
  String search = "";
  @override
  Widget build(BuildContext context) {
    _searchController = new TextEditingController(text: search);

    return Scaffold(
      backgroundColor: orangeLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: whiteRed,
        ),
        backgroundColor: orangeDark,
        onPressed: () {
          _addBook();
        },
      ),
      body: Container(
          //     child:FutureBuilder(
          // future:
          //     promotionsProvider.getTecnologicalRaffleHistory(year.toString()),
          // builder: (BuildContext context,
          //     AsyncSnapshot<List<TechRouletteHistory>> snapshot) {
          //   if (snapshot.connectionState != ConnectionState.done ||
          //       snapshot.hasData == null) {
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   } else {
          //     return getFutureWidget(size, snapshot.data);
          //   }
          // })
          ),
    );
  }

  _addBook() {}
}
