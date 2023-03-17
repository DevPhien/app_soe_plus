import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewMobile extends StatefulWidget {
  final String url;
  final String chuky;
  final dynamic imagePos;
  const WebViewMobile(
      {Key? key, required this.url, required this.chuky, this.imagePos})
      : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewMobile> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController webcontroller;
  var imagearrPos = [];
  var imagePos = {};
  double zommImage = 60;
  double rotation = 0;
  bool showPad = false;
  bool showRot = false;
  bool insetChuky = false;
  double step = 10.0;
  double panx = Golbal.screenSize.height - 220;
  double pany = 220;
  bool showDelete = false;
  double ratioImg = 1.0;
  @override
  void initState() {
    super.initState();
    if (widget.imagePos != null && widget.imagePos.length > 0) {
      imagePos = widget.imagePos[0];
      imagearrPos = widget.imagePos;
      if (imagePos["id"] == null) imagePos["id"] = uuid.v4();
      insetChuky = true;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    initPlatformState();
  }

  void closeOrient() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> initPlatformState() async {
    ratioImg = await getImageInfo(widget.chuky);
  }

  @override
  dispose() {
    closeOrient();
    super.dispose();
  }

  Future<void> setValuePos(data) async {
    var idx = imagearrPos.indexWhere((element) => element["id"] == data["id"]);
    if (idx != -1) {
      imagearrPos[idx] = imagePos;
      await webcontroller.runJavascript(
          'initImageArray("${widget.chuky}",\'${json.encode(imagearrPos)}\')');
    }
  }

  JavascriptChannel _imagePosJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'imagePos',
        onMessageReceived: (JavascriptMessage message) {
          if (kDebugMode) {
            print(message.message);
          }
          var data = json.decode(message.message);
          for (var k in data.keys) {
            imagePos[k] = data[k];
          }
          setValuePos(data);
          setState(() {
            if (data["event"] == "click") {
              showDelete = !showDelete;
            }
          });
        });
  }

  JavascriptChannel _initPosJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'initimagePos',
        onMessageReceived: (JavascriptMessage message) {
          if (kDebugMode) {
            print(message.message);
          }
          if (message.message == "-1") initImagePost();
        });
  }

  var uuid = const Uuid();
  Future<void> sendChuky(BuildContext context) async {
    if (insetChuky == false) {
      setState(() {
        insetChuky = true;
      });
    }
    var obj = {
      "id": uuid.v4().replaceAll("-", ""),
      "x": imagePos["x"] ?? 200,
      "y": imagePos["y"] ?? 200
    };
    imagePos = obj;
    imagearrPos.add(obj);
    await webcontroller
        .runJavascript('initImage("${widget.chuky}",0,120,"${obj["id"]}");');
  }

  Future<void> delChuky() async {
    bool rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xoá chữ ký này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(color: Colors.black45, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs) {
      imagearrPos.removeWhere((item) => item["id"] == imagePos["id"]);
      setState(() {
        showDelete = false;
      });
      await webcontroller.runJavascript('delImage()');
    }
  }

  Future<void> updateChuky(double value) async {
    await webcontroller.runJavascript('resetImage(${value * 3});');
  }

  Future<void> updateChukyRotation(double value) async {
    await webcontroller.runJavascript('resetImageRotation($value);');
  }

  Future<void> updateChukyPos() async {
    await webcontroller
        .runJavascript('resetImagePos(${imagePos["x"]},${imagePos["y"]});');
  }

  Widget joystick() {
    return Joystick(
        mode: JoystickMode.all,
        listener: (details) {
          imagePos["x"] = imagePos["x"] + step * details.x;
          imagePos["y"] = imagePos["y"] + step * details.y;
          updateChukyPos();
        });
  }

  Future<double> getImageInfo(String url) {
    try {
      if (url.contains(".svg")) return Future.value(1);
      Completer<double> completer = Completer();
      Image image = Image.network(url);
      image.image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
                var myImage = image.image;
                double ratio =
                    myImage.width.toDouble() / myImage.height.toDouble();
                try {
                  if (completer.isCompleted == false) completer.complete(ratio);
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              onError: (_, __) {
                if (completer.isCompleted == false) {
                  completer.complete(1.0);
                }
              },
            ),
          );
      return completer.future;
    } on Exception catch (e) {
      return Future.value(1.0);
    } catch (error) {
      return Future.value(1.0);
    }
  }

  dynamic initHeightIMG() {
    imagearrPos.where((x) => x["height"] == null).forEach((element) {
      element["height"] = element["width"] / ratioImg;
    });
    return imagearrPos;
  }

  void initImagePost() {
    if (widget.imagePos != null && widget.imagePos.length > 0) {
      if (insetChuky == false) {
        setState(() {
          insetChuky = true;
        });
      }
      imagePos = List.castFrom(widget.imagePos).last;
      if (imagePos["id"] == null) imagePos["id"] = uuid.v4();
      for (var element in imagearrPos) {
        webcontroller.runJavascript(
            'initImagePost("${widget.chuky}",\'${json.encode(element)}\');');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          closeOrient();
          return true;
        },
        child: Scaffold(
          floatingActionButton: showDelete
              ? FloatingActionButton(
                  heroTag: "delButton",
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    delChuky();
                  },
                  child: const Icon(FontAwesome.trash_o, color: Colors.white),
                )
              : null,
          body: Row(
            children: [
              SafeArea(
                right: false,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "ExitButton",
                        backgroundColor: const Color(0xFFaaaaaa),
                        onPressed: () async {
                          Get.back();
                        },
                        child:
                            const Icon(FontAwesome.close, color: Colors.yellow),
                      ),
                      const SizedBox(height: 5),
                      if (insetChuky == false) const Spacer(),
                      FloatingActionButton(
                        heroTag: "SignButton",
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          sendChuky(context);
                        },
                        child: const Icon(FontAwesome.pencil_square_o,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      if (insetChuky)
                        InkWell(
                          child: const Icon(FontAwesome.rotate_right,
                              size: 36, color: Colors.red),
                          onTap: () {
                            setState(() {
                              showRot = !showRot;
                            });
                          },
                        ),
                      if (insetChuky)
                        Expanded(
                            child: RotatedBox(
                          quarterTurns: 1,
                          child: SizedBox(
                            child: Slider(
                              value: zommImage,
                              max: 100,
                              label: "${zommImage.round()} %",
                              onChanged: (double value) {
                                updateChuky(value);
                                setState(() {
                                  zommImage = value;
                                });
                              },
                            ),
                          ),
                        )),
                      const SizedBox(height: 5),
                      if (insetChuky)
                        InkWell(
                          child: const Icon(MaterialIcons.gamepad,
                              size: 36, color: Colors.amber),
                          onTap: () {
                            setState(() {
                              showPad = !showPad;
                            });
                          },
                        ),
                      const SizedBox(height: 5),
                      if (insetChuky)
                        FloatingActionButton(
                          onPressed: () async {
                            closeOrient();
                            Get.back(result: initHeightIMG());
                          },
                          child: const Icon(Ionicons.save_outline),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      initialUrl: Uri.encodeFull(widget.url),
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: <JavascriptChannel>{
                        _imagePosJavascriptChannel(context),
                        _initPosJavascriptChannel(context)
                      },
                      onWebViewCreated: (WebViewController controller) {
                        _controller.complete(controller);
                        webcontroller = controller;
                      },
                    ),
                    if (showPad)
                      Positioned(
                        top: pany - 210,
                        left: panx - 100,
                        child: Column(
                          children: [
                            joystick(),
                            Draggable(
                              feedback: const CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: Icon(Feather.move, color: Colors.amber),
                              ),
                              childWhenDragging: Container(),
                              onDragUpdate: (DragUpdateDetails detail) {
                                setState(() {
                                  panx = detail.globalPosition.dx;
                                  pany = detail.globalPosition.dy;
                                });
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: Icon(Feather.move, color: Colors.amber),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (showRot)
                      Positioned(
                        top: 20,
                        bottom: 20,
                        child: Column(
                          children: [
                            HoldDetector(
                                holdTimeout: const Duration(milliseconds: 200),
                                enableHapticFeedback: true,
                                onHold: () {
                                  if (rotation >= 1) {
                                    double value = rotation - 5;
                                    if (value < 0) value = 0;
                                    updateChukyRotation(value);
                                    imagePos["Rotation"] = value;
                                    setState(() {
                                      rotation = value;
                                    });
                                  }
                                },
                                child: const Icon(
                                  AntDesign.minuscircle,
                                  size: 32,
                                  color: Colors.orange,
                                )),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Slider(
                                  value: rotation,
                                  max: 360,
                                  label: rotation.toString(),
                                  onChanged: (double value) {
                                    updateChukyRotation(value);
                                    imagePos["Rotation"] = value;
                                    setState(() {
                                      rotation = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            HoldDetector(
                                holdTimeout: const Duration(milliseconds: 200),
                                enableHapticFeedback: true,
                                onHold: () {
                                  if (rotation < 360) {
                                    double value = rotation + 5;
                                    if (value > 360) value = 360;
                                    updateChukyRotation(value);
                                    imagePos["Rotation"] = value;
                                    setState(() {
                                      rotation = value;
                                    });
                                  }
                                },
                                child: const Icon(
                                  AntDesign.pluscircle,
                                  size: 36,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
