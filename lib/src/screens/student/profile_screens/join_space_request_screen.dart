import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../config/themes.dart';


class JoinSpaceRequestScreen extends StatefulWidget {
  const JoinSpaceRequestScreen({super.key});
  static const routeName = '/join_space_request';

  @override
  State<JoinSpaceRequestScreen> createState() => _JoinSpaceRequestScreenState();
}

class _JoinSpaceRequestScreenState extends State<JoinSpaceRequestScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Defer the API call to after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Fetch data only if the widget is still mounted
        _fetchData();
      }
    
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    await Provider.of<UserProvider>(context, listen: false)
        .getInvite(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Space Request',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, _) {
          // Handle the initial state
          if (value.isLoading ) {
            _isInitialized = true;
            // Trigger fetch if not already loading
            // _fetchData();
            return const Center(child: CircularProgressIndicator());
          }

          // Handle loading state
          if (value.isLoading) {
            return SkeletonListView(itemCount: 10);
          }

          // // Handle error state
          // if (value.isError) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Failed to load space requests',
          //           style: setTextTheme(
          //             fontSize: 16.sp,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //         SizedBox(height: 16.h),
          //         ElevatedButton(
          //           onPressed: _fetchData,
          //           child: Text('Retry'),
          //         ),
          //       ],
          //     ),
          //   );
          // }

          // Handle empty state
          if (value.invitations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/app/paparazi_image_a.png'),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "No space requests",
                      style: setTextTheme(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          // Handle data state
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'You have ${value.invitations.length} new space requests',
                          style: setTextTheme(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Handle add action here
                          },
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: blueShades[3],
                            child: SvgPicture.asset(
                              'assets/icons/+.svg',
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ListView.builder(
                      itemCount: value.invitations.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final space = value.invitations[index];
                        return RequestWidget(invitation: space);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// class JoinSpaceRequestScreen extends StatefulWidget {
//   const JoinSpaceRequestScreen({super.key});
//   static const routeName = '/join_space_request';

//   @override
//   State<JoinSpaceRequestScreen> createState() => _JoinSpaceRequestScreenState();
// }

// class _JoinSpaceRequestScreenState extends State<JoinSpaceRequestScreen> {
//   @override 
//   void initState() {
//     super.initState();
//     Provider.of<UserProvider>(context, listen: false).getInvite(context:context);
//   }
//   @override
//   Widget build(BuildContext context) {
  
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Join Space Request',
//           style: setTextTheme(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: customAppBarLeadingIcon(context),
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context,value,_) {
//           if(value.isLoading) {
//                return SkeletonListView(itemCount: 10,);
//           }
//           if(value.invitations.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/app/paparazi_image_a.png'),
//                   SizedBox(height: 60.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40.w),
//                     child: Text(
//                       "No space requests",
//                       style: setTextTheme(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
                 
//                 ],
//               ),
//             );
//           }
//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(16.r),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'You have ${value.invitations.length} new space requests',
//                           style: setTextTheme(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                             // color: blueShades[2],
//                           ),
//                         ),
//                         Spacer(),
//                         CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: blueShades[3],
//                           child: SvgPicture.asset(
//                             'assets/icons/+.svg',
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//                     ListView.builder(
//                       itemCount: value.invitations.length,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final space = value.invitations[index];
//                         return RequestWidget(invitation: space);
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       ),
//     );
//   }
// }
