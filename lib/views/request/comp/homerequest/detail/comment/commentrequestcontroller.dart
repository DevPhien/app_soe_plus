import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/request/comp/homerequest/detail/detailrequestcontroller.dart';

class CommentRequestController extends GetxController {
  final DetailRequestController controller = Get.put(DetailRequestController());
  //Declare
  var comments = [].obs;
  var quote = {}.obs;

  //Function
  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Map<DismissDirection, double> dismissThresholds() {
    Map<DismissDirection, double> map = <DismissDirection, double>{};
    map.putIfAbsent(DismissDirection.horizontal, () => 0.5);
    return map;
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
                    "RequestMaster_ID": request["RequestMaster_ID"],
                    "RequestComment_ID": request["RequestComment_ID"],
                    "user_id": Golbal.store.user["user_id"],
                    "event": "getDeleteCommentRequest",
                    "socketid": Golbal.socket.id,
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Request/Delete_Comment",
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

  //init
  @override
  void onInit() {
    super.onInit();
    initSocket();
    initData();
  }

  void initData() async {
    try {
      var body = {
        "RequestMaster_ID": controller.request["RequestMaster_ID"],
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Request/Get_Comment";
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

  void initSocket() {
    Golbal.socket
        .on('getSendCommentRequest', (data) => initSocketDataMessage(data));
    Golbal.socket
        .on('getDeleteCommentRequest', (data) => initSocketDataMessage(data));
  }

  void initSocketDataMessage(data) {
    if (controller.connected_datas.isNotEmpty) {
      for (var us in List.castFrom(controller.connected_datas)
          .where((a) =>
                  (a["user_id"] != data["user_id"] ||
                      (a["user_id"] == data["user_id"] &&
                          a["socketid"] == Golbal.socket.id &&
                          data["socketid"] != Golbal.socket.id)) &&
                  a["user_id"] == Golbal.store.user["user_id"]
              //&& a["userStatus"] == true
              )
          .toList()) {
        if (us["user_id"] != null) {
          switch (data["event"]) {
            case "getSendCommentRequest":
              //comments.insert(comments.length, data);
              initData();
              controller.scrollBottom();
              break;
            case "getDelMessage":
              initData();
              break;
          }
        }
      }
    }
  }
}
