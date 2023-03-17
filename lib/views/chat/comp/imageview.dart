// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ImagesViewPage extends StatefulWidget {
  final String imgPath;
  final List imgs;
  final int? index;
  const ImagesViewPage(this.imgPath, this.imgs, {Key? key, this.index})
      : super(key: key);

  @override
  ImagesViewPageState createState() {
    return ImagesViewPageState();
  }
}

class ImagesViewPageState extends State<ImagesViewPage> {
  late PageController _pcontroller;
  int cindex = 0;
  String path = "";
  List imgs = [];
  @override
  void initState() {
    super.initState();
    path = widget.imgPath;
    if (widget.imgs != null && widget.imgs.isNotEmpty) {
      for (var item in widget.imgs) {
        imgs.add("${item["Duongdan"] ?? item["FileSource"]}");
      }
      cindex = widget.index ?? imgs.indexOf(path);
      _pcontroller = PageController(initialPage: cindex);
    } else {
      imgs = [path];
      _pcontroller = PageController();
    }
  }

  @override
  void dispose() {
    _pcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.down,
        movementDuration: const Duration(milliseconds: 100),
        resizeDuration: const Duration(milliseconds: 100),
        key: const Key("t"),
        onDismissed: (direction) {
          Navigator.of(context).pop();
        },
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 0, 0, .2),
            body: Stack(
              children: <Widget>[
                PageView.builder(
                    controller: _pcontroller,
                    itemCount: imgs.length,
                    onPageChanged: (i) {
                      setState(() {
                        cindex = i;
                        path = imgs[cindex];
                      });
                    },
                    itemBuilder: (context, i) {
                      return Align(
                          alignment: Alignment.center,
                          child: PhotoView(
                            key: Key(i.toString()),
                            imageProvider: CachedNetworkImageProvider(imgs[i]),
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: 4.0,
                          ));
                    }),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        elevation: 0.0,
                        backgroundColor: const Color.fromRGBO(0, 0, 0, .2),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32.0,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        title: Text("${cindex + 1}/${imgs.length}"),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 32.0,
                            ),
                            onPressed: () {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              Share.share(path,
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
