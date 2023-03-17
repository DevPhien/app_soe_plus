import 'package:flutter/material.dart';

import 'Utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback? onDateSelected;
  final DateTime? date;
  final String? dayOfWeek;
  final bool? isDayOfWeek;
  final bool? isSelected;
  final bool? inMonth;
  final List<dynamic>? events;
  final TextStyle? dayOfWeekStyles;
  final TextStyle? dateStyles;
  final Widget? child;
  final Color? selectedColor;
  final Color? eventColor;
  final Color? eventDoneColor;

  const CalendarTile({
    Key? key,
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek = false,
    this.isSelected = false,
    this.inMonth = true,
    this.events,
    this.selectedColor,
    this.eventColor,
    this.eventDoneColor,
  }) : super(key: key);

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek == true) {
      return InkWell(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            dayOfWeek ?? "",
            style: dayOfWeekStyles,
          ),
        ),
      );
    } else {
      int eventCount = 0;
      return InkWell(
        onTap: onDateSelected,
        child: Container(
          decoration: isSelected == true
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor,
                )
              : const BoxDecoration(),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Utils.formatDay(date!).toString(),
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight:
                        isSelected == true ? FontWeight.bold : FontWeight.w400,
                    color: isSelected == true
                        ? Colors.white
                        : inMonth == true
                            ? Colors.black
                            : Colors.grey),
              ),
              events!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: events!.map((event) {
                        eventCount++;
                        if (eventCount > 3) return Container();
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 2.0, right: 2.0, top: 3.0),
                          width: 6.0,
                          height: 6.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: eventColor,
                          ),
                        );
                      }).toList())
                  : Container(),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDateSelected,
      child: child,
    );
  }
}
