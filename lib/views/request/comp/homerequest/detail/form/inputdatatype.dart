import 'package:date_time_picker/date_time_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/request/comp/homerequest/detail/detailrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/detail/form/numerictextformatter.dart';

// ignore: must_be_immutable
class InputDataType extends StatelessWidget {
  final DetailRequestController controller = Get.put(DetailRequestController());
  final dynamic input;
  InputBorder? border;
  final bool? isview;
  InputDataType({Key? key, this.input, this.border, this.isview})
      : super(key: key);

  Widget typeWidget(context) {
    Widget inputDataType = Container();
    border ??= InputBorder.none;
    switch (input["KieuTruong"]) {
      case "datetime":
        input["IsGiatri"] ??= DateTime.now();
        inputDataType = DateTimePicker(
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'dd/MM/yyyy',
          initialValue: controller.datetimeString(input["IsGiatri"]),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.event),
            filled: true,
            fillColor: Colors.white,
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "date":
        input["IsGiatri"] ??= DateTime.now();
        inputDataType = DateTimePicker(
          type: DateTimePickerType.date,
          dateMask: 'dd/MM/yyyy',
          initialValue: controller.datetimeString(input["IsGiatri"]),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            labelText: '',
            hintStyle: TextStyle(
              color: Color(0xFFcccccc),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.event),
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "time":
        input["IsGiatri"] ??= TimeOfDay.now().format(context);
        inputDataType = DateTimePicker(
          type: DateTimePickerType.time,
          initialValue: input["IsGiatri"],
          use24HourFormat: true,
          dateMask: 'HH:mm"',
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.access_time),
            filled: true,
            fillColor: Colors.white,
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "varchar":
        inputDataType = Container(
          color: Colors.white,
          child: TextFormField(
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            maxLength: input["IsLength"] ?? 2500,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 _]')),
            ],
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "nvarchar":
        inputDataType = TextFormField(
          initialValue: input["IsGiatri"],
          keyboardAppearance: Brightness.light,
          maxLength: input["IsLength"] ?? 2500,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            labelText: '',
            hintStyle: const TextStyle(
              color: Color(0xFFcccccc),
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFcccccc), width: 1.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          style: Golbal.styleinput,
          onSaved: (String? str) {
            input["IsGiatri"] = str;
          },
          validator: (value) {
            if (input["IsRequired"] == true && value!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
        );
        break;
      case "email":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          color: Colors.white,
          child: TextFormField(
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            maxLength: input["IsLength"] ?? 2500,
            keyboardType: TextInputType.emailAddress,
            style: Golbal.styleinput,
            validator: (value) {
              if (!EmailValidator.validate(value!)) {
                return 'Vui lòng nhập địa chỉ Email';
              }
              return null;
            },
            decoration: Golbal.decoration,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
          ),
        );
        break;
      case "textarea":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          color: Colors.white,
          child: TextFormField(
            initialValue: input["IsGiatri"],
            minLines: 2,
            maxLines: 4,
            keyboardAppearance: Brightness.light,
            maxLength: input["IsLength"] ?? 2500,
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "float":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          color: Colors.white,
          child: TextFormField(
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
            ],
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "int":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          color: Colors.white,
          child: TextFormField(
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              NumericTextFormatter(),
            ],
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "checkbox":
        inputDataType = Obx(
          () => ListTile(
            onTap: () {
              input["IsGiatri"] = !(input["IsGiatri"] ?? false);
              controller.setValue(
                  "checkbox${input["FormD_ID"]}", input["IsGiatri"]);
            },
            title: Text(
              "${input["TenTruong"]}",
              style: Golbal.styleinput,
            ),
            leading: Checkbox(
                tristate: false,
                activeColor: const Color(0xFF6dd230),
                value:
                    controller.request["checkbox${input["FormD_ID"]}"] ?? false,
                onChanged: (val) {
                  controller.setValue("checkbox${input["FormD_ID"]}", val);
                }),
          ),
        );
        break;
      case "radio":
        inputDataType = Obx(
          () => RadioListTile<String>(
            selected: controller.request["radio"] == input["FormD_ID"],
            value: input["FormD_ID"],
            groupValue: controller.request["radio"] ?? "",
            title: Text(
              "${input["TenTruong"]}",
              style: Golbal.styleinput,
            ),
            onChanged: (val) {
              controller.setValue("radio", val);
            },
            activeColor: Golbal.appColor,
          ),
        );
        break;
      case "select":
        inputDataType = Container();
        break;
    }
    return inputDataType;
  }

  Widget typeWidgetView(context) {
    Widget inputDataType = Container();
    border ??= InputBorder.none;
    switch (input["KieuTruong"]) {
      case "datetime":
        input["IsGiatri"] ??= DateTime.now();
        inputDataType = DateTimePicker(
          readOnly: true,
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'dd/MM/yyyy',
          initialValue: controller.datetimeString(input["IsGiatri"]),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.event),
            filled: true,
            fillColor: Colors.white,
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "date":
        input["IsGiatri"] ??= DateTime.now();
        inputDataType = DateTimePicker(
          readOnly: true,
          type: DateTimePickerType.date,
          dateMask: 'dd/MM/yyyy',
          initialValue: controller.datetimeString(input["IsGiatri"]),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            labelText: '',
            hintStyle: TextStyle(
              color: Color(0xFFcccccc),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.event),
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "time":
        input["IsGiatri"] ??= TimeOfDay.now().format(context);
        inputDataType = DateTimePicker(
          readOnly: true,
          type: DateTimePickerType.time,
          initialValue: input["IsGiatri"],
          use24HourFormat: true,
          dateMask: 'HH:mm"',
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.access_time),
            filled: true,
            fillColor: Colors.white,
          ),
          style: Golbal.styleinput,
          onChanged: (val) {
            input["IsGiatri"] = val;
          },
          validator: (val) {
            if (input["IsRequired"] == true && val!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
          onSaved: (val) {
            input["IsGiatri"] = val;
          },
        );
        break;
      case "varchar":
        inputDataType = TextFormField(
          readOnly: true,
          initialValue: input["IsGiatri"],
          keyboardAppearance: Brightness.light,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 _]')),
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            labelText: '',
            hintStyle: TextStyle(
              color: Color(0xFFcccccc),
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
            ),
          ),
          style: Golbal.styleinput,
          onSaved: (String? str) {
            input["IsGiatri"] = str;
          },
          validator: (value) {
            if (input["IsRequired"] == true && value!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
        );
        break;
      case "nvarchar":
        inputDataType = TextFormField(
          readOnly: true,
          initialValue: input["IsGiatri"],
          keyboardAppearance: Brightness.light,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
            labelText: '',
            hintStyle: TextStyle(
              color: Color(0xFFcccccc),
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
            ),
          ),
          style: Golbal.styleinput,
          onSaved: (String? str) {
            input["IsGiatri"] = str;
          },
          validator: (value) {
            if (input["IsRequired"] == true && value!.isEmpty) {
              return "Vui lòng nhập ${input["TenTruong"]}";
            }
            return null;
          },
        );
        break;
      case "email":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            readOnly: true,
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              labelText: '',
              hintStyle: TextStyle(
                color: Color(0xFFcccccc),
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
              ),
            ),
            style: Golbal.styleinput,
            validator: (value) {
              if (!EmailValidator.validate(value!)) {
                return 'Vui lòng nhập địa chỉ Email';
              }
              return null;
            },
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
          ),
        );
        break;
      case "textarea":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            readOnly: true,
            initialValue: input["IsGiatri"],
            minLines: 2,
            maxLines: 4,
            keyboardAppearance: Brightness.light,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              labelText: '',
              hintStyle: TextStyle(
                color: Color(0xFFcccccc),
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
              ),
            ),
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "float":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            readOnly: true,
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              labelText: '',
              hintStyle: TextStyle(
                color: Color(0xFFcccccc),
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
              ),
            ),
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "int":
        inputDataType = Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            readOnly: true,
            initialValue: input["IsGiatri"],
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              NumericTextFormatter(),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0)),
              labelText: '',
              hintStyle: TextStyle(
                color: Color(0xFFcccccc),
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFcccccc), width: 1.0),
              ),
            ),
            style: Golbal.styleinput,
            onSaved: (String? str) {
              input["IsGiatri"] = str;
            },
            validator: (value) {
              if (input["IsRequired"] == true && value!.isEmpty) {
                return "Vui lòng nhập ${input["TenTruong"]}";
              }
              return null;
            },
          ),
        );
        break;
      case "checkbox":
        inputDataType = Obx(
          () => ListTile(
            title: Text(
              "${input["TenTruong"]}",
              style: Golbal.styleinput,
            ),
            leading: Checkbox(
                tristate: false,
                activeColor: const Color(0xFF6dd230),
                value:
                    controller.request["checkbox${input["FormD_ID"]}"] ?? false,
                onChanged: (val) {}),
          ),
        );
        break;
      case "radio":
        inputDataType = Obx(
          () => RadioListTile<String>(
            selected: controller.request["radio"] == input["FormD_ID"],
            value: input["FormD_ID"],
            groupValue: controller.request["radio"] ?? "",
            title: Text(
              "${input["TenTruong"]}",
              style: Golbal.styleinput,
            ),
            onChanged: (val) {},
            activeColor: Golbal.appColor,
          ),
        );
        break;
      case "select":
        inputDataType = Container();
        break;
    }
    return inputDataType;
  }

  @override
  Widget build(BuildContext context) {
    if (isview == true) {
      return typeWidgetView(context);
    } else {
      return typeWidget(context);
    }
  }
}
