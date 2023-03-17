import 'package:get/get.dart';

class HRMController extends GetxController {
  RxInt pageIndex = 0.obs;
  void onPageChanged(int p) {
    pageIndex.value = p;
  }
}
