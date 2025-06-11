import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/shared_widget/general_button.dart';

class ViewSchool extends StatelessWidget {
  static const String routeName = "/viewSchool";

  const ViewSchool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Image.asset(
              'assets/app/image 5 (1).png',
              fit: BoxFit.cover,
              height: 400,
            ),
            const SizedBox(height: 5),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Charles Dale School',
                  style: setTextTheme(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: greenShades[0],
                  ),
                  children: [
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                      text: "setup successfully",
                      style: setTextTheme(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: blueShades[1],
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 16),
            // view school
            Buttons(
              text: 'View school',
              isLoading: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
