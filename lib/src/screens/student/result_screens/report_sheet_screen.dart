import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/check_result_page.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/enter_attendance_page.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/enter_score_page.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/next_term_begins_page.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/publish_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  static const String routeName = "/result_screen";
  final String spaceId;
  const ResultScreen({
    super.key,
    required this.spaceId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late List<_ResultTab> _availableTabs;
  late TabController _resultTabController;
  int _selectedIndex = 0;
  String userRole = '';

  @override
  void initState() {
    super.initState();

    final role =
        localStore.get('role', defaultValue: context.read<UserProvider>().role);
    _availableTabs = _getTabsForRole(role);
    userRole = role;

    Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
      context: context,
      alias: context.read<UserProvider>().alias,
    );

    // Initialize the tab controller with the correct length
    _resultTabController =
        TabController(length: _availableTabs.length, vsync: this);
  }

  List<_ResultTab> _getTabsForRole(String? role) {
    final allTabs = <_ResultTab>[
      _ResultTab('Enter Score', Icons.grid_on_sharp,
          () => EnterScorePage(spaceId: widget.spaceId)),
      _ResultTab(
          'Check Result',
          Icons.assignment_outlined,
          () => ResultPageView(
              resultTabController: TabController(length: 3, vsync: this))),
      _ResultTab('Publish Result', Icons.outbox_outlined,
          () => PublishResultPage(spaceId: widget.spaceId)),
      _ResultTab('Enter Attendance', Icons.note_alt_outlined,
          () => EnterAttendancePage(spaceId: widget.spaceId)),
      _ResultTab('Next Term Begins', Icons.note_alt_outlined,
          () => NextTermBeginsPage(spaceId: widget.spaceId)),
    ];

    if (role == 'admin') return allTabs;
    if (role == 'teacher') {
      return allTabs
          .where((tab) =>
              tab.title != 'Publish Result' && tab.title != 'Next Term Begins')
          .toList();
    }
    if (role == 'student') {
      return [
        _ResultTab('Check Result', Icons.assignment_outlined,
            () => StudentResultPage(spaceId: widget.spaceId))
      ];
    }
    return []; // fallback
  }

  @override
  void dispose() {
    _resultTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _availableTabs[_selectedIndex].title,
          style: setTextTheme(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            if (userRole != 'student')
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_availableTabs.length, (index) {
                    final tab = _availableTabs[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildCon(
                        onTap: () => setState(() => _selectedIndex = index),
                        icon: tab.icon,
                        content: tab.title,
                        isSelected: _selectedIndex == index,
                      ),
                    );
                  }),
                ),
              )
            else
              SizedBox.shrink(),
            SizedBox(height: 20.h),
            Expanded(child: _availableTabs[_selectedIndex].builder()),
          ],
        ),
      ),
    );
  }
}
// class _ResultScreenState extends State<ResultScreen>
//     with TickerProviderStateMixin {
//   late List<_ResultTab> _availableTabs;
//   late TabController _resultTabController;
//   int _selectedIndex = 0;
//   String userRole = '';

//   @override
//   void initState() {
//     super.initState();

//     final role =
//         localStore.get('role', defaultValue: context.read<UserProvider>().role);
//     _availableTabs = _getTabsForRole(role);
//     userRole = role;

//     Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
//       context: context,
//       alias: context.read<UserProvider>().alias,
//     );

//     // Initialize the tab controller with the correct length
//     _resultTabController =
//         TabController(length: _availableTabs.length, vsync: this);
//   }

//   List<_ResultTab> _getTabsForRole(String? role) {
//     final allTabs = <_ResultTab>[
//       _ResultTab('Enter Score', Icons.grid_on_sharp,
//           () => EnterScorePage(spaceId: widget.spaceId)),
//       _ResultTab(
//           'Check Result',
//           Icons.assignment_outlined,
//           () => ResultPageView(
//               resultTabController: TabController(length: 3, vsync: this))),
//       _ResultTab('Publish Result', Icons.outbox_outlined,
//           () => PublishResultPage(spaceId: widget.spaceId)),
//       _ResultTab('Enter Attendance', Icons.note_alt_outlined,
//           () => EnterAttendancePage(spaceId: widget.spaceId)),
//       _ResultTab('Next Term Begins', Icons.note_alt_outlined,
//           () => NextTermBeginsPage(spaceId: widget.spaceId)),
//     ];

//     if (role == 'admin') return allTabs;
//     if (role == 'teacher') {
//       return allTabs
//           .where((tab) =>
//               tab.title != 'Publish Result' && tab.title != 'Next Term Begins')
//           .toList();
//     }
//     if (role == 'student') {
//       return [
//         _ResultTab('Check Result', Icons.assignment_outlined,
//             () => StudentResultPage(spaceId: widget.spaceId))
//       ];
//     }
//     return []; // fallback
//   }

//   @override
//   void dispose() {
//     _resultTabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_availableTabs.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: Text("No Access")),
//         body: Center(
//           child: Text("You do not have access to view this page."),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           _availableTabs[_selectedIndex].title,
//           style: setTextTheme(fontSize: 24.sp),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(15.r),
//           child: Column(
//             children: [
//               if (userRole != 'student')
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(_availableTabs.length, (index) {
//                       final tab = _availableTabs[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: _buildCon(
//                           onTap: () => setState(() => _selectedIndex = index),
//                           icon: tab.icon,
//                           content: tab.title,
//                           isSelected: _selectedIndex == index,
//                         ),
//                       );
//                     }),
//                   ),
//                 )
//               else
//                 SizedBox.shrink(),
//               SizedBox(height: 20.h),
//               Expanded(child: _availableTabs[_selectedIndex].builder()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ResultTab {
  final String title;
  final IconData icon;
  final Widget Function() builder;

  _ResultTab(this.title, this.icon, this.builder);
}
// class _ResultScreenState extends State<ResultScreen>
//     with TickerProviderStateMixin {
//   late TabController _resultTabController;

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
//         context: context, alias: context.read<UserProvider>().alias);
//     _resultTabController = TabController(length: 3, vsync: this);
//     _resultTabController.addListener(() {
//       if (_resultTabController.index != 3) {
//         Provider.of<ResultProvider>(context, listen: false).setBroadToNull();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _resultTabController.dispose();
//     super.dispose();
//   }

//   String _getAppBarTitle(int index) {
//     switch (index) {
//       case 0:
//         return 'Enter Score';
//       case 1:
//         return 'Check Result';
//       case 2:
//         return 'Publish Result';
//       case 3:
//         return 'Enter Attendance';
//       case 4:
//         return 'Next Term Begins';
//       default:
//         return '';
//     }
//   }

//   Widget _buildPageContent(int index) {
//     switch (index) {
//       case 0:
//         return EnterScorePage(spaceId: widget.spaceId);
//       case 1:
//         return ResultPageView(
//           resultTabController: _resultTabController,
//         );

//       case 2:
//         return PublishResultPage(
//           spaceId: widget.spaceId,
//         );
//       case 3:
//         return EnterAttendancePage(
//           spaceId: widget.spaceId,
//         );
//       case 4:
//         return NextTermBeginsPage(
//           spaceId: widget.spaceId,
//         );
//       default:
//         return Container();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           _getAppBarTitle(_selectedIndex),
//           style: setTextTheme(
//             fontSize: 24.sp,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(15.r),
//           child: Column(
//             children: [
//               // only admin and teacher can see this
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildCon(
//                       onTap: () {
//                         setState(() => _selectedIndex = 0);
//                       },
//                       icon: Icons.grid_on_sharp,
//                       content: 'Enter Score',
//                       isSelected: _selectedIndex == 0,
//                     ),
//                     SizedBox(width: 10),
//                     _buildCon(
//                       onTap: () {
//                         setState(() => _selectedIndex = 1);
//                       },
//                       icon: Icons.assignment_outlined,
//                       content: 'Check Result',
//                       isSelected: _selectedIndex == 1,
//                     ),
//                     SizedBox(width: 10),
//                     _buildCon(
//                       onTap: () {
//                         setState(() => _selectedIndex = 2);
//                       },
//                       icon: Icons.outbox_outlined,
//                       content: 'Publish Result',
//                       isSelected: _selectedIndex == 2,
//                     ),
//                     SizedBox(width: 10),
//                     _buildCon(
//                       onTap: () {
//                         setState(() => _selectedIndex = 3);
//                       },
//                       icon: Icons.note_alt_outlined,
//                       content: 'Enter Attendance',
//                       isSelected: _selectedIndex == 3,
//                     ),
//                     SizedBox(width: 10),
//                     _buildCon(
//                       onTap: () {
//                         setState(() => _selectedIndex = 4);
//                       },
//                       icon: Icons.note_alt_outlined,
//                       content: 'Next Term Begins',
//                       isSelected: _selectedIndex == 4,
//                     ),
//                     // SizedBox(width: 10),
//                     // _buildCon(
//                     //   onTap: () {},
//                     //   content: 'More',
//                     // ),
//                     // SizedBox(width: 10),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Expanded(
//                 child: _buildPageContent(_selectedIndex),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

Widget _buildCon({
  required void Function() onTap,
  IconData? icon,
  required String content,
  bool isSelected = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: blueShades[0]),
        color: isSelected ? blueShades[0] : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: isSelected ? Colors.white : blueShades[0],
              size: 18.r,
            ),
          if (icon != null) SizedBox(width: 5.w),
          Text(
            content,
            style: setTextTheme(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : blueShades[0],
            ),
          )
        ],
      ),
    ),
  );
}
