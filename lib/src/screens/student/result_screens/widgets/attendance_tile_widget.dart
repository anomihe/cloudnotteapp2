import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show BroadsheetResult;
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceTileWidget extends StatefulWidget {
  final String studentName;
  final int totalSchoolDays;
  final BroadsheetResult result;
  final Function(Map<String, dynamic>) onAttendanceUpdated;
  const AttendanceTileWidget(BuildContext context, this.studentName,
      {super.key,
      required this.totalSchoolDays,
      required this.result,
      required this.onAttendanceUpdated});

  @override
  State<AttendanceTileWidget> createState() => _AttendanceTileWidgetState();
}

class _AttendanceTileWidgetState extends State<AttendanceTileWidget> {
  late final TextEditingController _daysController;
  int daysAbsent = 0;

  @override
  void initState() {
    super.initState();
    _daysController =
        TextEditingController(text: widget.result.metadata?['attendance']);
    int daysPresentFromMetadata =
        int.tryParse(widget.result.metadata?['attendance'] ?? '0') ?? 0;
    daysAbsent = widget.totalSchoolDays - daysPresentFromMetadata;
    _daysController.addListener(_calculateDaysAbsent);
  }
  //   void _onAttendanceChanged() {
  //   widget.onAttendanceUpdated(getUpdatedAttendance());
  // }

  void _calculateDaysAbsent() {
    if (_daysController.text.isNotEmpty) {
      int daysPresent = int.tryParse(_daysController.text) ?? 0;

      // Ensure days present doesn't exceed total school days
      if (daysPresent > widget.totalSchoolDays) {
        daysPresent = widget.totalSchoolDays;
        _daysController.text = widget.totalSchoolDays.toString();
        // Move cursor to end
        _daysController.selection = TextSelection.fromPosition(
          TextPosition(offset: _daysController.text.length),
        );
      }
      int daysPresentFromMetadata =
          int.tryParse(widget.result.metadata?['attendance'] ?? '0') ?? 0;
      setState(() {
        daysAbsent = widget.totalSchoolDays - daysPresentFromMetadata;
      });
    } else {
      setState(() {
        daysAbsent = widget.totalSchoolDays;
      });
    }
    widget.onAttendanceUpdated(getUpdatedAttendance());
  }

  Map<String, dynamic> getUpdatedAttendance() {
    return {
      "resultId": widget.result.resultId,
      "metadata": {"attendance": _daysController.text}
    };
  }

  @override
  void dispose() {
    _daysController.removeListener(_calculateDaysAbsent);
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 15.r,
                vertical: 5.h,
              ),
              initiallyExpanded: true,
              title: Row(
                children: [
                  Container(
                    width: 45.r,
                    height: 45.r,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: blueShades[0]),
                    child: Center(
                      child: Text(
                        widget.studentName.isNotEmpty
                            ? widget.studentName.toUpperCase()[0]
                            : '?',
                        style: setTextTheme(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.studentName,
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Days absent: ',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[3],
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                  text: daysAbsent.toStringAsFixed(0),
                                  style: setTextTheme(
                                    fontSize: 12.sp,
                                    color: whiteShades[3],
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                      ),
                    ],
                  )
                ],
              ),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.r,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[15]
                        : blueShades[18],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Days present',
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: 60,
                        height: 30,
                        child: TextField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ThemeProvider().isDarkMode
                                ? blueShades[15]
                                : whiteShades[0],
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: ThemeProvider().isDarkMode
                                    ? blueShades[3]
                                    : whiteShades[3],
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: ThemeProvider().isDarkMode
                                    ? blueShades[0]
                                    : blueShades[1],
                                width: 1,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: ThemeProvider().isDarkMode
                                    ? blueShades[3]
                                    : whiteShades[3],
                                width: 0.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                color: ThemeProvider().isDarkMode
                                    ? blueShades[3]
                                    : whiteShades[3],
                                width: 0.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              int daysPresent = int.tryParse(value) ?? 0;
                              if (daysPresent > widget.totalSchoolDays) {
                                _daysController.text =
                                    widget.totalSchoolDays.toString();
                                _daysController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _daysController.text.length),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
