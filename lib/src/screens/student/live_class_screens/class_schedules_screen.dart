import 'dart:developer';

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';

import 'package:cloudnottapp2/src/screens/student/live_class_screens/widgets/calendar_widget.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/widgets/schedules_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user_model.dart';

class ClassSchedules extends StatefulWidget {
  static const routeName = '/class_schedules';
  final String id;

  const ClassSchedules({
    super.key,
    required this.id,
  });

  @override
  State<ClassSchedules> createState() => _ClassSchedulesState();
}

class _ClassSchedulesState extends State<ClassSchedules> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'TimeTable',
          style: setTextTheme(
            fontSize: 24.sp,
          ),
        ),
        centerTitle: false,
        // leading: customAppBarLeadingIcon(context),
      ),
      body: Consumer<UserProvider>(builder: (context, value, _) {
        if (value.isLoading && value.isLoadingStateTwo) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        log("TIMETABLE: ${value.timeTable}");
        return ScheduleScreen(
          classTimeTableData: value.timeTable,
        );
      }),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  final List<ClassTimeTable> classTimeTableData;

  const ScheduleScreen({super.key, required this.classTimeTableData});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// class _ScheduleScreenState extends State<ScheduleScreen> {
//   int selectedDayIndex = 0;
//   int subjectCount = 0;
//   int activityCount = 0;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   List<ClassTimeTable> filteredData = [];
//   List<String> classNames = [];
//   String selectedClassName = "";
//   List<ClassModel> classes = [];
//   ClassModel? selectedClass;
//   List<ClassGroup> classGroups = [];
//   List<String> classGroupNames = [];
//   ClassGroup? selectedClassGroup;
//   String? selectedClassGroupName;
//   List<String> dropdownItems = [];
//   Map<String, ClassModel> classModelMap = {};
//   List<String> roles = ["school_owner", "admin"];
//   bool isUpperUser = false;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;

//     final userRole =
//         context.read<UserProvider>().singleSpace?.role?.toLowerCase();
//     isUpperUser = roles.any((role) => role.toLowerCase() == userRole);

//     if (isUpperUser) {
//       classGroups = context.read<LessonNotesProvider>().group;
//       classGroupNames = classGroups.map((g) => g.name).toList();

//       dropdownItems = [];
//       classModelMap = {};
//       for (var classGroup in classGroups) {
//         for (var cls in classGroup.classes) {
//           String formattedName = "${classGroup.name} - ${cls.name}";
//           dropdownItems.add(formattedName);
//           classModelMap[formattedName] = cls;
//         }
//       }

//       if (dropdownItems.isNotEmpty) {
//         selectedClassName = dropdownItems.first;
//         selectedClass = classModelMap[selectedClassName];

//         _loadTimeTableData();
//       }
//     } else {
//       _loadTimeTableData();
//     }
//   }

//   void _loadTimeTableData() {
//     final userProvider = context.read<UserProvider>();
//     final spaceId = userProvider.spaceId ?? "";
//     final role = userProvider.singleSpace?.role?.toLowerCase();

//     if (isUpperUser && selectedClass != null) {
//       // Admin/school_owner: load selected class timetable
//       userProvider
//           .getUserTime(
//         context: context,
//         spaceId: spaceId,
//         classId: selectedClass!.id,
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     } else if (role == 'teacher') {
//       // Teacher: load their own timetable
//       userProvider
//           .getTeacherTimetable(
//         context: context,
//         spaceId: spaceId,
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     } else {
//       // Other users: load their class timetable
//       userProvider
//           .getUserTime(
//         context: context,
//         spaceId: spaceId,
//         classId: userProvider.singleSpace?.classInfo?.id ?? '',
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     }

//     // Trigger initial filtering
//     Future.delayed(Duration.zero, () {
//       if (selectedClass != null) {
//         context.read<UserProvider>().getUserTime(
//               context: context,
//               spaceId: context.read<UserProvider>().spaceId ?? "",
//               classId: selectedClass?.id ?? "",
//             );
//         context.read<UserProvider>().filterClassTimeTable(_selectedDay);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredTimeTable = context.watch<UserProvider>().filteredTimeTable;
//     Duration totalDuration = TimeCalculator.calculateTotalDuration(
//         filteredTimeTable.map((e) => e.timeSlot?.time ?? '').toList());
//     String formattedDuration = TimeCalculator.formatDuration(totalDuration);

//     return Consumer<UserProvider>(builder: (context, userProvider, _) {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10.r),
//             child: Row(
//               children: [

//                 if (isUpperUser)
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedClassName.isNotEmpty &&
//                                 dropdownItems.contains(selectedClassName)
//                             ? selectedClassName
//                             : dropdownItems.isNotEmpty
//                                 ? dropdownItems.first
//                                 : null,
//                         isExpanded: true,
//                         isDense: true,
//                         hint: Text('Select Class'),
//                         items: dropdownItems.map((String item) {
//                           return DropdownMenuItem<String>(
//                             value: item,
//                             child: Text(
//                               item, // e.g., "JSS 1 - JSS 1"
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               softWrap: true,
//                               style: setTextTheme(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w700,
//                                 // color: Colors.black,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (String? newItem) async {
//                           if (newItem != null) {
//                             setState(() {
//                               selectedClassName = newItem;
//                               selectedClass = classModelMap[newItem];
//                             });

//                             // Fetch timetable for the selected class
//                             await context.read<UserProvider>().getUserTime(
//                                   context: context,
//                                   spaceId:
//                                       context.read<UserProvider>().spaceId ??
//                                           "",
//                                   classId: selectedClass?.id ?? "",
//                                 );
//                             context
//                                 .read<UserProvider>()
//                                 .filterClassTimeTable(_selectedDay);
//                           }
//                         },
//                       ),
//                     ),
//                   )

//                 else
//                   Text('Schedule',
//                       style: setTextTheme(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w400,
//                       )),
//                 const Spacer(),
//                 Text(
//                   '${DateFormat.MMMM().format(_selectedDay ?? _focusedDay)} < >  |',
//                   style: setTextTheme(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5.h,
//                 ),
//                 SvgPicture.asset(
//                   'assets/icons/material-symbols-light_live-tv-outline-rounded.svg',
//                   colorFilter: ColorFilter.mode(blueShades[0], BlendMode.srcIn),
//                 ),
//               ],
//             ),
//           ),
//           CalendarWidget(
//             // onDaySelected : _filterData,
//             onDaySelected: (DateTime selectedDay, DateTime focused) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 focused = _selectedDay ?? DateTime.now();
//               });
//               // _filterData(); // Call the filter function after updating the selected day
//               userProvider.filterClassTimeTable(selectedDay);
//               // setState(() {});
//             },
//             // focusedDay: _selectedDay ?? _focusedDay,
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           Container(
//             height: 84.h,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 18.h),
//             decoration: BoxDecoration(
//                 color: blueShades[0],
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.r),
//                     topRight: Radius.circular(30.r))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildSummaryColumn('Lessons', '${userProvider.subjectCount}'),
//                 _divider(),
//                 _buildSummaryColumn(
//                     'Activities', '${userProvider.activityCount}'),
//                 _divider(),
//                 _buildSummaryColumn('Time', formattedDuration),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           userProvider.isTimeTableLoading
//               ? Column(
//                   children: [
//                     Center(
//                       child: LinearProgressIndicator(),
//                     ),
//                   ],
//                 )
//               : Expanded(
//                   child: ListView.builder(
//                     key: ValueKey(_selectedDay),
//                     itemCount: userProvider.filteredTimeTable.length,
//                     itemBuilder: (context, index) {
//                       final item = userProvider.filteredTimeTable[index];

//                       if (userProvider.filteredTimeTable.isEmpty) {
//                         return Center(
//                           child: Text(
//                             'No Classes today',
//                             style: setTextTheme(
//                                 fontSize: 24.sp, color: Colors.black),
//                           ),
//                         );
//                       }
//                       return SchedulesWidget(
//                         index: index,
//                         classSchedulesModel: item,
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       );
//     });
//   }
// class _ScheduleScreenState extends State<ScheduleScreen> with AutomaticKeepAliveClientMixin {
//   int selectedDayIndex = 0;
//   int subjectCount = 0;
//   int activityCount = 0;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   List<ClassTimeTable> filteredData = [];
//   List<String> classNames = [];
//   String selectedClassName = "";
//   List<ClassModel> classes = [];
//   ClassModel? selectedClass;
//   List<ClassGroup> classGroups = [];
//   List<String> classGroupNames = [];
//   ClassGroup? selectedClassGroup;
//   String? selectedClassGroupName;
//   List<String> dropdownItems = [];
//   Map<String, ClassModel> classModelMap = {};
//   List<String> roles = ["school_owner", "admin"];
//   bool isUpperUser = false;
//   bool _isInitialized = false;

//   // Override this getter to keep the state alive
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _initializeData();
//   }

//   void _initializeData() {
//     if (_isInitialized) return;

//     final userRole =
//         context.read<UserProvider>().singleSpace?.role?.toLowerCase();
//     isUpperUser = roles.any((role) => role.toLowerCase() == userRole);

//     if (isUpperUser) {
//       classGroups = context.read<LessonNotesProvider>().group;
//       classGroupNames = classGroups.map((g) => g.name).toList();

//       dropdownItems = [];
//       classModelMap = {};
//       for (var classGroup in classGroups) {
//         for (var cls in classGroup.classes) {
//           String formattedName = "${classGroup.name} - ${cls.name}";
//           dropdownItems.add(formattedName);
//           classModelMap[formattedName] = cls;
//         }
//       }

//       if (dropdownItems.isNotEmpty) {
//         selectedClassName = dropdownItems.first;
//         selectedClass = classModelMap[selectedClassName];

//         _loadTimeTableData();
//       }
//     } else {
//       _loadTimeTableData();
//     }

//     _isInitialized = true;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // This ensures we have the latest data whenever dependencies change
//     if (!_isInitialized) {
//       _initializeData();
//     }
//   }

//   void _loadTimeTableData() {
//     final userProvider = context.read<UserProvider>();
//     final spaceId = userProvider.spaceId ?? "";
//     final role = userProvider.singleSpace?.role?.toLowerCase();

//     if (isUpperUser && selectedClass != null) {
//       // Admin/school_owner: load selected class timetable
//       userProvider
//           .getUserTime(
//         context: context,
//         spaceId: spaceId,
//         classId: selectedClass!.id,
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     } else if (role == 'teacher') {
//       // Teacher: load their own timetable
//       userProvider
//           .getTeacherTimetable(
//         context: context,
//         spaceId: spaceId,
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     } else {
//       // Other users: load their class timetable
//       userProvider
//           .getUserTime(
//         context: context,
//         spaceId: spaceId,
//         classId: userProvider.singleSpace?.classInfo?.id ?? '',
//       )
//           .then((_) {
//         userProvider.filterClassTimeTable(_selectedDay);
//         setState(() {});
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // Required for AutomaticKeepAliveClientMixin

//     // Make sure data is initialized when the widget builds
//     if (!_isInitialized) {
//       _initializeData();
//     }

//     final filteredTimeTable = context.watch<UserProvider>().filteredTimeTable;
//     Duration totalDuration = TimeCalculator.calculateTotalDuration(
//         filteredTimeTable.map((e) => e.timeSlot?.time ?? '').toList());
//     String formattedDuration = TimeCalculator.formatDuration(totalDuration);

//     return Consumer<UserProvider>(builder: (context, userProvider, _) {
//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10.r),
//             child: Row(
//               children: [

//                 if (isUpperUser)
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedClassName.isNotEmpty &&
//                                 dropdownItems.contains(selectedClassName)
//                             ? selectedClassName
//                             : dropdownItems.isNotEmpty
//                                 ? dropdownItems.first
//                                 : null,
//                         isExpanded: true,
//                         isDense: true,
//                         hint: Text('Select Class'),
//                         items: dropdownItems.map((String item) {
//                           return DropdownMenuItem<String>(
//                             value: item,
//                             child: Text(
//                               item, // e.g., "JSS 1 - JSS 1"
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               softWrap: true,
//                               style: setTextTheme(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w700,
//                                 // color: Colors.black,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (String? newItem) async {
//                           if (newItem != null) {
//                             setState(() {
//                               selectedClassName = newItem;
//                               selectedClass = classModelMap[newItem];
//                             });

//                             // Fetch timetable for the selected class
//                             await context.read<UserProvider>().getUserTime(
//                                   context: context,
//                                   spaceId:
//                                       context.read<UserProvider>().spaceId ??
//                                           "",
//                                   classId: selectedClass?.id ?? "",
//                                 );
//                             context
//                                 .read<UserProvider>()
//                                 .filterClassTimeTable(_selectedDay);
//                           }
//                         },
//                       ),
//                     ),
//                   )

//                 else
//                   Text('Schedule',
//                       style: setTextTheme(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w400,
//                       )),
//                 const Spacer(),
//                 Text(
//                   '${DateFormat.MMMM().format(_selectedDay ?? _focusedDay)} < >  |',
//                   style: setTextTheme(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5.h,
//                 ),
//                 SvgPicture.asset(
//                   'assets/icons/material-symbols-light_live-tv-outline-rounded.svg',
//                   colorFilter: ColorFilter.mode(blueShades[0], BlendMode.srcIn),
//                 ),
//               ],
//             ),
//           ),
//           CalendarWidget(
//             // onDaySelected : _filterData,
//             onDaySelected: (DateTime selectedDay, DateTime focused) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 focused = _selectedDay ?? DateTime.now();
//               });
//               // _filterData(); // Call the filter function after updating the selected day
//               userProvider.filterClassTimeTable(selectedDay);
//               // setState(() {});
//             },
//             // focusedDay: _selectedDay ?? _focusedDay,
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           Container(
//             height: 84.h,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 18.h),
//             decoration: BoxDecoration(
//                 color: blueShades[0],
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.r),
//                     topRight: Radius.circular(30.r))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildSummaryColumn('Lessons', '${userProvider.subjectCount}'),
//                 _divider(),
//                 _buildSummaryColumn(
//                     'Activities', '${userProvider.activityCount}'),
//                 _divider(),
//                 _buildSummaryColumn('Time', formattedDuration),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           userProvider.isTimeTableLoading
//               ? Column(
//                   children: [
//                     Center(
//                       child: LinearProgressIndicator(),
//                     ),
//                   ],
//                 )
//               : Expanded(
//                   child: ListView.builder(
//                     key: ValueKey(_selectedDay),
//                     itemCount: userProvider.filteredTimeTable.length,
//                     itemBuilder: (context, index) {
//                       final item = userProvider.filteredTimeTable[index];

//                       if (userProvider.filteredTimeTable.isEmpty) {
//                         return Center(
//                           child: Text(
//                             'No Classes today',
//                             style: setTextTheme(
//                                 fontSize: 24.sp, color: Colors.black),
//                           ),
//                         );
//                       }
//                       return SchedulesWidget(
//                         index: index,
//                         classSchedulesModel: item,
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       );
//     });
//   }

//   Column _buildSummaryColumn(String label, String value) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: setTextTheme(
//             fontSize: 16.sp,
//             color: Colors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         Text(
//           value,
//           style: setTextTheme(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 20.sp,
//           ),
//         ),
//       ],
//     );
//   }

//   Container _divider() {
//     return Container(
//       height: 42,
//       width: 1,
//       color: Colors.white,
//       // color: Colors.blue[300],
//     );
//   }
// }
class _ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  int selectedDayIndex = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<ClassTimeTable> filteredData = [];
  List<String> classNames = [];
  String selectedClassName = "";
  List<ClassModel> classes = [];
  ClassModel? selectedClass;
  List<ClassGroup> classGroups = [];
  List<String> classGroupNames = [];
  ClassGroup? selectedClassGroup;
  String? selectedClassGroupName;
  List<String> dropdownItems = [];
  Map<String, ClassModel> classModelMap = {};
  List<String> roles = ["school_owner", "admin"];
  bool isUpperUser = false;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initializeData();
  }

  void _initializeData() {
    if (_isInitialized) return;

    final userRole =
        context.read<UserProvider>().singleSpace?.role?.toLowerCase();
    isUpperUser = roles.any((role) => role == userRole);

    if (isUpperUser) {
      classGroups = context.read<LessonNotesProvider>().group;
      classGroupNames = classGroups.map((g) => g.name).toList();

      dropdownItems = [];
      classModelMap = {};
      for (var classGroup in classGroups) {
        for (var cls in classGroup.classes) {
          String formattedName = "${classGroup.name} - ${cls.name}";
          dropdownItems.add(formattedName);
          classModelMap[formattedName] = cls;
        }
      }

      if (dropdownItems.isNotEmpty) {
        selectedClassName = dropdownItems.first;
        selectedClass = classModelMap[selectedClassName];
        _loadTimeTableData();
      }
    } else {
      _loadTimeTableData();
    }

    _isInitialized = true;
  }
void _loadTimeTableData() async {
  final userProvider = context.read<UserProvider>();
  final spaceId = userProvider.spaceId ?? "";
  final role = userProvider.singleSpace?.role?.toLowerCase();

  try {
    if (isUpperUser && selectedClass != null) {
      await userProvider.getUserTime(
        context: context,
        spaceId: spaceId,
        classId: selectedClass!.id,
      );
    } else if (role == 'teacher') {
      await userProvider.getTeacherTimetable(
        context: context,
        spaceId: spaceId,
      );
    } else {
      await userProvider.getUserTime(
        context: context,
        spaceId: spaceId,
        classId: userProvider.singleSpace?.classInfo?.id ?? '',
      );
    }
    
    // Filter after loading completes
    userProvider.filterClassTimeTable(_selectedDay ?? DateTime.now());
    
    // Ensure UI updates
    if (mounted) {
      setState(() {});
    }
  } catch (e) {
    debugPrint('Error loading timetable data: $e');
    if (mounted) {
      setState(() {});
    }
  }
}
  // void _loadTimeTableData() {
  //   final userProvider = context.read<UserProvider>();
  //   final spaceId = userProvider.spaceId ?? "";
  //   final role = userProvider.singleSpace?.role?.toLowerCase();

  //   if (isUpperUser && selectedClass != null) {
  //     userProvider
  //         .getUserTime(
  //       context: context,
  //       spaceId: spaceId,
  //       classId: selectedClass!.id,
  //     )
  //         .then((_) {
  //       userProvider.filterClassTimeTable(_selectedDay ?? DateTime.now());
  //       setState(() {});
  //     });
  //   } else if (role == 'teacher') {
  //     userProvider
  //         .getTeacherTimetable(
  //       context: context,
  //       spaceId: spaceId,
  //     )
  //         .then((_) {
  //       userProvider.filterClassTimeTable(_selectedDay ?? DateTime.now());
  //       setState(() {});
  //     });
  //   } else {
  //     userProvider
  //         .getUserTime(
  //       context: context,
  //       spaceId: spaceId,
  //       classId: userProvider.singleSpace?.classInfo?.id ?? '',
  //     )
  //         .then((_) {
  //       userProvider.filterClassTimeTable(_selectedDay ?? DateTime.now());
  //       setState(() {});
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userProvider = context.watch<UserProvider>();
    final filteredTimeTable = userProvider.filteredTimeTable;

    Duration totalDuration = TimeCalculator.calculateTotalDuration(
      filteredTimeTable.map((e) => e.timeSlot?.time ?? '').toList(),
    );
    String formattedDuration = TimeCalculator.formatDuration(totalDuration);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            children: [
              if (isUpperUser)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedClassName.isNotEmpty &&
                              dropdownItems.contains(selectedClassName)
                          ? selectedClassName
                          : (dropdownItems.isNotEmpty
                              ? dropdownItems.first
                              : null),
                      isExpanded: true,
                      isDense: true,
                      hint: Text('Select Class'),
                      items: dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newItem) async {
  if (newItem != null) {
    // Set loading state immediately
    setState(() {
      selectedClassName = newItem;
      selectedClass = classModelMap[newItem];
    });

    try {
      // Show loading state
      final userProvider = context.read<UserProvider>();
      
      await userProvider.getUserTime(
        context: context,
        spaceId: userProvider.spaceId ?? "",
        classId: selectedClass?.id ?? "",
      );
      
      // Filter the timetable
      userProvider.filterClassTimeTable(_selectedDay ?? DateTime.now());
      
      // Force UI update after async operations complete
      if (mounted) {
        setState(() {
          // This setState ensures the UI rebuilds after async operations
        });
      }
    } catch (e) {
      debugPrint('Error loading timetable: $e');
      // Handle error state if needed
      if (mounted) {
        setState(() {
          // Reset or handle error state
        });
      }
    }
  }
},
                      // onChanged: (String? newItem) async {
                      //   if (newItem != null) {
                      //     setState(() {
                      //       selectedClassName = newItem;
                      //       selectedClass = classModelMap[newItem];
                      //     });

                      //     await context.read<UserProvider>().getUserTime(
                      //           context: context,
                      //           spaceId:
                      //               context.read<UserProvider>().spaceId ?? "",
                      //           classId: selectedClass?.id ?? "",
                      //         );
                      //     context.read<UserProvider>().filterClassTimeTable(
                      //         _selectedDay ?? DateTime.now());
                      //   }
                      // },
                    ),
                  ),
                )
              else
                Text(
                  'Schedule',
                  style: setTextTheme(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              const Spacer(),
              Text(
                '${DateFormat.MMMM().format(_selectedDay ?? _focusedDay)} < >  |',
                style: setTextTheme(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 5.h),
              SvgPicture.asset(
                'assets/icons/material-symbols-light_live-tv-outline-rounded.svg',
                colorFilter: ColorFilter.mode(blueShades[0], BlendMode.srcIn),
              ),
            ],
          ),
        ),
        CalendarWidget(
          // selectedDay: _selectedDay ?? _focusedDay,
          // focusedDay: _focusedDay,
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            userProvider.filterClassTimeTable(selectedDay);
          },
        ),
        SizedBox(height: 15.h),
        Container(
          height: 84.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: blueShades[0],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryColumn('Lessons', '${userProvider.subjectCount}'),
              _divider(),
              _buildSummaryColumn(
                  'Activities', '${userProvider.activityCount}'),
              _divider(),
              _buildSummaryColumn('Time', formattedDuration),
            ],
          ),
        ),
        const SizedBox(height: 10),
        userProvider.isTimeTableLoading
            ? Center(child: LinearProgressIndicator())
            : filteredTimeTable.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No Classes today',
                        style:
                            setTextTheme(fontSize: 24.sp, color: Colors.black),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      key: ValueKey(_selectedDay),
                      itemCount: filteredTimeTable.length,
                      itemBuilder: (context, index) {
                        final item = filteredTimeTable[index];
                        return SchedulesWidget(
                          index: index,
                          classSchedulesModel: item,
                        );
                      },
                    ),
                  ),
      ],
    );
  }

  Column _buildSummaryColumn(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: setTextTheme(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: setTextTheme(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }

  Container _divider() {
    return Container(
      height: 42,
      width: 1,
      color: Colors.white,
    );
  }
}

class TimeCalculator {
  static Duration duration = Duration();
  static Duration calculateTotalDuration(List<String> timeSlots) {
    int totalMinutes = 0;

    for (var slot in timeSlots) {
      List<String> startEnd = slot.split('-');

      if (startEnd.length == 2) {
        String start = startEnd[0].trim();
        String end = startEnd[1].trim();

        DateTime? startDateTime = _convertToDateTime(start);
        DateTime? endDateTime = _convertToDateTime(end);

        if (startDateTime != null && endDateTime != null) {
          Duration difference = endDateTime.difference(startDateTime);
          duration = difference;
          log("total time $difference");
          totalMinutes += difference.inMinutes;
        }
      }
    }
    log("total time $totalMinutes ");
    return Duration(minutes: totalMinutes);
  }

  static Duration calculateTimeDifference(String startTime, String endTime) {
    try {
      // Clean the time strings
      String cleanStartTime = startTime.replaceAll(RegExp(r'\s+'), '').trim();
      String cleanEndTime = endTime.replaceAll(RegExp(r'\s+'), '').trim();

      debugPrint(
          "🕐 Processing time pair: '$cleanStartTime' to '$cleanEndTime'");

      // Parse the times
      final format = DateFormat("HH:mm");
      final now = DateTime.now();

      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        format.parseStrict(cleanStartTime).hour,
        format.parseStrict(cleanStartTime).minute,
      );

      final endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        format.parseStrict(cleanEndTime).hour,
        format.parseStrict(cleanEndTime).minute,
      );

      Duration difference = endDateTime.difference(startDateTime);
      debugPrint("✅ Calculated duration: $difference");
      return difference;
    } catch (e) {
      debugPrint("❌ Error calculating duration: $e");
      return Duration.zero;
    }
  }

  static DateTime? _convertToDateTimee(String timeString) {
    try {
      final now = DateTime.now();
      final format = DateFormat("HH:mm");

      // Clean spaces in time string
      String cleanedTimeString = timeString.trim();

      // Debugging before parsing
      debugPrint("🕒 Attempting to parse: '$cleanedTimeString'");

      final parsedTime = format.parseStrict(cleanedTimeString);

      DateTime dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      debugPrint("✅ Parsed time: '$timeString' -> $dateTime");
      return dateTime;
    } catch (e) {
      debugPrint("❌ Error parsing time: '$timeString' - Error: $e");
      return null;
    }
  }

  static DateTime? _convertToDateTime(String timeString) {
    try {
      final now = DateTime.now();
      final format = DateFormat("HH:mm");
      final parsedTime = format.parse(timeString);

      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      debugPrint('Error parsing time: $timeString - Error: $e');
      return null;
    }
  }

  static String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }
}
