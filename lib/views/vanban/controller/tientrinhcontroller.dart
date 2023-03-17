import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphview/GraphView.dart' as gh;

import '../../../utils/golbal/golbal.dart';

class TienTrinhVanbanController extends GetxController {
  RxBool isloadding = true.obs;
  RxBool isEmpty = false.obs;
  final gh.Graph graph = gh.Graph()..isTree = true;
  gh.BuchheimWalkerConfiguration builder = gh.BuchheimWalkerConfiguration();
  initData(vb) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"doc_master_id": vb["vanBanMasterID"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListFollow", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["sender"] != null) {
              element["sender"] = List.castFrom(json.decode(element["sender"]));
            }
            if (element["tailieus"] != null) {
              element["tailieus"] =
                  List.castFrom(json.decode(element["tailieus"]));
            }
          }
          initGraph(tbs);
        } else {
          isEmpty.value = true;
        }
        isloadding.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showNoidung(dynamic node) {
    ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          dialogAlignment: Alignment.centerLeft,
          customColumns: [
            if (node["Noidung"] != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: const [
                    Icon(Icons.edit, size: 16),
                    SizedBox(width: 5),
                    Text("Nội dung gửi",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0xFFEFF8FF),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("- ${node["Noidung"]}"),
                )),
            if (node["Noidungthuhoi"] != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: const [
                    Icon(Icons.refresh_rounded, size: 20, color: Colors.red),
                    SizedBox(width: 5),
                    Text("Nội dung thu hồi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            if (node["Noidungthuhoi"] != null)
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("- ${node["Noidungthuhoi"]}",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ));
  }

  void changeOrientation() {
    isloadding.value = true;
    if (builder.orientation < 4) {
      builder.orientation = builder.orientation + 1;
    } else {
      builder.orientation = 1;
    }
    isloadding.value = false;
  }

  void initGraph(List tbs) {
    // if (kDebugMode) {
    //   print(tbs);
    // }
    try {
      var nodes = [];
      for (var vb in tbs) {
        nodes.add(gh.Node.Id(vb));
      }
      for (int i = 1; i <= tbs.length - 1; i++) {
        var cnode = nodes[i];
        int j = i - 1;
        while (j > 0 &&
            cnode.key!.value["CapCha_ID"] != nodes[j].key!.value["IDKey"]) {
          j--;
        }
        if (i != j) {
          nodes[j].key!.value["Noidunggui"] = nodes[i].key!.value["Noidung"];
          graph.addEdge(nodes[j], nodes[i]);
        }
      }
      builder
        ..siblingSeparation = (30)
        ..levelSeparation = (20)
        ..subtreeSeparation = (30)
        ..orientation = (gh.BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData(Get.arguments);
  }
}
