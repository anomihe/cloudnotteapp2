import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../create_school_screens/creat_school.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});
  static const String routeName = "/JoinScreen";

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ClipOval(
          child: Image.asset(
            'assets/app/Ellipse 27.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/app/Vector2.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            Image.asset(
              'assets/app/image 3.png',
              fit: BoxFit.cover,
              // height: 400.h,
            ),
            SizedBox(height: 30.h),
            // Welcome text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                "Welcome to cloudnottapp2, you need to join a school or create one to start learning",
                textAlign: TextAlign.center,
                style: setTextTheme(
                  fontWeight: FontWeight.w400,
                  // fontSize: 16.sp,
                  color: blueShades[2],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // Join School button
            Buttons(
              text: 'Join School',
              fontWeight: FontWeight.w700,
              isLoading: false,
              onTap: () {
                context.push(ChooseSchool.routeName);
              },
            ),
            SizedBox(height: 16.h),
            // Create School button
            Buttons(
              text: 'Create School',
              textColor: Colors.black,
              fontWeight: FontWeight.w700,
              isLoading: false,
              onTap: () {
                context.push(CreateSchool.routeName);
              },
              boxColor: whiteShades[0],
              border: Border.all(
                color: redShades[1],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

// appBar: AppBar(
//         elevation: 0,
//         backgroundColor: whiteShades[0],
//         leading: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundImage: NetworkImage(''),
//           ),
//         ),
// actions: [
//   IconButton(
//     icon: const Icon(Icons.menu, color: Colors.black),
//     onPressed: () {},
//   ),
// ],
//       ),
