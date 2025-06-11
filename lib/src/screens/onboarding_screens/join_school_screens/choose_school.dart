import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/Find_schools.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/school_card_widget.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learn_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../student/free_ai/free_ai_widget/nav_cards.dart';

class ChooseSchool extends StatefulWidget {
  static const String routeName = "/ChooseSchool";

  const ChooseSchool({super.key});

  @override
  State<ChooseSchool> createState() => _ChooseSchoolState();
}

class _ChooseSchoolState extends State<ChooseSchool> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Provider.of<UserProvider>(context, listen: false)
            .getSignedUser(context),
        Provider.of<UserProvider>(context, listen: false)
            .getUserSpaces(context),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, value, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Choose school",
                            style: setTextTheme(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Start by choosing your school",
                            style: setTextTheme(
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SchoolCard(
                            onPress: () {
                              context.push(LearnWithAi.routeName);
                            },
                            schoolName: 'AI Tutor',
                            termInfo: 'Interact with document, audio and video',
                            imageUrl: '',
                            // imageUrl: "assets/app/cloudnottapp2_logo_two.png",
                          ),
                          SizedBox(height: 10),
                          if (value.isLoading && value.isLoadingStateTwo)
                            Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                                CircularProgressIndicator(),
                              ],
                            )
                          else if (value.space.isEmpty)
                            Column(
                              children: [
                                SizedBox(
                                  child: Image.asset(
                                    'assets/app/image 5 (1).png',
                                    fit: BoxFit.cover,
                                    height: 400,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'No school found on your account',
                                  style: setTextTheme(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            )
                          else
                            ListView.separated(
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.space.length,
                              itemBuilder: (context, index) {
                                final data = value.space[index];
                                return Column(
                                  children: [
                                    SchoolCard(
                                      onPress: () async {
                                        await Provider.of<LessonNotesProvider>(
                                                context,
                                                listen: false)
                                            .fetchClassGroup(
                                          spaceId: data.id ?? "",
                                          context: context,
                                        );

                                        context.push(
                                            StudentLandingScreen.routeName,
                                            extra: {
                                              "id": data.id,
                                              "provider": value,
                                            });
                                        value.setCurrentSpace(data.name ?? "");
                                        value.setAlias(data.alias ?? "");
                                        value.setData(data);
                                        value.setGroup(
                                            sessionId:
                                                data.currentSpaceSessionId ??
                                                    "",
                                            termId:
                                                data.currentSpaceTermId ?? "");
                                      },
                                      schoolName: data.name ?? "",
                                      termInfo: data.description ?? "",
                                      imageUrl: data.logo ?? '',
                                      isDefault: true,
                                    ),
                                    const SizedBox(height: 1),
                                  ],
                                );
                              },
                            ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Can't find your school?",
                        style: setTextTheme(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Buttons(
                        text: 'Find School',
                        isLoading: false,
                        onTap: () {
                          context.push(FindSchools.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
