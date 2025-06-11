import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/courses_mockdata.dart';
import 'package:cloudnottapp2/src/screens/student/courses/courses_tab.dart';
import 'package:cloudnottapp2/src/screens/student/courses/widgets/course_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/course_items_model.dart';

class BrowseCoursesScreen extends StatelessWidget {
  static const String routeName = '/browse-courses';

  const BrowseCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sort courses by ongoing -> pending -> completed
    final sortedCourses = List<CourseItemsModel>.from(mockCourses)
      ..sort((a, b) {
        final statusOrder = {
          'on-going': 0,
          'pending': 1,
          'completed': 2,
        };
        return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
      });

    return Scaffold(
      appBar: AppBar(
        leading: customAppBarLeadingIcon(context),
        centerTitle: false,
        title: Text(
          'My Courses',
          style: setTextTheme(fontSize: 20.sp),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15.r),
        itemCount: sortedCourses.length,
        itemBuilder: (context, index) {
          return CourseItemWidget(course: sortedCourses[index]);
        },
      ),
    );
  }
}
