import 'dart:async';
import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/accounting/admin_fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/chat_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_entry_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/lesson_note_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_lesson_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/account_summary.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/profile_screen.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/class_schedules_screen.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/report_sheet_screen.dart';
import 'package:provider/provider.dart';

import '../teacher/teacher_screens/teacher_entry_screen.dart'
    show AdminEntryScreen, TeacherEntryScreen;

class StudentLandingScreen extends StatefulWidget {
  static const String routeName = "/student_landing";
  final String id;
  final int? currentIndex;
  final UserProvider value;

  const StudentLandingScreen({
    super.key,
    required this.id,
    required this.value,
    this.currentIndex = 0,
  });

  @override
  _StudentLandingScreenState createState() => _StudentLandingScreenState();
}

class _StudentLandingScreenState extends State<StudentLandingScreen> {
  late Future<void> _fetchSpaceFuture;
  int _currentScreen = 0;
  bool _showNavBar = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _currentScreen = widget.currentIndex ?? 0;
    _fetchSpaceFuture = _initData();
  }

  Future<void> _initData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.getSpace(context, '', widget.id); // Fetch features first
    await userProvider.getUserOneSpace(
        context, '', widget.id); // Then user+role
  }

  @override
  Widget build(BuildContext context) {
    final isdarkMode = context.watch<ThemeProvider>().isDarkMode;

    return FutureBuilder<void>(
      future: _fetchSpaceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final String role = userProvider.singleSpace?.role ??
              localStore.get('role', defaultValue: '');
          final List<String> features = userProvider.model?.features ?? [];
          if (role.toLowerCase() == 'admin' && features.length < 5) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                SnackBar(
                  content: const Text(
                    'Some features are turned off. Please go to the web dashboard to enable them.',
                  ),
                  backgroundColor: Colors.amber.shade700,
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          }
          final List<Widget> screens = _buildScreens(role, features);
          final List<BottomNavigationBarItem> navItems =
              _buildNavItems(role, features);

          if (_currentScreen >= screens.length) {
            _currentScreen = 0;
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!_showNavBar) {
                setState(() => _showNavBar = true);
              }
            },
            child: Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis != Axis.vertical) return false;
                  if (notification is ScrollUpdateNotification) {
                    if (notification.scrollDelta == null) return false;
                    if (notification.scrollDelta! > 0 && _showNavBar) {
                      setState(() => _showNavBar = false);
                    } else if (notification.scrollDelta! < 0 && !_showNavBar) {
                      setState(() => _showNavBar = true);
                    }
                  }
                  return false;
                },
                child: screens[_currentScreen],
              ),
              bottomNavigationBar: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showNavBar ? (kBottomNavigationBarHeight + 15) : 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: BottomNavigationBar(
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    onTap: (index) => setState(() => _currentScreen = index),
                    backgroundColor:
                        isdarkMode ? blueShades[15] : blueShades[17],
                    elevation: 0,
                    currentIndex: _currentScreen,
                    type: BottomNavigationBarType.fixed,
                    items: navItems,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // List<Widget> _buildScreens(String role, List<String> features) {
  //   final isAdmin = role.toLowerCase() == 'admin';
  //   List<Widget> screens = [];

  //   if (features.contains("Timetable")) {
  //     screens.add(ClassSchedules(id: widget.id));
  //   }

  //   if (role != 'teacher' && features.contains('Accounting')) {
  //     screens.add(_buildChatScreenByRole(role));
  //   }

  //   if (features.contains("Computer Based Test")) {
  //     screens.add(_buildAssessmentScreenByRole(role));
  //   }

  //   if (features.contains("Lesson planner")) {
  //     screens.add(
  //       role == 'student'
  //           ? LessonNoteScreen(spaceId: widget.id)
  //           : TeacherLessonScreen(spaceId: widget.id),
  //     );
  //   }

  //   if (features.contains("Report sheet")) {
  //     screens.add(ResultScreen(spaceId: widget.id));
  //   }

  //   screens.add(ProfileScreen(value: widget.value));
  //   return screens;
  // }

  Widget _buildChatScreenByRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return FeePaymentScreen();
      case 'admin':
        return AdminFeePaymentScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAssessmentScreenByRole(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
        return TeacherEntryScreen(spaceId: widget.id);
      case 'student':
        return HomeworkEntryTabScreen(spaceId: widget.id);
      default:
        return AdminEntryScreen(spaceId: widget.id);
    }
  }
List<BottomNavigationBarItem> _buildNavItems(String role, List<String> features) {
  final isdarkMode = context.watch<ThemeProvider>().isDarkMode;
  final isAdmin = role.toLowerCase() == 'admin';
  List<BottomNavigationBarItem> items = [];

  int index = 0;

  // Handle empty features case - add a default Dashboard
  if (features.isEmpty) {
    items.add(_buildNavIcon(
      "assets/icons/dashboard.svg", // or use Icons.dashboard
      "Dashboard",
      index++
    ));
  } else {
    // Add feature-based navigation items
    if (features.contains("Timetable")) {
      items.add(_buildNavIcon("assets/icons/timetable.svg", "Home", index++));
    }

    if (role != 'teacher' && features.contains("Accounting")) {
      items.add(_buildNavIcon(
          "assets/icons/solar_money-bag-outline.svg", "Account", index++));
    }

    if (features.contains("Computer Based Test")) {
      items.add(_buildNavIcon(
          "assets/icons/assessment_icon.svg", "Homework", index++));
    }

    if (features.contains("Lesson planner")) {
      items.add(_buildNavIcon(
          "assets/icons/lesson_icon.svg", "Lesson Notes", index++));
    }

    if (features.contains("Report sheet")) {
      items.add(_buildNavIcon(
          "assets/icons/check_result_icon.svg", "Results", index++));
    }
  }

  // Always add Profile as the last item
  items.add(_buildProfileItem(index));

  // Final safety check: Ensure minimum 2 items for BottomNavigationBar
  if (items.length < 2) {
    // This shouldn't happen now, but just in case
    items.insert(0, _buildNavIcon(
      "assets/icons/home.svg",
      "Home",
      0
    ));
  }

  return items;
}

List<Widget> _buildScreens(String role, List<String> features) {
  final isAdmin = role.toLowerCase() == 'admin';
  List<Widget> screens = [];

  // Handle empty features case - add a default Dashboard/Welcome screen
  if (features.isEmpty) {
    screens.add(_buildWelcomeScreen(role)); // Simple welcome screen
  } else {
    // Add feature-based screens
    if (features.contains("Timetable")) {
      screens.add(ClassSchedules(id: widget.id));
    }

    if (role != 'teacher' && features.contains('Accounting')) {
      screens.add(_buildChatScreenByRole(role));
    }

    if (features.contains("Computer Based Test")) {
      screens.add(_buildAssessmentScreenByRole(role));
    }

    if (features.contains("Lesson planner")) {
      screens.add(
        role == 'student'
            ? LessonNoteScreen(spaceId: widget.id)
            : TeacherLessonScreen(spaceId: widget.id),
      );
    }

    if (features.contains("Report sheet")) {
      screens.add(ResultScreen(spaceId: widget.id));
    }
  }

  // Always add Profile as the last screen
  screens.add(ProfileScreen(value: widget.value));
  
  return screens;
}

// Simple welcome screen for when no features are enabled
Widget _buildWelcomeScreen(String role) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Welcome'),
      automaticallyImplyLeading: false,
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_applications,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Setting Up Your Space',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              role.toLowerCase() == 'admin' 
                ? 'Please configure your space features from the web dashboard to get started.'
                : 'Your administrator is setting up the features for this space.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            if (role.toLowerCase() == 'admin')
              ElevatedButton(
                onPressed: () {
                  // Add action to redirect to web dashboard or refresh
                },
                child: Text('Refresh'),
              ),
          ],
        ),
      ),
    ),
  );
}
  // List<BottomNavigationBarItem> _buildNavItems(
  //     String role, List<String> features) {
  //   final isdarkMode = context.watch<ThemeProvider>().isDarkMode;
  //   final isAdmin = role.toLowerCase() == 'admin';
  //   List<BottomNavigationBarItem> items = [];

  //   int index = 0;

  //   // ✅ Only add Home if "Timetable" is enabled
  //   if (features.contains("Timetable")) {
  //     items.add(_buildNavIcon("assets/icons/timetable.svg", "Home", index++));
  //   }

  //   if (role != 'teacher' && features.contains("Accounting")) {
  //     items.add(_buildNavIcon(
  //         "assets/icons/solar_money-bag-outline.svg", "Account", index++));
  //   }

  //   if (features.contains("Computer Based Test")) {
  //     items.add(_buildNavIcon(
  //         "assets/icons/assessment_icon.svg", "Homework", index++));
  //   }

  //   if (features.contains("Lesson planner")) {
  //     items.add(_buildNavIcon(
  //         "assets/icons/lesson_icon.svg", "Lesson Notes", index++));
  //   }

  //   if (features.contains("Report sheet")) {
  //     items.add(_buildNavIcon(
  //         "assets/icons/check_result_icon.svg", "Results", index++));
  //   }

  //   items.add(_buildProfileItem(index));
  //   return items;
  // }

  BottomNavigationBarItem _buildNavIcon(String path, String label, int index) {
    final isdarkMode = context.watch<ThemeProvider>().isDarkMode;
    final isSelected = _currentScreen == index;

    return BottomNavigationBarItem(
      icon: SizedBox(
        height: isSelected ? 35.r : 25.r,
        width: isSelected ? 35.r : 25.r,
        child: SvgPicture.asset(
          path,
          colorFilter: ColorFilter.mode(
            isSelected
                ? blueShades[0]
                : isdarkMode
                    ? Colors.white
                    : Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildProfileItem(int index) {
    final isdarkMode = context.watch<ThemeProvider>().isDarkMode;
    final isSelected = _currentScreen == index;

    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 35.r,
        width: 35.r,
        child: ClipOval(
          child: FadeInImage.assetNetwork(
            height: 35.r,
            width: 35.r,
            placeholder: 'assets/app/profile_picture1.png',
            image: widget.value.user?.profileImageUrl ?? '',
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/app/profile_picture1.png',
                color: isSelected
                    ? blueShades[0]
                    : isdarkMode
                        ? Colors.white
                        : Colors.black,
              );
            },
          ),
        ),
      ),
      label: '',
    );
  }
}
