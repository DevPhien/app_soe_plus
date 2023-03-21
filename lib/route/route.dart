import 'package:get/get.dart';
import 'package:soe/views/lichhop/lichop.dart';
import 'package:soe/views/truyenthong/tintuc/chitiettintuc.dart';
import 'package:soe/views/vanban/comp/xulyvanban/chuyendichdanh.dart';

import '../SplashScreen.dart';
import '../views/chat/chat.dart';
import '../views/chat/comp/message/infochat/archives.dart';
import '../views/chat/comp/message/infochat/infochat.dart';
import '../views/chat/comp/message/infochat/infouser.dart';
import '../views/chat/comp/message/message.dart';
import '../views/chat/comp/message/sharemessage/sharemessage.dart';
import '../views/chat/comp/sendmessage/sendmessage.dart';
import '../views/component/webview/webapp.dart';
import '../views/dieuxe/dieuxe.dart';
import '../views/dieuxe/lenh/capnhattrangthaixe.dart';
import '../views/dieuxe/lenh/chitietlenhxe.dart';
import '../views/dieuxe/lenh/chonlaixe.dart';
import '../views/dieuxe/lenh/chonxe.dart';
import '../views/dieuxe/lenh/duyetlenh.dart';
import '../views/dieuxe/lenh/hoanthanhlenh.dart';
import '../views/dieuxe/lenh/laplenh.dart';
import '../views/dieuxe/lenh/tralailenh.dart';
import '../views/dieuxe/phieu/chitietphieuxe.dart';
import '../views/dieuxe/phieu/duyetphieu.dart';
import '../views/dieuxe/phieu/tralaiphieu.dart';
import '../views/dieuxe/xe/chitietxe.dart';
import '../views/dieuxe/xe/lichsuxe.dart';
import '../views/dieuxe/xe/thongtinxe.dart';
import '../views/home/home.dart';
import '../views/hrm/calamviec/calam/calam.dart';
import '../views/hrm/calamviec/diadiem/diadiem.dart';
import '../views/hrm/calamviec/hrmpage.dart';
import '../views/hrm/myprofile/myprofile.dart';
import '../views/hrm/phieuluong/phieuluong.dart';
import '../views/hrm/qrcode/chamcong.dart';
import '../views/hrm/qrcode/checkin.dart';
import '../views/lichhop/chitietlichhop.dart';
import '../views/lichhop/comp/adlich.dart';
import '../views/lichhop/comp/lichfilter.dart';
import '../views/lichhop/lichngay.dart';
import '../views/login/login.dart';
import '../views/metting/metting.dart';
import '../views/metting/mettingdesktop.dart';
import '../views/notify/notify.dart';
import '../views/request/comp/homerequest/add/addrequest.dart';
import '../views/request/comp/homerequest/detail/activity/activity.dart';
import '../views/request/comp/homerequest/detail/detailrequest.dart';
import '../views/request/comp/homerequest/filter/filterrequest.dart';
import '../views/request/comp/teamrequest/requestmember.dart';
import '../views/request/comp/teamrequest/teamrequest.dart';
import '../views/request/request.dart';
import '../views/task/comp/hometask/add/addtask.dart';
import '../views/task/comp/hometask/detail/activity/activity.dart';
import '../views/task/comp/hometask/detail/detailtask.dart';
import '../views/task/comp/hometask/detail/giahan/giahan.dart';
import '../views/task/comp/hometask/detail/report/report.dart';
import '../views/task/comp/hometask/detail/subtask/subtask.dart';
import '../views/task/comp/hometask/filter/filtertask.dart';
import '../views/task/comp/project/add/addproject.dart';
import '../views/task/comp/project/detail/detailproject.dart';
import '../views/task/comp/project/detail/taskproject/taskproject.dart';
import '../views/task/comp/project/filter/filterproject.dart';
import '../views/task/task.dart';
import '../views/truyenthong/thongbao/chitietthongbao.dart';
import '../views/truyenthong/truyenthong.dart';
import '../views/user/comp/event.dart';
import '../views/user/user.dart';
import '../views/vanban/chitietvanban.dart';
import '../views/vanban/comp/duyetchuyentiep/duyetchuyentiep.dart';
import '../views/vanban/comp/duyetphathanh/duyetphathanh.dart';
import '../views/vanban/comp/filter/filtervanban.dart';
import '../views/vanban/comp/phanphatvanban/phanphatvanban.dart';
import '../views/vanban/comp/thuhoi/thuhoi.dart';
import '../views/vanban/comp/tientrinhxyly.dart';
import '../views/vanban/comp/tralai/tralai.dart';
import '../views/vanban/comp/xacnhanhoanthanh/xacnhanhoanthanh.dart';
import '../views/vanban/vanban.dart';

class RouterGet {
  static var route = [
    GetPage(name: '/home', page: () => const Home()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/splashscreen', page: () => const SplashScreen()),
    GetPage(name: '/webapp', page: () => const WebViewApp()),
    GetPage(name: '/event', page: () => Event()),
    GetPage(name: '/noty', page: () => Noty()),
    GetPage(name: '/doc', page: () => Vanban()),
    GetPage(name: '/truyenthong', page: () => Truyenthong()),
    GetPage(name: '/calendar', page: () => Lichhop()),
    GetPage(name: '/addlich', page: () => AddLich(), fullscreenDialog: true),
    GetPage(name: '/detaildoc', page: () => ChitietVanban()),
    GetPage(name: '/detailthongbao', page: () => ChitietThongbao()),
    GetPage(name: '/detailtintuc', page: () => ChitietTintuc()),
    GetPage(name: '/detailcalendar', page: () => ChitietLichhop()),
    GetPage(
        name: '/graph', page: () => TientrinhXyly(), fullscreenDialog: true),
    GetPage(
        name: '/chuyendichdanh',
        page: () => ChuyenDichDanhVanBan(),
        fullscreenDialog: true),
    GetPage(
        name: '/duyetchuyentiep',
        page: () => DuyetChuyenTiepVanBan(),
        fullscreenDialog: true),
    GetPage(
        name: '/duyetphathanh',
        page: () => DuyetPhathanhVanBan(),
        fullscreenDialog: true),
    GetPage(
        name: '/phanphatvanban',
        page: () => PhanPhatVanBan(),
        fullscreenDialog: true),
    GetPage(
        name: '/xacnhanhoanthanh',
        page: () => XacnhanHoanthanhVanBan(),
        fullscreenDialog: true),
    GetPage(
        name: '/tralai', page: () => TralaiVanBan(), fullscreenDialog: true),
    GetPage(
        name: '/thuhoi', page: () => ThuhoiVanBan(), fullscreenDialog: true),
    //Phiên
    GetPage(name: '/user', page: () => User()),
    GetPage(name: '/chat', page: () => const Chat()),
    GetPage(name: '/archives', page: () => Archives()),
    GetPage(name: '/lichngay', page: () => LichhopNgay()),
    GetPage(name: '/filterlich', page: () => FilterLich()),
    GetPage(name: '/message', page: () => const Message()),
    GetPage(name: "/infochat", page: () => InfoChat()),
    GetPage(name: "/infouser", page: () => InfoUser()),
    GetPage(name: '/sharemessage', page: () => ShareMessage()),
    GetPage(name: '/sendmessage', page: () => SendMessage()),
    GetPage(name: '/request', page: () => Request()),
    GetPage(name: '/filterrequest', page: () => FilterRequest()),
    GetPage(
        name: '/addrequest', page: () => AddRequest(), fullscreenDialog: true),
    GetPage(name: '/detailrequest', page: () => DetailRequest()),
    GetPage(name: '/activityrequest', page: () => Activity()),
    GetPage(name: '/teamrequest', page: () => TeamRequest()),
    GetPage(name: '/requestmember', page: () => RequestMember()),
    //Tìm kiếm văn bản
    GetPage(name: '/filtervanban', page: () => FilterVanban()),
    //Công việc
    GetPage(name: '/task', page: () => Task()),
    GetPage(name: '/addtask', page: () => AddTask(), fullscreenDialog: true),
    GetPage(name: '/filtertask', page: () => FilterTask()),
    GetPage(name: '/detailtask', page: () => ChitietTask()),
    GetPage(name: '/addcalendar', page: () => AddLich()),
    GetPage(name: '/activitytask', page: () => AtivityTask()),
    GetPage(name: '/giahantask', page: () => GiahanTask()),
    GetPage(name: '/reporttask', page: () => ReportTask()),
    GetPage(name: '/subtask', page: () => SubTask()),
    //Dự án
    GetPage(name: '/filterproject', page: () => FilterProject()),
    GetPage(name: '/addproject', page: () => AddProject()),
    GetPage(name: '/detailproject', page: () => DetailProject()),
    GetPage(name: '/taskproject', page: () => TaskProject()),
    //HRM
    GetPage(name: '/chamcong', page: () => ChamCongQRPage()),
    GetPage(name: '/phieuluong', page: () => Phieuluong()),
    GetPage(name: '/myprofile', page: () => Myprofile()),
    GetPage(name: '/chamcongQR', page: () => ChamCongQRPage()),
    GetPage(name: '/checkin', page: () => Checkin()),
    GetPage(name: '/hrm', page: () => HRMPage()),
    GetPage(name: '/calam', page: () => CalamPage()),
    GetPage(name: '/diadiemlam', page: () => DiadiemlamPage()),
    //Điều xe
    GetPage(name: '/car', page: () => Dieuxe()),
    GetPage(name: '/detailphieucar', page: () => ChitietPhieuxe()),
    GetPage(name: '/detaillenhcar', page: () => ChitietLenhxe()),
    GetPage(name: '/thongtinxe', page: () => Thontinxe()),
    GetPage(name: '/chitietxe', page: () => Chitietxe()),
    GetPage(name: '/lichsuxe', page: () => Lichsuxe()),
    GetPage(
        name: '/duyetlenh', page: () => FormDuyetXe(), fullscreenDialog: true),
    GetPage(
        name: '/laplenh', page: () => FormLapLenhXe(), fullscreenDialog: true),
    GetPage(
        name: '/tralailenh',
        page: () => FormTralaiDuyetXe(),
        fullscreenDialog: true),
    GetPage(
        name: '/hoanthanhlenh',
        page: () => FormHoanthanhlenh(),
        fullscreenDialog: true),
    GetPage(
        name: '/capnhatrangthaixe',
        page: () => FormCapnhatTrangthaiXe(),
        fullscreenDialog: true),

    GetPage(
        name: '/duyetphieu',
        page: () => FormDuyetPhieu(),
        fullscreenDialog: true),
    GetPage(
        name: '/tralaiphieu',
        page: () => FormTralaiPhieuDuyetXe(),
        fullscreenDialog: true),
    GetPage(
        name: '/chonlaixe',
        page: () => Danhsachlaixe(),
        fullscreenDialog: true),
    GetPage(name: '/chonxe', page: () => Danhsachxe(), fullscreenDialog: true),
    //Meeting
    GetPage(name: '/meet', page: () => MeetPage()),
    GetPage(name: '/meetdesktop', page: () => MeetDesktopPage()),
  ];
}
