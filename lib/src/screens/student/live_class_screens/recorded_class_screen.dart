import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/recorded_class_mock_data.dart';
import 'package:cloudnottapp2/src/data/models/recorded_class_model.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/widgets/recorded_classes_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecordedClass extends StatefulWidget {
  const RecordedClass({super.key});
  static const String routeName = "/recorded_class";

  @override
  State<RecordedClass> createState() => _RecordedClassState();
}



class _RecordedClassState extends State<RecordedClass> {
  final List<String> subjects = ['All'];
  String? selectedSubject;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedSubject = subjects.first;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final formattedMonth = DateFormat('MMMM yyyy').format(selectedDate);

    final recordings = userProvider.filteredTimeTable.isNotEmpty
        ? userProvider.filteredTimeTable.first.classRecordings ?? []
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recorded Class',
          style: setTextTheme(fontSize: 24.sp),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with month and calendar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedMonth,
                  style: setTextTheme(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: SvgPicture.asset(
                    'assets/icons/calendar_icon.svg',
                    colorFilter: ColorFilter.mode(
                      isDarkMode ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Subject dropdown
            Row(
              children: [
                Text(
                  'Subject: ',
                  style: setTextTheme(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedSubject,
                  style: setTextTheme(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  underline: const SizedBox.shrink(),
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  items: subjects.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (subject) {
                    setState(() {
                      selectedSubject = subject;
                      // You can filter recordings here based on selectedSubject
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // List of recordings
            Expanded(
              child: recordings.isEmpty
                  ? Center(
                      child: Text(
                        'No recorded classes available.',
                        style: setTextTheme(fontSize: 16.sp),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        return RecordedClassesWidget(
                          recordedClassModelTwo: recordings[index],
                          recordedClassModel: recordedMockdata[index % recordedMockdata.length], // fallback for preview
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
// class _RecordedClassState extends State<RecordedClass> {
//   final List<String> subjects = ['All '];
//   String? selectedSubject;

//   @override
//   void initState() {
//     super.initState();
//     selectedSubject = subjects[0];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userpro = context.watch<UserProvider>();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Recorded class',
//           style: setTextTheme(
//             fontSize: 24.sp,
//           ),
//         ),
//         // leading: customAppBarLeadingIcon(context),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15.r),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'November 2024',
//                   style: setTextTheme(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SvgPicture.asset(
//                   'assets/icons/calendar_icon.svg',
//                   colorFilter: ColorFilter.mode(
//                     ThemeProvider().isDarkMode ? Colors.white : Colors.black,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ],
//             ),
//             // SizedBox(height: 10.h),
//             Row(
//               children: [
//                 Text(
//                   'Subject: ',
//                   style: setTextTheme(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 DropdownButton(
//                   value: selectedSubject,
//                   style: setTextTheme(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   underline: const SizedBox.shrink(),
//                   icon: Icon(
//                     CupertinoIcons.chevron_down,
//                     color: ThemeProvider().isDarkMode
//                         ? Colors.white
//                         : Colors.black,
//                   ),
//                   items: subjects.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? subjectSelected) {
//                     setState(
//                       () {
//                         selectedSubject = subjectSelected;
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.h),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userpro.filteredTimeTable.first.classRecordings?.length ??0,
//                 // itemCount: recordedMockdata.length,
//                 itemBuilder: (context, index) {
//                   return RecordedClassesWidget(
//                     recordedClassModelTwo:userpro.filteredTimeTable.first.classRecordings?[index] ??
//       ClassRecording(id: '', lessonNoteId: 'Unknown', recordUrl: ''),
//                      recordedClassModel: recordedMockdata[index],
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
