import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  static const String routeName = "/GetStartedscreen";

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  int selectedIndex = -1;
  bool isloading = false;
  bool isEnabled = false;

  final List<Map<String, dynamic>> roles = [
    {
      'title': "I'm a school owner",
      'subtitle': 'Use cloudnottapp2 to streamline school operations',
      'icon': 'assets/app/pix2.png',
      'route': '/schoolOwnerScreen',
    },
    {
      'title': "I'm a Teacher",
      'subtitle': 'I want to use cloudnottapp2 for teaching',
      'icon': 'assets/app/Vector@2x.png',
      'route': '/teacherScreen',
    },
    {
      'title': "I'm a Student",
      'subtitle': 'I want to use cloudnottapp2 for learning',
      'icon': 'assets/app/pix2.png',
      'route': '/studentScreen',
    },
    {
      'title': "I'm a Parent",
      'subtitle': 'I want to use cloudnottapp2 for monitoring',
      'icon': 'assets/app/Vector@2x.png',
      'route': '/parentScreen',
    },
    {
      'title': "I'm a Teacher",
      'subtitle': 'I want to use cloudnottapp2 for teaching',
      'icon': 'assets/app/pix2.png',
      'route': '/teacherScreen',
    },
    {
      'title': "I'm a Teacher",
      'subtitle': 'I want to use cloudnottapp2 for teaching',
      'icon': 'assets/app/Vector@2x.png',
      'route': '/teacherScreen',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Text(
              'Get started',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: redShades[1],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Start by choosing your role',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: blueShades[1],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  childAspectRatio: 8 / 9,
                ),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        isEnabled =
                            true; //changes the button color once any item is selected
                      });
                    },
                    child: Container(
                      height: 10,
                      width: 20,
                      decoration: BoxDecoration(
                        color: whiteShades[0],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              isSelected ? redShades[0] : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              role['icon'],
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push(WelcomeScreen.routeName);
                              },
                              child: Text(
                                role['title']!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: blueShades[0],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              child: Text(
                                role['subtitle']!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: blueShades[1],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Buttons(
              text: 'Proceed',
              enabled: isEnabled,
              onTap: () {
                setState(() {
                  isloading = true;
                  Future.delayed(Duration(seconds: 3), () {
                    context.push(WelcomeScreen.routeName);
                  });

                  // then logic to the next screen
                });
              },
              isLoading: isloading,
            )
          ],
        ),
      ),
    );
  }
}
