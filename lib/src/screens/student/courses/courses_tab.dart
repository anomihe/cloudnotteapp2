import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/courses_mockdata.dart';
import 'package:cloudnottapp2/src/data/models/course_items_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/courses/browse_course_screen.dart';
import 'package:cloudnottapp2/src/screens/student/courses/widgets/circular_progress_with_label.dart';
import 'package:cloudnottapp2/src/screens/student/courses/widgets/course_items_widget.dart';
import 'package:cloudnottapp2/src/screens/student/courses/widgets/recommended_course_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasOngoingCourses = mockCourses.isNotEmpty;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            if (hasOngoingCourses) ...[
              Container(
                // ongoing container widget
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : blueShades[17],
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: ThemeProvider().isDarkMode
                        ? Colors.transparent
                        : blueShades[18],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        image: DecorationImage(
                          image: AssetImage('assets/app/mock.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                              color: blueShades[18],
                              borderRadius: BorderRadius.circular(100.r)),
                          child: Text(
                            'on-going',
                            style: setTextTheme(
                                fontSize: 7.sp, color: blueShades[0]),
                          ),
                        ),
                        Text('Algebra Equation for Jss 2',
                            style: setTextTheme(fontSize: 14.sp)),
                        Text(
                          'by Nmesoma Anomihe',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            lineHeight: 0.8,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    CircularProgressWithLabel(
                      value: 70,
                      progressColor: blueShades[0],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Courses',
                    style: setTextTheme(
                      fontSize: 18.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(BrowseCoursesScreen.routeName),
                    child: Text(
                      'Browse',
                      style:
                          setTextTheme(fontSize: 14.sp, color: blueShades[0]),
                    ),
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: blueShades[18],
                  borderRadius: BorderRadius.circular(100.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: blueShades[0],
                unselectedLabelColor:
                    ThemeProvider().isDarkMode ? Colors.white : Colors.black,
                labelStyle: setTextTheme(fontSize: 12.sp),
                unselectedLabelStyle: setTextTheme(fontSize: 12.sp),
                dividerColor: Colors.transparent,
                isScrollable: true,
                tabs: [
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text('All'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text('Completed'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text('Pending'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CourseList(filter: 'all'),
                    CourseList(filter: 'completed'),
                    CourseList(filter: 'pending'),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  spacing: 15,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Courses',
                        style: setTextTheme(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'You have not started any course yet',
                      style: setTextTheme(fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    Buttons(
                      boxColor: blueShades[0],
                      text: 'Browse courses',
                      onTap: () {
                        context.push(BrowseCoursesScreen.routeName);
                      },
                      isLoading: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended for you',
                          style: setTextTheme(
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'view all',
                          style: setTextTheme(
                            color: blueShades[0],
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedCourses.length,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: SizedBox(
                              width: 200.w,
                              child: RecommendedCoursesWidget(
                                  course: recommendedCourses[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ]),
    );
  }
}

class CourseList extends StatelessWidget {
  final String filter;

  const CourseList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final filteredCourses = mockCourses.where((course) {
      if (filter == 'all') return true;
      return course.status == filter;
    }).toList();

    return ListView.builder(
      itemCount: filteredCourses.length,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return CourseItemWidget(course: course);
      },
    );
  }
}

//import 'package:cloudnottapp2/src/api_strings/api_quries/exams_homework_quires.dart';
// import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
// import 'package:cloudnottapp2/src/config/config.dart';
// import 'package:cloudnottapp2/src/data/local/mockdata/courses_mockdata.dart';
// import 'package:cloudnottapp2/src/data/models/course_items_model.dart';
// import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
// import 'package:cloudnottapp2/src/screens/student/courses/browse_course_screen.dart';
// import 'package:cloudnottapp2/src/screens/student/courses/widgets/circular_progress_with_label.dart';
// import 'package:cloudnottapp2/src/screens/student/courses/widgets/course_items_widget.dart';
// import 'package:cloudnottapp2/src/screens/student/courses/widgets/recommended_course_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class CoursesScreen extends StatefulWidget {
//   const CoursesScreen({super.key});

//   @override
//   _CoursesScreenState createState() => _CoursesScreenState();
// }

// class _CoursesScreenState extends State<CoursesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasOngoingCourses = mockCourses.isNotEmpty;

//     return CustomScrollView(
//       slivers: [
//         SliverPadding(
//           padding: EdgeInsets.all(10.r),
//           sliver: SliverList(
//             delegate: SliverChildListDelegate([
//               SizedBox(height: 5.h),
//               if (hasOngoingCourses) ...[
//                 Container(
//                   padding: EdgeInsets.all(10.r),
//                   decoration: BoxDecoration(
//                     color: ThemeProvider().isDarkMode
//                         ? blueShades[15]
//                         : blueShades[17],
//                     borderRadius: BorderRadius.circular(10.r),
//                     border: Border.all(
//                       color: ThemeProvider().isDarkMode
//                           ? Colors.transparent
//                           : blueShades[18],
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 40.r,
//                         height: 40.r,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100.r),
//                           image: DecorationImage(
//                             image: AssetImage('assets/app/mock.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10.w, vertical: 3.h),
//                             decoration: BoxDecoration(
//                                 color: blueShades[18],
//                                 borderRadius: BorderRadius.circular(100.r)),
//                             child: Text(
//                               'on-going',
//                               style: setTextTheme(
//                                   fontSize: 7.sp, color: blueShades[0]),
//                             ),
//                           ),
//                           Text('Algebra Equation for Jss 2',
//                               style: setTextTheme(fontSize: 14.sp)),
//                           Text(
//                             'by Nmesoma Anomihe',
//                             style: setTextTheme(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w500,
//                               lineHeight: 0.8,
//                             ),
//                           )
//                         ],
//                       ),
//                       Spacer(),
//                       CircularProgressWithLabel(
//                         value: 70,
//                         progressColor: blueShades[0],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'My Courses',
//                       style: setTextTheme(fontSize: 18.sp),
//                     ),
//                     GestureDetector(
//                       onTap: () => context.push(BrowseCoursesScreen.routeName),
//                       child: Text(
//                         'Browse',
//                         style:
//                             setTextTheme(fontSize: 14.sp, color: blueShades[0]),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.h),
//                 TabBar(
//                   controller: _tabController,
//                   indicator: BoxDecoration(
//                     color: blueShades[18],
//                     borderRadius: BorderRadius.circular(100.r),
//                   ),
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   labelColor: blueShades[0],
//                   unselectedLabelColor:
//                       ThemeProvider().isDarkMode ? Colors.white : Colors.black,
//                   labelStyle: setTextTheme(fontSize: 12.sp),
//                   unselectedLabelStyle: setTextTheme(fontSize: 12.sp),
//                   dividerColor: Colors.transparent,
//                   isScrollable: true,
//                   tabs: [
//                     SizedBox(
//                       height: 20,
//                       child: Center(child: Text('All')),
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: Center(child: Text('Completed')),
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: Center(child: Text('Pending')),
//                     ),
//                   ],
//                 ),
//               ] else ...[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'My Courses',
//                       style: setTextTheme(fontSize: 18.sp),
//                     ),
//                     SizedBox(height: 10.h),
//                     Center(
//                       child: Text(
//                         'You have not started any course yet',
//                         style: setTextTheme(fontWeight: FontWeight.w400),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     SizedBox(height: 15.h),
//                     Center(
//                       child: Buttons(
//                         text: 'Browse courses',
//                         onTap: () {
//                           context.push(BrowseCoursesScreen.routeName);
//                         },
//                         isLoading: false,
//                       ),
//                     ),
//                     SizedBox(height: 15.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Recommended for you',
//                           style: setTextTheme(fontSize: 18.sp),
//                         ),
//                         Text(
//                           'view all',
//                           style: setTextTheme(
//                             color: blueShades[0],
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     SizedBox(
//                       height: 250.h,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.horizontal,
//                         itemCount: recommendedCourses.length,
//                         padding: EdgeInsets.symmetric(horizontal: 10.w),
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: EdgeInsets.only(right: 15.w),
//                             child: SizedBox(
//                               width: 200.w,
//                               child: RecommendedCoursesWidget(
//                                   course: recommendedCourses[index]),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ]),
//           ),
//         ),
//         if (hasOngoingCourses)
//           SliverToBoxAdapter(
//             child: DefaultTabController(
//               length: 3,
//               child: TabBarView(
//                 controller: _tabController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   CourseList(filter: 'all'),
//                   CourseList(filter: 'completed'),
//                   CourseList(filter: 'pending'),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class CourseList extends StatelessWidget {
//   final String filter;

//   const CourseList({super.key, required this.filter});

//   @override
//   Widget build(BuildContext context) {
//     final filteredCourses = mockCourses.where((course) {
//       if (filter == 'all') return true;
//       return course.status == filter;
//     }).toList();

//     // Handle empty state
//     if (filteredCourses.isEmpty) {
//       return SizedBox(
//         height: 100.h,
//         child: Center(
//           child: Text(
//             'No ${filter == 'all' ? 'courses' : '$filter courses'} available',
//             style: setTextTheme(fontSize: 16.sp),
//           ),
//         ),
//       );
//     }

//     return CustomScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       slivers: [
//         SliverList(
//           delegate: SliverChildListDelegate(
//             List.generate(
//               filteredCourses.length,
//               (index) {
//                 final course = filteredCourses[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                   child: CourseItemWidget(course: course),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // import 'package:cloudnottapp2/src/api_strings/api_quries/exams_homework_quires.dart';
// // import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
// // import 'package:cloudnottapp2/src/config/config.dart';
// // import 'package:cloudnottapp2/src/data/local/mockdata/courses_mockdata.dart';
// // import 'package:cloudnottapp2/src/data/models/course_items_model.dart';
// // import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
// // import 'package:cloudnottapp2/src/screens/student/courses/browse_course_screen.dart';
// // import 'package:cloudnottapp2/src/screens/student/courses/widgets/circular_progress_with_label.dart';
// // import 'package:cloudnottapp2/src/screens/student/courses/widgets/course_items_widget.dart';
// // import 'package:cloudnottapp2/src/screens/student/courses/widgets/recommended_course_widget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:go_router/go_router.dart';

// // class CoursesScreen extends StatefulWidget {
// //   const CoursesScreen({super.key});

// //   @override
// //   _CoursesScreenState createState() => _CoursesScreenState();
// // }

// // class _CoursesScreenState extends State<CoursesScreen>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasOngoingCourses = mockCourses.isNotEmpty;

// //     return CustomScrollView(
// //       slivers: [
// //         SliverPadding(
// //           padding: EdgeInsets.all(10.r),
// //           sliver: SliverList(
// //             delegate: SliverChildListDelegate([
// //               SizedBox(height: 5.h),
// //               if (hasOngoingCourses) ...[
// //                 Container(
// //                   padding: EdgeInsets.all(10.r),
// //                   decoration: BoxDecoration(
// //                     color: ThemeProvider().isDarkMode
// //                         ? blueShades[15]
// //                         : blueShades[17],
// //                     borderRadius: BorderRadius.circular(10.r),
// //                     border: Border.all(
// //                       color: ThemeProvider().isDarkMode
// //                           ? Colors.transparent
// //                           : blueShades[18],
// //                     ),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Container(
// //                         width: 40.r,
// //                         height: 40.r,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(100.r),
// //                           image: DecorationImage(
// //                             image: AssetImage('assets/app/mock.png'),
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             padding: EdgeInsets.symmetric(
// //                                 horizontal: 10.w, vertical: 3.h),
// //                             decoration: BoxDecoration(
// //                                 color: blueShades[18],
// //                                 borderRadius: BorderRadius.circular(100.r)),
// //                             child: Text(
// //                               'on-going',
// //                               style: setTextTheme(
// //                                   fontSize: 7.sp, color: blueShades[0]),
// //                             ),
// //                           ),
// //                           Text('Algebra Equation for Jss 2',
// //                               style: setTextTheme(fontSize: 14.sp)),
// //                           Text(
// //                             'by Nmesoma Anomihe',
// //                             style: setTextTheme(
// //                               fontSize: 14.sp,
// //                               fontWeight: FontWeight.w500,
// //                               lineHeight: 0.8,
// //                             ),
// //                           )
// //                         ],
// //                       ),
// //                       Spacer(),
// //                       CircularProgressWithLabel(
// //                         value: 70,
// //                         progressColor: blueShades[0],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 10.h),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       'My Courses',
// //                       style: setTextTheme(fontSize: 18.sp),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () => context.push(BrowseCoursesScreen.routeName),
// //                       child: Text(
// //                         'Browse',
// //                         style:
// //                             setTextTheme(fontSize: 14.sp, color: blueShades[0]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 10.h),
// //                 TabBar(
// //                   controller: _tabController,
// //                   indicator: BoxDecoration(
// //                     color: blueShades[18],
// //                     borderRadius: BorderRadius.circular(100.r),
// //                   ),
// //                   indicatorSize: TabBarIndicatorSize.tab,
// //                   labelColor: blueShades[0],
// //                   unselectedLabelColor:
// //                       ThemeProvider().isDarkMode ? Colors.white : Colors.black,
// //                   labelStyle: setTextTheme(fontSize: 12.sp),
// //                   unselectedLabelStyle: setTextTheme(fontSize: 12.sp),
// //                   dividerColor: Colors.transparent,
// //                   isScrollable: true,
// //                   tabs: [
// //                     SizedBox(
// //                       height: 20,
// //                       child: Center(child: Text('All')),
// //                     ),
// //                     SizedBox(
// //                       height: 20,
// //                       child: Center(child: Text('Completed')),
// //                     ),
// //                     SizedBox(
// //                       height: 20,
// //                       child: Center(child: Text('Pending')),
// //                     ),
// //                   ],
// //                 ),
// //               ] else ...[
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'My Courses',
// //                       style: setTextTheme(fontSize: 18.sp),
// //                     ),
// //                     SizedBox(height: 10.h),
// //                     Center(
// //                       child: Text(
// //                         'You have not started any course yet',
// //                         style: setTextTheme(fontWeight: FontWeight.w400),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     SizedBox(height: 15.h),
// //                     Center(
// //                       child: Buttons(
// //                         text: 'Browse courses',
// //                         onTap: () {
// //                           context.push(BrowseCoursesScreen.routeName);
// //                         },
// //                         isLoading: false,
// //                       ),
// //                     ),
// //                     SizedBox(height: 15.h),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           'Recommended for you',
// //                           style: setTextTheme(fontSize: 18.sp),
// //                         ),
// //                         Text(
// //                           'view all',
// //                           style: setTextTheme(
// //                             color: blueShades[0],
// //                             fontSize: 18.sp,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 10.h),
// //                     SizedBox(
// //                       height: 250.h,
// //                       child: ListView.builder(
// //                         shrinkWrap: true,
// //                         scrollDirection: Axis.horizontal,
// //                         itemCount: recommendedCourses.length,
// //                         padding: EdgeInsets.symmetric(horizontal: 10.w),
// //                         itemBuilder: (context, index) {
// //                           return Padding(
// //                             padding: EdgeInsets.only(right: 15.w),
// //                             child: SizedBox(
// //                               width: 200.w,
// //                               child: RecommendedCoursesWidget(
// //                                   course: recommendedCourses[index]),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ]),
// //           ),
// //         ),
// //         if (hasOngoingCourses)
// //           SliverToBoxAdapter(
// //             child: DefaultTabController(
// //               length: 3,
// //               child: TabBarView(
// //                 controller: _tabController,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 children: [
// //                   CourseList(filter: 'all'),
// //                   CourseList(filter: 'completed'),
// //                   CourseList(filter: 'pending'),
// //                 ],
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// // }

// // class CourseList extends StatelessWidget {
// //   final String filter;

// //   const CourseList({super.key, required this.filter});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Add null check for mockCourses
// //     if (mockCourses == null) {
// //       return const SizedBox(
// //         child: Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     }
// //     final filteredCourses = mockCourses.where((course) {
// //       if (filter == 'all') return true;
// //       return course.status == filter;
// //     }).toList();

// //     // Handle empty state
// //     if (filteredCourses.isEmpty) {
// //       return SizedBox(
// //         height: 100.h,
// //         child: Center(
// //           child: Text(
// //             'No ${filter == 'all' ? 'courses' : '$filter courses'} available',
// //             style: setTextTheme(fontSize: 16.sp),
// //           ),
// //         ),
// //       );
// //     }

// //     // return CustomScrollView(
// //     //   physics: const NeverScrollableScrollPhysics(),
// //     //   shrinkWrap: true,
// //     //   slivers: [
// //     //     SliverList(
// //     //       delegate: SliverChildListDelegate(
// //     //         List.generate(
// //     //           filteredCourses.length,
// //     //           (index) {
// //     //             final course = filteredCourses[index];
// //     //             return Padding(
// //     //               padding: EdgeInsets.symmetric(vertical: 10.h),
// //     //               child: CourseItemWidget(course: course),
// //     //             );
// //     //           },
// //     //         ),
// //     //       ),
// //     //     ),
// //     //   ],
// //     // );

// //     return SliverPadding(
// //       padding: EdgeInsets.symmetric(horizontal: 15.w),
// //       sliver: SliverList(
// //         delegate: SliverChildBuilderDelegate(
// //           (context, index) {
// //             final course = filteredCourses[index];
// //             if (course == null) return const SizedBox.shrink();

// //             return Padding(
// //               padding: EdgeInsets.symmetric(vertical: 10.h),
// //               child: CourseItemWidget(course: course),
// //             );
// //           },
// //           childCount: filteredCourses.length,
// //         ),
// //       ),
// //     );
// //   }
// // }
