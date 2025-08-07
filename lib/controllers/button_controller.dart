import 'package:get/get.dart';

class ButtonController extends GetxController {
  var selectedIndex = (0).obs;

  void selectButton(int index) {
    selectedIndex.value = index;
  }
}
//manages the state for the selected category button