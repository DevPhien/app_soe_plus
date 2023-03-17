// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:soe/utils/Config.dart';

class TreeView extends StatefulWidget {
  const TreeView(
      {this.onValueChange,
      this.initialValue,
      this.datas,
      this.onSend,
      this.one,
      this.root,
      this.title});

  final String? initialValue;
  final List? datas;
  final void Function(dynamic)? onValueChange;
  final onSend;
  final bool? one;
  final String? title;
  final String? root;
  @override
  State createState() => TreeViewState();
}

class TreeViewState extends State<TreeView> {
  String _selectedId = "";
  List datas = [];
  List<dynamic> listDatas = [];
  bool one = true;
  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue!;
    datas = widget.datas!;
    one = widget.one!;
    if (datas.isEmpty) {
    } else {
      if (_selectedId != "" && _selectedId.isNotEmpty) {
        for (var u
            in datas.where((x) => _selectedId.contains(x["Phongban_ID"]))) {
          u["check"] = true;
        }
      }
      renderTreeView(datas);
    }
  }

  onSearch(txt) {
    render(datas.where((u) => u["tenPhongban"].toString().contains(txt)));
  }

  render(datas) {
    if (mounted) {
      List forms = <Widget>[];
      if (one != null) {
        if (one == true) {
          for (var item in datas) {
            forms.add(RadioListTile(
              onChanged: (v) {
                _selectedId = v.toString();
                widget.onValueChange!(v);
                render(datas);
                onSend();
              },
              value: "${item["Phongban_ID"]}",
              groupValue: _selectedId,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item["tenPhongban"] ?? "",
                    style: TextStyle(
                        fontWeight: item["lv"] != 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.0,
                        color: item["lv"] == 1 ? Colors.red : Colors.black87),
                  )
                ],
              ),
            ));
          }
        } else if (one == false) {
          for (var item in datas) {
            forms.add(CheckboxListTile(
              onChanged: (v) {
                item["check"] = v;
                render(datas);
              },
              value: item["check"] ?? false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item["tenPhongban"] ?? "",
                    style: TextStyle(
                        fontWeight: item["lv"] != 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.0,
                        color: item["lv"] == 1 ? Colors.red : Colors.black87),
                  ),
                ],
              ),
            ));
          }
        }
      } else {
        for (var item in datas) {
          forms.add(InkWell(
              onTap: () {
                render(datas);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item["tenPhongban"] ?? "",
                    style: TextStyle(
                        fontWeight: item["lv"] != 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.0,
                        color: item["lv"] == 1 ? Colors.red : Colors.black87),
                  ),
                ],
              )));
        }
      }

      setState(() {
        listDatas = forms;
      });
    }
  }

  renderTreeView(datas) {
    if (mounted) {
      List forms = <Widget>[];
      var groups = groupBy(datas, (dynamic obj) => obj['tenCongty'])
          .map((k, v) => MapEntry(k, v.map((item) => item).toList()));
      if (widget.root != null) {
        for (var k in groups.keys) {
          forms.add(Container(
            color: const Color(0xFFeeeeee),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                const Icon(FontAwesome.building_o),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    k ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ));
          var datas = groups[k]!.toList();
          for (var item
              in datas.where((dynamic x) => x["Phongban_ID"] == widget.root)) {
            forms.add(deQuyTreeView(datas, item));
          }
        }
      } else {
        for (var k in groups.keys) {
          forms.add(Container(
            color: const Color(0xFFeeeeee),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                const Icon(FontAwesome.building_o),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    k ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ));
          var datas = groups[k]!.toList();
          for (var item
              in datas.where((dynamic x) => x["Parent_ID"] == widget.root)) {
            forms.add(deQuyTreeView(datas, item));
          }
        }
      }
      setState(() {
        listDatas = forms;
      });
    }
  }

  dequyCheck(List datas, dynamic data) {
    var childs = datas.where((x) => x["Parent_ID"] == data["Phongban_ID"]);
    for (var item in childs) {
      item["check"] = data["check"];
      dequyCheck(datas, item);
    }
  }

  Widget deQuyTreeView(List datas, dynamic data, {bool? lv}) {
    var childs = datas.where((x) => x["Parent_ID"] == data["Phongban_ID"]);
    if (childs != null && childs.isNotEmpty) {
      return (ExpansionTile(
          backgroundColor: (data["lv"] == 1 || data["lv"] == null)
              ? const Color(0xFFf5f5f5)
              : Colors.white,
          leading: one != null
              ? (one == true
                  ? Radio(
                      onChanged: (v) {
                        _selectedId = v.toString();
                        widget.onValueChange!(v);
                        renderTreeView(datas);
                        onSend();
                      },
                      value: "${data["Phongban_ID"]}",
                      groupValue: _selectedId,
                    )
                  : Checkbox(
                      onChanged: (v) {
                        data["check"] = v;
                        dequyCheck(datas, data);
                        widget.onValueChange!(v);
                        renderTreeView(datas);
                      },
                      value: data["check"] ?? false,
                    ))
              : null,
          initiallyExpanded: true,
          title: one != null
              ? Container(
                  padding: EdgeInsets.only(
                      left: data["lv"] != null
                          ? int.parse(data["lv"].toString()) * 10.0
                          : 0.0),
                  child: Text(
                    data["tenPhongban"] ?? "",
                    style: TextStyle(
                        fontWeight: lv != true && data["lv"] != 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.0,
                        color: lv != true &&
                                (data["lv"] == 1 || data["lv"] == null)
                            ? Colors.blue
                            : Colors.black87),
                  ),
                )
              : InkWell(
                  onTap: () {
                    _selectedId = data["Phongban_ID"];
                    renderTreeView(datas);
                    onSend();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: data["lv"] != null
                            ? int.parse(data["lv"].toString()) * 10.0
                            : 0.0),
                    child: Text(
                      data["tenPhongban"] ?? "",
                      style: TextStyle(
                          fontWeight: lv != true && data["lv"] != 3
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14.0,
                          color: lv != true &&
                                  (data["lv"] == 1 || data["lv"] == null)
                              ? Colors.blue
                              : Colors.black87),
                    ),
                  )),
          children: childs.map((item) {
            return deQuyTreeView(datas, item, lv: true);
          }).toList()));
    } else {
      return (ListTile(
        leading: one != null
            ? (one
                ? Radio(
                    onChanged: (v) {
                      _selectedId = v.toString();
                      widget.onValueChange!(v);
                      renderTreeView(datas);
                      onSend();
                    },
                    value: "${data["Phongban_ID"]}",
                    groupValue: _selectedId,
                  )
                : Checkbox(
                    onChanged: (v) {
                      data["check"] = v;
                      widget.onValueChange!(v);
                      renderTreeView(datas);
                    },
                    value: data["check"] ?? false,
                  ))
            : null,
        title: one != null
            ? Container(
                padding: EdgeInsets.only(
                    left: data["lv"] != null
                        ? int.parse(data["lv"].toString()) * 10.0
                        : 15.0),
                child: Text(
                  data["tenPhongban"] ?? "",
                  style: TextStyle(
                      fontWeight:
                          lv != true ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14.0,
                      color: data["lv"] == 1
                          ? Colors.red
                          : lv != true
                              ? Colors.black87
                              : const Color(0xFF666666)),
                ))
            : InkWell(
                onTap: () {
                  _selectedId = data["Phongban_ID"];
                  renderTreeView(datas);
                  onSend();
                },
                child: Container(
                    padding: EdgeInsets.only(
                        left: data["lv"] != null
                            ? int.parse(data["lv"].toString()) * 10.0
                            : 15.0),
                    child: Text(
                      data["tenPhongban"] ?? "",
                      style: TextStyle(
                          fontWeight:
                              lv != true ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14.0,
                          color: data["lv"] == 1
                              ? Colors.red
                              : lv != true
                                  ? Colors.black87
                                  : const Color(0xFF666666)),
                    )),
              ),
      ));
    }
  }

  onSend() {
    Navigator.of(context).pop(true);
    if (one != null) {
      if (one) {
        widget.onSend(_selectedId);
      } else {
        var us = [];
        var checks = datas.where((u) => u["check"] == true);
        if (checks != null && checks.isNotEmpty) {
          for (var u in checks) {
            us.add(u["Phongban_ID"]);
          }
        }
        widget.onSend(us);
      }
    } else {
      widget.onSend(_selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.title != null
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black54),
              titleSpacing: 0.0,
              title: Text(
                widget.title!,
                style: const TextStyle(color: appColor),
              ))
          : null,
      body: ListView.builder(
        key: const Key("US"), //new
        itemBuilder: (BuildContext context, int index) => listDatas[index],
        itemCount: listDatas.length,
      ),
    );
  }
}
