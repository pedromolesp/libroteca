import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BookViewController extends GetxController {
  var tabSelected = 0.obs;
  change(int index) => tabSelected.value = index;
}
