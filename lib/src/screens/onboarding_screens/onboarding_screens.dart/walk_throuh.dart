import 'dart:async';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../components/shared_widget/general_button.dart';
import 'signin.dart';

class Rolls extends StatefulWidget {
  const Rolls({super.key});
  static const String routeName = "/rolls";

  @override
  State<Rolls> createState() => _RollsState();
}

class _RollsState extends State<Rolls> {
  int currentIndex = 0;
  late PageController controller;
  Timer? timer;

  // List of slides with titles and subtitles
  final List<Map<String, dynamic>> text = [
    {
      'title': 'Enjoy education at its own peak at your fingertip',
      'subtitle': 'Providing peace of mind even from a distance',
    },
    {
      'title': 'Enjoy education at its own peak at your fingertip',
      'subtitle': 'Providing peace of mind even from a distance',
    },
    {
      'title': 'Enjoy education at its own peak at your fingertip',
      'subtitle': 'Providing peace of mind even from a distance',
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController();
    startAutoScroll();
  }

  // Automatically scroll through the slides every 5 seconds
  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 5), (t) {
      setState(() {
        currentIndex = (currentIndex + 1) % text.length;
      });
      controller.animateToPage(
        currentIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/app/pix.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: text.length,
                      itemBuilder: (context, i) {
                        final data = text[i];
                        return Column(
                          children: [
                            Text(
                              data['title'],
                              textAlign: TextAlign.center,
                              style: setTextTheme(
                                  fontSize: 22.sp,
                                  color: whiteShades[0],
                                  lineHeight: 1.1),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              data['subtitle'],
                              textAlign: TextAlign.center,
                              style: setTextTheme(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: whiteShades[0],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Slide indicators
                  SizedBox(
                    height: 4,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) => Row(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: currentIndex == index
                                    ? whiteShades[0]
                                    : Colors.grey,
                              ),
                              // height: 4.h,
                              width: MediaQuery.of(context).size.width / 6,
                            ),
                            SizedBox(width: 20.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Get Started button
                  SizedBox(height: 15.h),
                  Buttons(
                    text: 'Get Started',
                    isLoading: false,
                    onTap: () {
                      context.go(SignInScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
