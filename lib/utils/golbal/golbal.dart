import 'dart:convert';
import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soe/flutter_flow/flutter_flow_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/congty.dart';
import '../../model/store.dart';
import 'versionapp.dart';
import 'package:socket_io_client/socket_io_client.dart' as sk;

class Golbal {
  static late sk.Socket socket;
  static String googleApiKey = "AIzaSyCeo0nk403kANvQDy3FBfm049s_yaxw9Ww";
  static bool isfirebase = true;
  static int connectivityResult = 1;
  static Size screenSize = const Size(0, 0);
  static double textScaleFactor = 1;
  static Color appColor = const Color(0xFF0186f8);
  static Color appColorD = const Color(0xFFffffff);
  static Color iconColor = Colors.black54;
  static Color titleColor = const Color(0xFF045997);
  static Color titleappColor = const Color(0xFF086FE8);
  static SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.light;
  static SystemUiOverlayStyle systemUiOverlayStyle1 = SystemUiOverlayStyle.dark;
  static Store store = Store("", {}, false, false, {}, {}, 0, 10, {});
  static CongTy? congty;
  static VersionApp? versionApp;
  static TextStyle stylelabel = const TextStyle(
      color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500);
  static TextStyle styleinput =
      const TextStyle(color: Colors.black, fontSize: 13);
  static BorderSide borderSide =
      const BorderSide(color: Color(0xFFcccccc), width: 1.0);
  static InputDecoration decoration = InputDecoration(
    border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
    labelText: '',
    hintStyle: const TextStyle(
      color: Color(0xFFcccccc),
    ),
    fillColor: const Color(0xFFcccccc),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFcccccc), width: 1.0),
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
  static Color renderColor(double td) {
    Color them = const Color(0xff6fbf73);
    if (td <= 30) {
      them = Colors.red;
    } else if (td <= 50) {
      them = Colors.orange;
    } else if (td <= 80) {
      them = appColor;
    }
    return them;
  }

  static String changeAlias(String str) {
    str = str.toLowerCase();
    str = str.replaceAll(RegExp(r"à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ"), "a");
    str = str.replaceAll(RegExp(r"è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ"), "e");
    str = str.replaceAll(RegExp(r"ì|í|ị|ỉ|ĩ"), "i");
    str = str.replaceAll(RegExp(r"ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ"), "o");
    str = str.replaceAll(RegExp(r"ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ"), "u");
    str = str.replaceAll(RegExp(r"ỳ|ý|ỵ|ỷ|ỹ"), "y");
    str = str.replaceAll(RegExp(r"đ"), "d");
    return str;
  }

  static Color trongColor(int td) {
    Color them = Colors.green;
    if (td <= 1) {
      them = Colors.red;
    } else if (td <= 2) {
      them = Colors.orange;
    } else if (td <= 3) {
      them = appColor;
    }
    return them;
  }

  static Color uutienColor(int td) {
    Color them = Colors.green;
    if (td == 2) {
      them = Colors.red;
    } else if (td == 1) {
      them = Colors.orange;
    } else if (td == 0) {
      them = appColor;
    }
    return them;
  }

  //Function
  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  static Future<String> encr(String pass) async {
    String _key = "1012198815021989";
    String _iv = "1012198815021989";
    final iv = enc.IV.fromUtf8(_iv);
    final key = enc.Key.fromUtf8(_key);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(pass, iv: iv);
    return encrypted.base64;
  }

  static Future<String> decr(String pass) async {
    String _key = "1012198815021989";
    String _iv = "1012198815021989";
    final iv = enc.IV.fromUtf8(_iv);
    final key = enc.Key.fromUtf8(_key);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decrypted = encrypter.decrypt64(pass, iv: iv);
    return decrypted;
  }

  static clearStore() {
    {
      final box = GetStorage();
      box.remove("smartoffice");
    }
  }

  static String getDayName(String ngaySN) {
    DateTime? sn;
    try {
      sn = DateTime.tryParse(ngaySN)!;
    } catch (e) {}
    if (sn == null) return "";
    DateTime date = DateTime(DateTime.now().year, sn.month, sn.day);
    var firstDayOfYear = date.weekday;
    if (firstDayOfYear == DateTime.monday) return "Thứ 2";
    if (firstDayOfYear == DateTime.tuesday) return "Thứ 3";
    if (firstDayOfYear == DateTime.wednesday) return "Thứ 4";
    if (firstDayOfYear == DateTime.thursday) return "Thứ 5";
    if (firstDayOfYear == DateTime.friday) return "Thứ 6";
    if (firstDayOfYear == DateTime.saturday) return "Thứ 7";
    return "Chủ nhật";
  }

  static bool checkNgay(String? sdate) {
    try {
      if (sdate == null) return false;
      DateTime? date;
      if (sdate.contains("/Date")) {
        date = DateTime.fromMillisecondsSinceEpoch(int.parse(
            sdate.toString().replaceAll("/Date(", "").replaceAll(")/", "")));
      } else {
        date = DateTime.tryParse(sdate);
      }
      return date?.month == DateTime.now().month &&
          date?.day == DateTime.now().day;
    } catch (e) {
      return false;
    }
  }

  static String timeAgo(sdate, {bool? ago}) {
    if (sdate == null) return "";
    try {
      DateTime date;
      if (sdate is DateTime) {
        date = sdate;
      } else if (sdate.contains("/Date")) {
        date = DateTime.fromMillisecondsSinceEpoch(int.parse(
            sdate.toString().replaceAll("/Date(", "").replaceAll(")/", "")));
      } else {
        date = DateTime.tryParse(sdate)!;
      }
      DateTime now = DateTime.now();
      if (now.year == date.year) {
        if (now.day == date.day && now.month == date.month) {
          if (ago == true) {
            int h = now.hour - date.hour;
            int p = now.minute - date.minute;
            if (h < 2 && h > 0) {
              return "${h.abs()} giờ trước";
            }
            if (p.abs() == 0) {
              return "Vừa xong";
            }
            return "${p.abs()} phút trước";
          }
          return DateTimeFormat.format(date, format: 'H:i');
        } else {
          return DateTimeFormat.format(date, format: 'H:i d/m')
              .replaceAll("00:00 ", "");
        }
      }
      return DateTimeFormat.format(date, format: 'H:i d/m/Y')
          .replaceAll("00:00 ", "");
    } catch (e) {
      print(e);
      return sdate;
    }
  }

  static Future initStore() async {
    try {
      final box = GetStorage();
      String? strstore = box.read("smartoffice");
      if (strstore != null) {
        store = Store.fromJson(json.decode(strstore));
      }

      String? strstoreApp = box.read("VersionApp");
      if (strstoreApp != null) {
        try {
          versionApp = VersionApp.fromJson(json.decode(strstoreApp));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }

      String? strCongTyApp = box.read("congtyApp");
      if (strCongTyApp != null) {
        try {
          congty = CongTy.fromJson(json.decode(strCongTyApp));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static sendSocketData(data) {
    if (socket.connected) {
      try {
        socket.emit("sendData", data);
      } catch (e) {}
    }
  }

  static Future saveStore() async {
    final box = GetStorage();
    box.write("smartoffice", json.encode(store.toJson()));
    if (versionApp != null) {
      box.write("VersionApp", json.encode(versionApp!.toJson()));
    }
    box.write("congtyApp", json.encode(congty!.toJson()));
  }

  static List<String> randomColors = [
    "#F8E69A",
    "#AFDFCF",
    "#F4B2A3",
    "#9A97EC",
    "#CAE2B0",
    "#8BCFFB",
    "#CCADD7"
  ];
  static String encodeForFirebaseKey(String s) {
    return s
        .replaceAll("_", "__")
        .replaceAll(".", "_P")
        .replaceAll("\$", "_D")
        .replaceAll("#", "_H")
        .replaceAll("[", "_O")
        .replaceAll("]", "_C")
        .replaceAll("/", "_S");
  }

  static Future<String> downloadFile(String url, String filename) async {
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return '$dir/$filename';
  }

  static loadFile(link) async {
    if (link != null) {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        String url =
            Golbal.congty!.fileurl + link.toString().replaceAll("\\", "/");
        if (defaultTargetPlatform == TargetPlatform.iOS &&
            link.toString().toLowerCase().contains(".pdf")) {
          !await launchUrl(Uri.parse(url),
              mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem tài liệu");
        } else {
          openFileMobile(url);
        }
      } else {
        String viewUrl = "${Golbal.congty!.fileurl}/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem tài liệu");
      }
    }
  }

  static String formatDate(sdate, fm, {bool? nam}) {
    if (sdate == null) return "";
    DateTime? date;
    if (sdate is DateTime) {
      date = sdate;
    } else if (sdate.contains("/Date")) {
      date = DateTime.fromMillisecondsSinceEpoch(int.parse(
          sdate.toString().replaceAll("/Date(", "").replaceAll(")/", "")));
    } else {
      date = DateTime.tryParse(sdate);
      if (date != null) {
        sdate = sdate.replaceAll("/", "-");
        date = DateTime.tryParse(sdate)!;
      }
    }
    if (date == null) return "";
    if (date.year == (DateTime.now().year) && nam != true) {
      if (fm == "H:i") return DateTimeFormat.format(date, format: 'H:i d/m');
      return DateTimeFormat.format(date, format: 'd/m');
    }
    return DateTimeFormat.format(date, format: fm ?? 'H:i d/m/Y');
  }

  static openFileMobile(url) async {
    String filename = url;
    Directory tempDir = await getTemporaryDirectory();
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    String filePath = "${tempDir.path}/$filename";
    EasyLoading.show(
      status: "Đang hiển thị file ...",
    );
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    try {
      await dio.download(url, filePath);
      await OpenAppFile.open(filePath);
    } catch (e) {}
    EasyLoading.dismiss();
  }

  static String dayAgo(sdate, {bool? thu}) {
    if (sdate == null) return "";
    DateTime? date;
    if (sdate is DateTime) {
      date = sdate;
    } else if (sdate.contains("/Date")) {
      date = DateTime.fromMillisecondsSinceEpoch(int.parse(
          sdate.toString().replaceAll("/Date(", "").replaceAll(")/", "")));
    } else {
      date = DateTime.tryParse(sdate);
    }
    if (date == null) return "";
    DateTime now = DateTime.now();
    if (now.year == date.year) {
      if (now.day == date.day && now.month == date.month) {
        return "Hôm nay";
      } else if (now.day - 1 == date.day && now.month == date.month) {
        return "Hôm qua";
      }
    }
    if (thu == true) {
      return "${getDayName(date.toIso8601String())} (${DateTimeFormat.format(date, format: 'd/m/Y')})";
    }
    return DateTimeFormat.format(date, format: 'd/m/Y');
  }

  static String formatBytes(bytes, {int? decimals}) {
    try {
      bytes = double.tryParse(bytes.toString());
      if (bytes <= 0) return "0 B";
      return filesize(
          bytes.toString().replaceAll(".0", "").replaceAll(".", ""));
    } catch (e) {
      return bytes;
    }
  }

  static String formatNumber(dynamic value) {
    if (value == null) return "";
    final formatCurrency = NumberFormat.currency(locale: "vi_VN", symbol: "");
    return formatCurrency.format(value);
  }
}
