import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:libroteca/src/models/book.dart';

class BookController extends GetxController {
  var bookList = <Book>[].obs;
  var bookListRead = <Book>[].obs;
  // var count = 0.obs;
  addBook(Book item) => bookList.add(item);
  removeBook(index) => bookList.removeAt(index);

  // fillBookListFromDB() => bookList=DBProvider.db.getReadBooks();

  addRead(item) => bookListRead.add(item);
  removeRead(index) => bookListRead.removeAt(index);
}

class BookViewController extends GetxController {
  var tabSelected = 0.obs;
  change(int index) => tabSelected.value = index;
}
