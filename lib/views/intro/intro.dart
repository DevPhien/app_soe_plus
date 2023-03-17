import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../../utils/golbal/golbal.dart';
import '../login/login.dart';
import 'choncongty.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  IntroState createState() => IntroState();
}

// Custom config
class IntroState extends State<Intro> {
  List<PageViewModel> listPagesViewModel = <PageViewModel>[];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 400;
    listPagesViewModel = [
      PageViewModel(
        title: "",
        bodyWidget: Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 0.0, right: 0.0, bottom: 20.0),
          child: Image(
            image: const AssetImage("assets/intro1.png"),
            fit: BoxFit.fitWidth,
            height: height,
          ),
        ),
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Text(
                "Quản trị & điều hành Doanh nghiệp",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff0186f8),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Text(
                "Giải pháp tổng thể, vượt trội thực hiện chuyển đổi số,  +1000 doanh nghiệp thương hiệu tin dùng",
                style: TextStyle(
                  color: Color(0xff505050),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      PageViewModel(
        title: "",
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Text(
                "Chuyển đổi số tổng thể ưu việt nhất",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff0186f8),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Text(
                "Giải pháp tổng thể, bảo mật, tích hợp đa nền tảng. Tùy biến điều chỉnh phù hợp với yêu cầu",
                style: TextStyle(
                  color: Color(0xff505050),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        bodyWidget: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 0.0, right: 0.0, bottom: 20.0),
            child: Image(
              image: const AssetImage("assets/intro2.png"),
              fit: BoxFit.fitWidth,
              height: height,
            )),
      ),
      PageViewModel(
        title: "",
        bodyWidget: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 0.0, right: 0.0, bottom: 20.0),
            child: Image(
              image: const AssetImage("assets/intro3.png"),
              fit: BoxFit.fitWidth,
              height: height,
            )),
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Text(
                "Văn phòng điện tử không giấy tờ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff0186f8),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Text(
                "Môi trường làm việc cộng tác, liên kết và chia sẻ. Giảm thiểu chi phí, thời gian, tăng hiệu suất công việc",
                style: TextStyle(
                  color: Color(0xff505050),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      )
    ];
    bool isSafeA = MediaQuery.of(context).viewPadding.top > 0 &&
        MediaQuery.of(context).viewPadding.bottom > 0;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              child: ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  height: isSafeA ? 150 : 120,
                  color: const Color(0xFF0078D4),
                ),
              ),
            ),
            Positioned(
              top: isSafeA ? 75 : 55,
              left: 20,
              child: const Material(
                type: MaterialType.transparency,
                child: Text("Smart Office",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0)),
              ),
            ),
            IntroductionScreen(
              globalBackgroundColor: Colors.transparent,
              pages: listPagesViewModel,
              onDone: () {
                if (Golbal.congty != null) {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const LoginPage()),
                      (Route<dynamic> r) => false);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const ChonCongTy()),
                      (Route<dynamic> r) => false);
                }
              },
              onSkip: () {
                if (Golbal.congty != null) {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const LoginPage()),
                      (Route<dynamic> r) => false);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const ChonCongTy()),
                      (Route<dynamic> r) => false);
                }
              },
              showSkipButton: true,
              skip: const Text("BỎ QUA",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xff0186f8))),
              next: const Text("TIẾP TỤC",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xff0186f8))),
              done: const Text("TIẾP TỤC",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xff0186f8))),
              dotsDecorator: const DotsDecorator(
                  size: Size.square(12.0),
                  activeSize: Size(12.0, 12.0),
                  activeColor: Color(0xff0186f8),
                  color: Color(0xff94baf8),
                  spacing: EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: CircleBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
