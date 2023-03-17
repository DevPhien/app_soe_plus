class VersionApp {
  bool check = true;
  String android = "";
  String ios = "";
  String androidLink = "";
  String iosLink = "";
  String name = "";
  String logo = "";
  String api;
  VersionApp.fromJson(Map<String, dynamic> js)
      : check = js['check'],
        android = js['android'],
        androidLink = js['androidLink'],
        iosLink = js['iosLink'],
        ios = js['ios'],
        name = js['name'],
        logo = js['logo'],
        api = js['api'];
  Map<String, dynamic> toJson() => {
        'check': check,
        'android': android,
        'androidLink': androidLink,
        'iosLink': iosLink,
        'ios': ios,
        'name': name,
        'logo': logo,
        'api': api,
      };
}
