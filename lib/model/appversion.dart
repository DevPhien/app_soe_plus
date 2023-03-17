class AppVersion {
  int android;
  int ios;
  String androidname;
  String iosname;
  AppVersion.fromJson(Map<String, dynamic> js)
      : android = int.parse(js['android']),
        ios = int.parse(js['ios']),
        androidname = js['androidname'],
        iosname = js['iosname'];
}
