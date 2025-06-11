import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime, DateTime) onDaySelected;
  
  // Remove these from constructor since we're managing them internally
  const CalendarWidget({
    Key? key,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: false,
      daysOfWeekHeight: 0.h,
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 49.h,
      firstDay: DateTime.utc(2024, 10, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected(selectedDay, focusedDay);
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, isSelected: true);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, isToday: true);
        },
        outsideBuilder: (context, day, focusedDay) {
          return _buildDayCell(day);
        },
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(day);
        },
      ),
    );
  }

  Widget _buildDayCell(DateTime day, {bool isSelected = false, bool isToday = false}) {
    // Check if this day is today
    final bool isActuallyToday = isSameDay(DateTime.now(), day);
    
    return Stack(
      children: [
        Container(
          width: 35.w,
          decoration: BoxDecoration(
            color: isSelected 
                ? blueShades[0]  // Selected day has blue background
                : (ThemeProvider().isDarkMode ? blueShades[15] : Colors.transparent),
            borderRadius: BorderRadius.circular(15.r),
            border: (!isSelected) 
                ? Border.all(color: blueShades[2])
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat.d().format(day),
                style: setTextTheme(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (ThemeProvider().isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              Text(
                DateFormat.E().format(day),
                style: setTextTheme(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : (ThemeProvider().isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
        
        // Show green dot for today's date regardless of selection state
        if (isActuallyToday)
          Positioned(
            bottom: 0.h,
            right: 0.w,
            child: Container(
              width: 10.w,
              height: 9.h,
              decoration: BoxDecoration(
                color: greenShades[0],
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: whiteShades[0], width: 1.w),
              ),
            ),
          ),
      ],
    );
  }


Widget _defaultCalendarCell(DateTime day) {
  return _calendarCell(
    day,
    // containerCol: blueShades[15],
    border: Border.all(
      color: blueShades[2],
    ),
  );
}

Widget _selectedCalendarCell(DateTime day) {
  bool isToday = isSameDay(DateTime.now(), day);
  return Stack(
    children: [
      _calendarCell(
        day,
        textColor: Colors.white,
        containerCol: blueShades[0],
      ),
      if (isToday)
        Positioned(
          bottom: 0.h,
          right: 0.w,
          child: Container(
            width: 10.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: greenShades[0],
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: whiteShades[0], width: 1.w),
            ),
          ),
        ),
    ],
  );
}

Widget _todayCalendarCell(
  DateTime day,
) {
  bool isSelected = isSameDay(_selectedDay, day);
  bool anotherDaySelected =
      _selectedDay != null && !isSameDay(_selectedDay, day);
  return Stack(
    children: [
      _calendarCell(
        day,
        textColor: anotherDaySelected
            ? ThemeProvider().isDarkMode
                ? Colors.white
                : Colors.black
            : Colors.white,
        containerCol: isSelected
            ? redShades[1]
            : (anotherDaySelected ? null : blueShades[0]),
        border: isSelected
            ? null
            : (anotherDaySelected ? Border.all(color: blueShades[2]) : null),
      ),
      Positioned(
        bottom: 0.h,
        right: 0.w,
        child: Container(
          width: 10.w,
          height: 9.h,
          decoration: BoxDecoration(
            color: greenShades[0],
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: whiteShades[0], width: 1.w),
          ),
        ),
      ),
    ],
  );
}

Widget _calendarCell(
  DateTime day, {
  Color? textColor,
  Color? containerCol,
  BoxBorder? border,
}) {
  return _calendarCellBuild(
    DateFormat.d().format(day),
    DateFormat.E().format(day),
    textCol: textColor,
    containerColor: containerCol,
    border: border,
  );
}

Widget _calendarCellBuild(
  String date,
  String day, {
  Color? textCol,
  BoxBorder? border,
  Color? containerColor,
}) {
  return Container(
    width: 35.w,
    decoration: BoxDecoration(
      color: containerColor ??
          (ThemeProvider().isDarkMode ? blueShades[15] : Colors.transparent),
      borderRadius: BorderRadius.circular(15.r),
      border: border,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          date,
          style: setTextTheme(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textCol ??
                (ThemeProvider().isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        Text(
          day,
          style: setTextTheme(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: textCol ??
                (ThemeProvider().isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    ),
  );
}
}