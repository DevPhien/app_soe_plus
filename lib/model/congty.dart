class CongTy {
  int? id;
  String congtyID;
  String tenCongty = "";
  String api = "";
  String socket = "https://socket.soe.vn:443"; //"http://123.31.12.70:8080";
  String fileurl = "";
  String diaChi = "";
  String? logo;
  CongTy.fromJson(Map<String, dynamic> js)
      : congtyID = js['Congty_ID'],
        id = js['id'],
        tenCongty = js['tenCongty'],
        api = js['api_link'] ?? "https://api.soe.vn",
        socket = js['socket_link'] ?? "https://socket.soe.vn:443",
        diaChi = js['diaChi'] ?? "",
        fileurl = js['file_link'] ?? "https://sfile.soe.vn",
        logo = js['logo'];
  Map<String, dynamic> toJson() => {
        'Congty_ID': congtyID,
        'id': id,
        'tenCongty': tenCongty,
        'api_link': api,
        'diaChi': diaChi,
        'file_link': fileurl,
        'socket_link': socket,
        'logo': logo,
      };
}
