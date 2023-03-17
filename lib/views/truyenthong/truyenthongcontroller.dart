
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TruyenthongController extends GetxController {
  ScrollController? tuancontroller;
  RxInt pageIndex = 1.obs;
  RxBool isLoadding = true.obs;
  var datas = [];
  void onPageChanged(int p) {
    datas.clear();
    if (p == 0) {
      Get.back();
      return;
    }
    pageIndex.value = p;
    loadData(false);
  }

  void loadData(f) {
    switch (pageIndex.value) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
