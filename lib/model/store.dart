// ignore: file_names
import 'dart:convert';

class Store {
  String tokencmd;
  String? tokenvideo;
  String? avarta;
  dynamic user = {};
  bool intro = false;
  bool online = true;
  bool login = false;
  dynamic device = {};
  dynamic token = {};
  int noti = 0;
  int quality = 10;
  dynamic settingRequest = {};
  Store(this.tokencmd, this.user, this.intro, this.login, this.device,
      this.token, this.noti, this.quality, this.settingRequest);
  Store.fromJson(Map<String, dynamic> js)
      : user = json.decode(js['user']),
        tokencmd = js['tokencmd'],
        tokenvideo = js['tokenvideo'],
        avarta = js['avarta'],
        intro = js['intro'],
        online = js['online'],
        login = js['login'],
        device = json.decode(js['device']),
        token = json.decode(js['token']),
        noti = js['noti'],
        quality = js["quality"],
        settingRequest = js["settingRequest"];

  Map<String, dynamic> toJson() => {
        'tokencmd': tokencmd,
        'tokenvideo': tokenvideo,
        'avarta': avarta,
        'user': json.encode(user),
        'login': login,
        'intro': intro,
        'online': online,
        'device': json.encode(device),
        'token': json.encode(token),
        'noti': noti,
        'quality': quality,
        'settingRequest': settingRequest
      };
}
