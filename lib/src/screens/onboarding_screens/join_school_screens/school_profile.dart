import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/model_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../components/shared_widget/general_button.dart';

class Profil extends StatelessWidget {
  final SchoolModel schoolModel;
  const Profil({super.key, required this.schoolModel});
  static const String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteShades[0],
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  Text(
                    'Profile',
                    style: setTextTheme(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            // School logo
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/app/image (1).png',
                  width: 150,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // School name
            Center(
              child: Text(
                schoolModel.schoolName,
                style: setTextTheme(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                // textAlign: TextAlign.center,
              ),
            ),
            // Location
            Center(
              child: Text(
                schoolModel.address,
                style: setTextTheme(fontSize: 18.sp, color: Colors.black),
              ),
            ),
            const SizedBox(height: 100),
            // About section
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: setTextTheme(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: redShades[1],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  schoolModel.about,
                  style: setTextTheme(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            const Spacer(),
            // Join School button
            Buttons(
              text: 'Join School',
              isLoading: false,
              onTap: () {
                context.push(ChooseSchool.routeName);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
