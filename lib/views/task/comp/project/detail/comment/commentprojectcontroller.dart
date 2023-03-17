import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/project/detail/detailprojectcontroller.dart';

class CommentProjectController extends GetxController {
  final DetailProjectController controller = Get.put(DetailProjectController());
  //Declare
  var comments = [].obs;
  var quote = {}.obs;

  //Function
  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void popGroupAction(context, request) {
    List<Widget> list = [];
    list.add(
      ListTile(
        leading: const Icon(
          Entypo.quote,
          color: Colors.purple,
        ),
        onTap: () {
          Navigator.of(context).pop();
          showQuote(context, request);
        },
        title: const Text("Trích dẫn"),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
    if (request["IsMe"]) {
      list.add(
        ListTile(
          leading: const Icon(
            FontAwesome.trash_o,
            color: Colors.red,
          ),
          onTap: () {
            Navigator.of(context).pop();
            delete(context, request);
          },
          title: const Text("Xóa"),
        ),
      );
    }
    if (list.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 150,
              child: SingleChildScrollView(
                child: ListBody(
                  children: list,
                ),
              ),
            );
          });
    }
  }

  void showQuote(context, request) async {
    quote.value = request;
  }

  void clearQuote() {
    quote.value = {};
  }

  void delete(context, request) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn xóa bình luận này không?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                int idx = comments.indexOf(request);
                if (idx != -1) {
                  comments.removeAt(idx);
                }
                Navigator.of(context).pop();
                try {
                  EasyLoading.show(status: "loading...");
                  var body = {
                    "DuanID": request["DuanID"],
                    "CommentID": request["CommentID"],
                    "user_id": Golbal.store.user["user_id"],
                    "event": "getDeleteCommentProject",
                    "socketid": Golbal.socket.id,
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Task/Delete_CommentProject",
                      data: body);
                  var data = response.data;
                  if (data["err"] == "1") {
                    EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
                    comments.insert(idx, request);
                    return;
                  }
                  EasyLoading.showSuccess("Xóa thành công");
                  //Realtime
                  Golbal.socket.emit('sendData', body);
                  //End Realtime
                } catch (e) {
                  EasyLoading.dismiss();
                  comments.insert(idx, request);
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    try {
      var body = {
        "DuanID": controller.project["DuanID"],
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Task/Get_CommentProject";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        comments.value = tbs[0];
        for (var cm in comments) {
          if (cm["files"] != null && cm["files"] != "") {
            cm["files"] = List.castFrom(json.decode(cm["files"]));
          }
        }
      } else {
        comments.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
