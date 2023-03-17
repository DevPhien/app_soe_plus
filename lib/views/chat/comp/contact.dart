// import 'package:circular_check_box/circular_check_box.dart';
// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:soe/utils/Config.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/treeview.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';

class ContactModal extends StatefulWidget {
  final ChatController chatController = Get.put(ChatController());
  ContactModal(
      {this.onValueChange,
      this.initialValue,
      this.datas,
      this.onSend,
      this.one,
      this.icon,
      this.id,
      this.name,
      this.subtitle,
      this.title,
      this.isBar});

  final String? initialValue;
  final List? datas;
  final void Function(dynamic)? onValueChange;
  final onSend;
  final bool? one;
  final String? id;
  final String? subtitle;
  final String? name;
  final String? title;
  final String? icon;
  final isBar;
  @override
  _ContactModalState createState() {
    return _ContactModalState();
  }
}

class _ContactModalState extends State<ContactModal> {
  String _selectedId = "";
  String _phongbanID = "";
  List datas = [];
  List chons = [];
  bool one = true;
  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue!;

    datas = [];
    for (var e in widget.chatController.congty_datas) {
      List keys = widget.chatController.phongban_datas
          .where((x) => widget.chatController.phongban_datas
              .where((u) => x["Congty_ID"] == e["Congty_ID"])
              .toList()
              .isNotEmpty)
          .toList();
      for (var m in keys) {
        List us = widget.datas!
            .where((u) => (u["Phongban_ID"] ?? u["phongbans"])
                .toString()
                .toLowerCase()
                .contains(m["Phongban_ID"].toString().toLowerCase()))
            .toList();
        us.sort((a, b) {
          return a['STT'].compareTo(b['STT']);
        });
        datas.addAll(us);
      }
    }
    ///////////////////////////////
    one = widget.one!;
    if (datas.isNotEmpty) {
      if (_selectedId.isNotEmpty) {
        for (var u in datas
            .where((x) => _selectedId.split(",").contains(x[widget.id]))) {
          u["check"] = true;
          chons.add(u);
        }
        for (var u in datas
            .where((x) => !_selectedId.split(",").contains(x[widget.id]))) {
          u["check"] = false;
        }
      } else {
        for (var u in datas) {
          u["check"] = false;
        }
      }
      //render(datas);
    }
  }

  Widget renderOne(item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              _selectedId = item["${widget.id}"];
              chons = [item];
            });
            if (widget.onValueChange != null) {
              if (widget.isBar == false) {
                widget.onValueChange!(chons);
              } else {
                widget.onValueChange!(item["${widget.id}"]);
              }
            }
            onSend();
          },
          leading: SizedBox(
            width: 48.0,
            height: 48.0,
            child: Stack(
              children: [
                if (item["hasImage"])
                  CircularImage(
                    radius: 24,
                    source: Golbal.congty!.fileurl + item["anhThumb"],
                  )
                else
                  CircleAvatar(
                    backgroundColor: HexColor(item['bgColor']),
                    radius: 24,
                    child: Text(
                      "${item['subten']}",
                      style: TextStyle(
                        fontSize: 20,
                        color: HexColor('#ffffff'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          title: Text(
            item[widget.name] ?? "",
          ),
          subtitle: Text(
            item["${widget.subtitle}"] ?? "",
          ),
          trailing: Radio<dynamic>(
            value: item["${widget.id}"],
            groupValue: _selectedId,
            onChanged: (v) {
              setState(() {
                _selectedId = v.toString();
                chons = [item];
              });
              if (widget.onValueChange != null) {
                if (widget.isBar == false) {
                  widget.onValueChange!(chons);
                } else {
                  widget.onValueChange!(v);
                }
              }
              onSend();
            },
          ),
        ),
        const Divider(
          height: 1.0,
          color: Color(0xFFeeeeee),
        )
      ],
    );
  }

  Widget renderTwo(item) {
    return Column(
      children: <Widget>[
        ListTile(
            onTap: () {
              setState(() {
                if (item["check"] != null) {
                  item["check"] = !item["check"];
                } else {
                  item["check"] = true;
                }
                if (item["check"]) {
                  chons.add(item);
                } else {
                  chons.remove(item);
                }
                if (widget.onValueChange != null) {
                  if (widget.isBar == false) {
                    widget.onValueChange!(chons);
                  } else {
                    widget.onValueChange!(item["${widget.id}"]);
                  }
                }
              });
            },
            leading: SizedBox(
              width: 48.0,
              height: 48.0,
              child: Stack(
                children: [
                  if (item["hasImage"])
                    CircularImage(
                      radius: 24,
                      source: Golbal.congty!.fileurl + item["anhThumb"],
                    )
                  else
                    CircleAvatar(
                      backgroundColor: HexColor(item['bgColor']),
                      radius: 24,
                      child: Text(
                        "${item['subten']}",
                        style: TextStyle(
                          fontSize: 20,
                          color: HexColor('#ffffff'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            title: Text(
              item[widget.name] ?? "",
            ),
            subtitle: Text(
              item["${widget.subtitle}"] ?? "",
            ),
            trailing: Checkbox(
                tristate: false,
                activeColor: const Color(0xFF6dd230),
                value: item["check"] ?? false,
                onChanged: (v) {
                  setState(() {
                    setState(() {
                      item["check"] = v;
                      if (item["check"]) {
                        chons.add(item);
                      } else {
                        chons.remove(item);
                      }
                    });
                    if (widget.onValueChange != null) {
                      if (widget.isBar == false) {
                        widget.onValueChange!(chons);
                      } else {
                        widget.onValueChange!(item["${widget.id}"]);
                      }
                    }
                  });
                })),
        const Divider(
          height: 1.0,
          color: Color(0xFFeeeeee),
        )
      ],
    );
  }

  onSearch(txt) {
    setState(() {
      datas = widget.datas!
          .where((u) =>
              u["${widget.name}"]
                  .toString()
                  .toLowerCase()
                  .contains(txt.toString().toLowerCase()) ||
              u["phone"]
                  .toString()
                  .toLowerCase()
                  .contains(txt.toString().toLowerCase()) ||
              u["enFullName"]
                  .toString()
                  .toLowerCase()
                  .contains(txt.toString().toLowerCase()))
          .toList();
    });
  }

  choiceDeptAction(us) {
    _phongbanID = us;
    setState(() {
      datas = widget.datas!
          .where((u) => u["phongbans"]
              .toString()
              .toLowerCase()
              .contains(_phongbanID.toString().toLowerCase()))
          .toList();
    });
  }

  refersh() {
    _phongbanID = "";
    setState(() {
      datas = widget.datas!;
      if (datas.isNotEmpty) {
        if (_selectedId.isNotEmpty) {
          for (var u
              in datas.where((x) => _selectedId.contains(x[widget.id]))) {
            u["check"] = true;
          }
        } else {
          for (var u in datas) {
            u["check"] = false;
          }
        }
      }
    });
  }

  goTreeView() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TreeView(
            onValueChange: (v) {},
            initialValue: _phongbanID,
            one: true,
            datas: widget.chatController.phongban_datas,
            title: "Chọn phòng ban",
            onSend: choiceDeptAction),
        fullscreenDialog: true));
  }

  checkGroup(m, bool v) {
    for (var u in datas
        .where((x) => x["tenToChuc"]
            .toString()
            .toLowerCase()
            .contains(m["tenToChuc"].toString().toLowerCase()))
        .toList()) {
      u["check"] = v;
      if (u["check"]) {
        chons.add(u);
      } else {
        chons.remove(u);
      }
      if (widget.onValueChange != null) {
        if (widget.isBar == false) {
          widget.onValueChange!(chons);
        } else {
          widget.onValueChange!(u["${widget.id}"]);
        }
      }
    }
    setState(() {
      m["check"] = v;
    });
  }

  onSend() {
    Navigator.of(context).pop(true);
    var us = [];
    if (widget.one!) {
      if (chons.isNotEmpty) {
        for (var u in chons) {
          us.add(u);
        }
      }
      widget.onSend(us);
    } else {
      if (chons.isNotEmpty) {
        for (var u in chons) {
          us.add(u);
        }
      }
      widget.onSend(us);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.isBar == false
            ? null
            : AppBar(
                title: Text(widget.title!,
                    style: const TextStyle(color: appColor)),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black54),
                titleSpacing: 0.0,
                elevation: 0.0,
                actions: <Widget>[
                  if (_phongbanID != "")
                    IconButton(
                      onPressed: refersh,
                      icon: const Icon(Icons.refresh),
                    )
                  else
                    Container(
                      width: 0.0,
                    ),
                  IconButton(
                    onPressed: onSend,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
        body: Column(
          children: <Widget>[
            AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFf9f8f8),
                    border:
                        Border.all(color: const Color(0xffeeeeee), width: 1.0)),
                child: TextField(
                    keyboardAppearance: Brightness.light,
                    onChanged: (txt) {
                      onSearch(txt);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Tìm tên hoặc số điện thoại',
                      prefixIcon: Icon(Icons.search),
                      // suffixIcon: InkWell(
                      //     child: const Icon(AntDesign.filter),
                      //     onTap: goTreeView),
                    )),
              ),
            ),
            ExpansionTile(
              title: Text(
                "Đã chọn (${chons.length})",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
              children: [
                Wrap(
                  children: chons.map((u) {
                    return Container(
                        margin: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: Chip(
                          onDeleted: widget.one!
                              ? null
                              : () {
                                  setState(() {
                                    u["check"] = false;
                                    chons.remove(u);
                                    if (widget.onValueChange != null) {
                                      if (widget.isBar == false) {
                                        widget.onValueChange!(chons);
                                      } else {
                                        widget
                                            .onValueChange!(u["${widget.id}"]);
                                      }
                                    }
                                  });
                                },
                          deleteIcon: widget.one!
                              ? null
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.black45,
                                ),
                          label: Text(u["fullName"]),
                          avatar: Stack(
                            children: [
                              if (u["hasImage"])
                                CircularImage(
                                  radius: 24,
                                  source:
                                      Golbal.congty!.fileurl + u["anhThumb"],
                                )
                              else
                                CircleAvatar(
                                  backgroundColor: HexColor(u['bgColor']),
                                  radius: 24,
                                  child: Text(
                                    "${u['subten']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: HexColor('#ffffff'),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ));
                  }).toList(),
                )
              ],
            ),
            Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: datas.length,
                itemBuilder: (ct, i) {
                  if (i == 0 ||
                      datas[i]["tenCongty"] != datas[i - 1]["tenCongty"]) {
                    return Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${datas[i]["tenCongty"] ?? ""}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        datas[i]["tenToChuc"] != null
                            ? Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${datas[i]["tenToChuc"] ?? ""}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appColor),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Checkbox(
                                            tristate: false,
                                            activeColor:
                                                const Color(0xFF6dd230),
                                            value: datas[i]["check"] ?? false,
                                            onChanged: (v) {
                                              checkGroup(datas[i], v!);
                                            }))
                                  ],
                                ),
                              )
                            : const SizedBox(width: 0.0, height: 0.0),
                        one ? renderOne(datas[i]) : renderTwo(datas[i])
                      ],
                    );
                  }
                  if (i == 0 ||
                      datas[i]["tenToChuc"] != datas[i - 1]["tenToChuc"]) {
                    return Wrap(
                      children: [
                        datas[i]["tenToChuc"] != null
                            ? Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${datas[i]["tenToChuc"] ?? ""}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appColor),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(right: 5.0),
                                    //   child: CircularCheckBox(
                                    //       value: datas[i]["check"] ?? false,
                                    //       materialTapTargetSize:
                                    //           MaterialTapTargetSize.padded,
                                    //       onChanged: (bool v) {
                                    //         checkGroup(datas[i], v);
                                    //       }),
                                    // )
                                  ],
                                ),
                              )
                            : const SizedBox(width: 0.0, height: 0.0),
                        one ? renderOne(datas[i]) : renderTwo(datas[i])
                      ],
                    );
                  }
                  return one ? renderOne(datas[i]) : renderTwo(datas[i]);
                },
              )),
            )
          ],
        ),
      );
}
