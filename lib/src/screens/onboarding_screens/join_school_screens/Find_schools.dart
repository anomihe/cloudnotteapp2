import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/school_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/model_class.dart';

class FindSchools extends StatefulWidget {
  const FindSchools({super.key});
  static const String routeName = "/findSchool";

  @override
  State<FindSchools> createState() => _FindSchoolsState();
}

class _FindSchoolsState extends State<FindSchools> {
  // final List<Map<String, String>> school = [
  //   {
  //     "name": "Holmac School",
  //     "location": "Port Harcourt, Nigeria",
  //     "description":
  //         "The school can add them via their phone number or email! If they have an account already they will be added to the school or they will be sent an invitation to join cloudnottapp2.",
  //     "imagePath": " "
  //   },
  //   {
  //     "name": "Greenfield Academy",
  //     "location": "Lagos, Nigeria",
  //     "description":
  //         "The school can add them via their phone number or email! If they have an account already they will be added to the school or they will be sent an invitation to join cloudnottapp2.",
  //     "imagePath": " "
  //   },
  //   {
  //     "name": "Greenfield Academy",
  //     "location": "Lagos, Nigeria",
  //     "description":
  //         "The school can add them via their phone number or email! If they have an account already they will be added to the school or they will be sent an invitation to join cloudnottapp2.",
  //     "imagePath": " "
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find Schools",
          style: setTextTheme(
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Filter Button
            Container(
              height: 90.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: redShades[1],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search school by name or topic",
                          filled: true,
                          contentPadding: const EdgeInsets.all(1),
                          // fillColor: whiteShades[1],
                          prefixIcon: Icon(Icons.search, color: redShades[1]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Advanced filter",
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: whiteShades[0],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //const SizedBox(height: 5),
            // School List
            Expanded(
              child: ListView.builder(
                itemCount: school.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // print(school[i]);
                          context.go(Profil.routeName, extra: school[i]);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F9FF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // School Logo
                                ClipOval(
                                  child: Image.asset(
                                    school[i].imagePath,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // School Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        school[i].schoolName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        school[i].address,
                                        style: setTextTheme(
                                          color: whiteShades[2],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        school[i].description,
                                        style: setTextTheme(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
