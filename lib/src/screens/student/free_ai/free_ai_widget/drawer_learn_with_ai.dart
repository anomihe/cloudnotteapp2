import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learn_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learning_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/custom_three_lines_painter.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/dashed_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/user_model.dart';

class DrawerLearnWithAi extends StatefulWidget {
  const DrawerLearnWithAi({super.key});

  @override
  State<DrawerLearnWithAi> createState() => _DrawerLearnWithAiState();
}

class _DrawerLearnWithAiState extends State<DrawerLearnWithAi> {
  bool _isMailCollapsed = true;

  @override
  Widget build(BuildContext context) {
    User? user = context.read<UserProvider>().user;
    final freeAiProvider = Provider.of<FreeAiProvider>(context);

    // Get the last 4 items from userAddedTopics (or all if less than 4)
    final recentTopics = freeAiProvider.userAddedTopics.reversed
        .take(4)
        .toList()
        .reversed
        .toList(); // Reverse to show oldest of the 4 first

    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkShades[0] // Black for dark mode
          : whiteShades[0], // White for light mode
      child: GestureDetector(
        onTap: () {
          if (!_isMailCollapsed) {
            setState(() => _isMailCollapsed = true);
          }
        },
        child: Column(
          children: [
            // Expanded ListView for dynamic content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.h, left: 16.w),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/app/cloudnottapp2_logo_two.png",
                          width: 33,
                          height: 30,
                        ),
                        Text(
                          'cloudnottapp2',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 18.sp,
                            color: ThemeProvider().isDarkMode
                                ? redShades[1]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(LearnWithAi.routeName),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20.h, left: 16.w, right: 16.w, bottom: 15.h),
                      child: DashedBorderContainer(
                        borderColor: Theme.of(context).dividerColor,
                        borderWidth: 2.0,
                        dashWidth: 5.0,
                        dashSpace: 3.0,
                        borderRadius: 10.0,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.w, top: 10.h, bottom: 10.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: ThemeProvider().isDarkMode
                                    ? redShades[1]
                                    : Colors.black,
                              ),
                              Text('Add content',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.history,
                      color: ThemeProvider().isDarkMode
                          ? redShades[1]
                          : Colors.black,
                    ),
                    title: Text('History',
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {},
                  ),
                  if (recentTopics.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Recents',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ],

                  // Display the last 4 items from userAddedTopics
                  ...recentTopics.map((topic) {
                    final isVideoOrAudio = topic.fileType == 'youtube' ||
                        topic.fileType == 'mp3' ||
                        topic.fileType == 'mp4' ||
                        topic.fileType == 'wav' ||
                        topic.fileType == 'm4a' ||
                        topic.fileType == 'TikTok';
                    return ListTile(
                      leading: isVideoOrAudio
                          ? Icon(
                              Icons.play_arrow_outlined,
                              color: ThemeProvider().isDarkMode
                                  ? redShades[1]
                                  : Colors.black,
                            )
                          : CustomPaint(
                              painter: CustomThreeLinesPainter(),
                              size: const Size(15, 10),
                            ),
                      title: Text(
                        (topic.title ?? topic.name).length > 60
                            ? '${(topic.title ?? topic.name).substring(0, 60)}...'
                            : topic.title ?? topic.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: topic.sessionId == null
                          ? null
                          : () {
                              context.push(
                                LearningWithAi.routeName,
                                extra: topic,
                              );
                            },
                    );
                  }).toList(),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to cloudnottapp2 Ai',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: ThemeProvider().isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'An AI tutor personalized to you.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ThemeProvider().isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Understand your files, YouTube video, or recorded lecture through key concepts, familiar learning tools like flashcards, and interactive conversations.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ThemeProvider().isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'We’re constantly improving the platform, and if you have any feedback, we would love to hear from you.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ThemeProvider().isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Email container pinned to the bottom
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 15.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text('${user?.firstName} ${user?.lastName}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Spacer(),
                    IconButton(
                      onPressed: () =>
                          setState(() => _isMailCollapsed = !_isMailCollapsed),
                      icon: Icon(
                        _isMailCollapsed
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18.sp,
                        color: ThemeProvider().isDarkMode
                            ? redShades[1]
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dropdown menu when expanded
            if (!_isMailCollapsed)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: 70.h, left: 12.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        child: Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 38.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).dividerColor,
                              ),
                              child: Center(
                                child: Text(
                                  (user?.firstName?[0] ?? '') +
                                      (user?.lastName?[0] ?? ''),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '${user?.firstName} ${user?.lastName}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Transform.scale(
                              scaleX: 0.9,
                              scaleY: 0.8,
                              child: Switch(
                                value:
                                    context.watch<ThemeProvider>().isDarkMode,
                                inactiveThumbColor: Colors.grey[600],
                                trackOutlineColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onChanged: (value) {
                                  context
                                      .read<ThemeProvider>()
                                      .toggleTheme(value);
                                },
                              ),
                            ),
                            Text('Dark Mode',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: ThemeProvider().isDarkMode
                              ? redShades[1]
                              : Colors.black,
                        ),
                        title: Text('Log out',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onTap: () =>
                            context.read<AuthProvider>().logOut(context),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
