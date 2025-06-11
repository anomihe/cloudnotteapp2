import 'package:cloudnottapp2/src/config/themes.dart';

import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/recorded_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StudentDashboardScreen extends StatefulWidget {
  static const String routeName = "/student_dashboard";
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(),
        centerTitle: false,
        // leading: CircleAvatar(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                "assets/icons/menu_icon.svg",
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 400.w,
                  height: 110.h,
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {},
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPage(0),
                      _buildPage(0),
                      _buildPage(0),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 7,
                    activeDotColor: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // SizedBox(
                //   width: 400.w,
                //   child: ListView.builder(itemBuilder: (context, index) {
                //     return Container();
                //   }),
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
//use this for navigating from the homepage to homework entry page.
                    GestureDetector(
                      onTap: () {
                        // context.push(
                        //   '/homework_entry_screen',
                        //   extra: HomeworkModel(
                        //     subject: '',
                        //     // status: 'Open',
                        //     task: '',
                        //     date: DateTime.now(), questions: [],
                        //     duration: Duration(minutes: 30), groupName: '',
                        //     mark: 10,
                        //     // id: '123',
                        //   ),
                        // );
                      },
                      child: _infoCard(
                        icon: "assets/icons/assignment_icon.svg",
                        count: "12",
                        title: "Homework",
                        backgroundColor: greenShades[0],
                        color: whiteShades[0],
                        countText: "new",
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        // context.push(ClassSchedules.routeName);
                      },
                      child: _infoCard(
                        icon: "assets/icons/class_icon.svg",
                        count: "6",
                        title: "My Classes",
                        backgroundColor: greenShades[1],
                        color: Colors.black,
                        countText: "today",
                      ),
                    ),
                  ],
                ),

                // CLASSMATES SECTION
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 110.h,
                  width: 334.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Classmates",
                            style: setTextTheme(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'show all',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 334.w,
                        height: 60.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Container(
                                height: 66.h,
                                width: 66.w,
                                decoration: BoxDecoration(
                                  color: whiteShades[0],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    _infoCard(
                      icon: "assets/icons/exams_icon.svg",
                      count: "12",
                      title: "Exams",
                      backgroundColor: goldenShades[0],
                      color: Colors.black,
                      countText: "new",
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RecordedClass.routeName);
                      },
                      child: _infoCard(
                        icon: "assets/icons/recorded_icon.svg",
                        count: "6",
                        title: "Recorded Class",
                        backgroundColor: redShades[0],
                        color: whiteShades[0],
                        countText: "today",
                      ),
                    ),
                  ],
                ),
                // TEACHERS SECTION
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 110.h,
                  width: 334.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Teachers",
                            style: setTextTheme(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'show all',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 353.w,
                        height: 76.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F8FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 66.h,
                                      width: 66.w,
                                      decoration: BoxDecoration(
                                        color: whiteShades[0],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "John Doe",
                                          style: setTextTheme(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "English Language",
                                              style: setTextTheme(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 7.w,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: CircleAvatar(
                                                backgroundColor: redShades[0],
                                                child: Text(
                                                  "+5",
                                                  style: setTextTheme(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: whiteShades[0],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
      {Color? color,
      required String icon,
      String? title,
      String? count,
      String? countText,
      Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      height: 149.h,
      width: 165.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                color: color,
                width: 34.w,
                height: 34.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "$title",
                  overflow: TextOverflow.clip,
                  style: setTextTheme(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Text(
                "$count",
                textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                    leadingDistribution: TextLeadingDistribution.even),
                style: setTextTheme(
                  color: color,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  lineHeight: 0.4,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "$countText",
                  textAlign: TextAlign.start,
                  style: setTextTheme(
                    color: color,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      height: 110.h,
      width: 345.w,
      decoration: BoxDecoration(
        color: blueShades[0],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              height: 80.h,
              width: 90.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteShades[0],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 200.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "cloudnottapp2 learning centre",
                    overflow: TextOverflow.clip,
                    style: setTextTheme(
                      color: whiteShades[0],
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "2023/2024 -1st term",
                    style: setTextTheme(
                      color: whiteShades[0],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
