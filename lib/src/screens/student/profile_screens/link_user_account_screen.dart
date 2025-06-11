import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/link_new_user_account_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/themes.dart';

class LinkUserAccountScreen extends StatefulWidget {
  const LinkUserAccountScreen({super.key});
  static const routeName = '/link_user_account';

  @override
  State<LinkUserAccountScreen> createState() => _LinkUserAccountScreenState();
}

class _LinkUserAccountScreenState extends State<LinkUserAccountScreen> {
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    // Fetch data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    await Provider.of<UserProvider>(context, listen: false)
        .getSpaceLinkRequests(context: context);
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Defer the API call to after the first frame is rendered
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     _fetchData();
  //   });
  // }

  // Future<void> _fetchData() async {
  //   if (!mounted) return;
  //   await Provider.of<UserProvider>(context, listen: false)
  //       .getSpaceLinkRequests(context: context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Link User Account',
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
          if (value.isLoading) {
            _isInitialized = true;
            // Trigger fetch if not already loading
            // _fetchData();
            return const Center(child: CircularProgressIndicator());
          }

          // Handle loading state
          if (value.isLoading) {
            return SkeletonListView(itemCount: 5);
          }

         

          final linkRequests = value.linkRequests;

          if (linkRequests.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'You have ${linkRequests.length} new account linking requests',
                        style: setTextTheme(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.push(LinkNewUserAccountScreen.routeName);
                        },
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: blueShades[3],
                          child: SvgPicture.asset('assets/icons/+.svg'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/app/paparazi_image_a.png'),
                        SizedBox(height: 20.h),
                        Text(
                          'No space requests',
                          style: setTextTheme(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: linkRequests.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  children: [
                    Text(
                      'You have ${linkRequests.length} new account linking requests',
                      style: setTextTheme(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.push(LinkNewUserAccountScreen.routeName);
                      },
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: blueShades[3],
                        child: SvgPicture.asset('assets/icons/+.svg'),
                      ),
                    )
                  ],
                );
              }

              final invitation = linkRequests[index - 1];
              return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: LinkWidget(invitation: invitation),
              );
            },
          );
        },
      ),
    );
  }
}
// class LinkUserAccountScreen extends StatefulWidget {
//   const LinkUserAccountScreen({super.key});
//   static const routeName = '/link_user_account';

//   @override
//   State<LinkUserAccountScreen> createState() => _LinkUserAccountScreenState();
// }

// class _LinkUserAccountScreenState extends State<LinkUserAccountScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<UserProvider>(context, listen: false)
//         .getSpaceLinkRequests(context: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Link User Account',
//           style: setTextTheme(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: customAppBarLeadingIcon(context),
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, value, _) {
//           if (value.isLoading) {
//             return SkeletonListView(itemCount: 5);
//           }

//           final linkRequests = value.linkRequests;

//           if (linkRequests.isEmpty) {
//             return Padding(
//               padding: EdgeInsets.all(16.r),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'You have ${linkRequests.length} new account linking requests',
//                         style: setTextTheme(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           context.push(LinkNewUserAccountScreen.routeName);
//                         },
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: blueShades[3],
//                           child: SvgPicture.asset('assets/icons/+.svg'),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   Center(
//                     child: Column(
//                       children: [
//                         Image.asset('assets/app/paparazi_image_a.png'),
//                         SizedBox(height: 20.h),
//                         Text(
//                           'No space requests',
//                           style: setTextTheme(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: EdgeInsets.all(16.r),
//             itemCount: linkRequests.length + 1,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return Row(
//                   children: [
//                     Text(
//                       'You have ${linkRequests.length} new account linking requests',
//                       style: setTextTheme(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     Spacer(),
//                     GestureDetector(
//                       onTap: () {
//                         context.push(LinkNewUserAccountScreen.routeName);
//                       },
//                       child: CircleAvatar(
//                         radius: 15.r,
//                         backgroundColor: blueShades[3],
//                         child: SvgPicture.asset('assets/icons/+.svg'),
//                       ),
//                     )
//                   ],
//                 );
//               }

//               final invitation = linkRequests[index - 1];
//               return Padding(
//                 padding: EdgeInsets.only(top: 10.h),
//                 child: LinkWidget(invitation: invitation),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// class _LinkUserAccountScreenState extends State<LinkUserAccountScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<UserProvider>(context, listen: false).getSpaceLinkRequests(context:context);
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Link User Account',
//           style: setTextTheme(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: customAppBarLeadingIcon(context),
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, value,_) {
//           if(value.isLoading) {
//             return SkeletonListView(itemCount: 5,);
          
//           }
//           if(value.linkRequests.isEmpty) {
//             return Padding(
//               padding: EdgeInsets.all(16),
//               // padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).padding.vertical * 0.6, horizontal: MediaQuery.of(context).padding.horizontal * 0.1),
//               child: Column(
//                 children: [
//                      Row(
//                         children: [
//                           Text(
//                             'You have ${value.linkRequests.length} new account linking requests',
//                             style: setTextTheme(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w400,
//                               // color: blueShades[2],
//                             ),
//                           ),
//                           Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               context.push(LinkNewUserAccountScreen.routeName);
//                             },
//                             child: CircleAvatar(
//                               radius: 15.r,
//                               backgroundColor: blueShades[3],
//                               child: SvgPicture.asset(
//                                 'assets/icons/+.svg',
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                   Center(
//                     child: Column(
//                       children: [
//                         Image.asset('assets/app/paparazi_image_a.png'), 
//                         SizedBox(height: 20.h),
//                         Text(
//                           'No space requests',
//                           style: setTextTheme(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
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
//                           'You have ${value.linkRequests.length} new account linking requests',
//                           style: setTextTheme(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                             // color: blueShades[2],
//                           ),
//                         ),
//                         Spacer(),
//                         GestureDetector(
//                           onTap: () {
//                             context.push(LinkNewUserAccountScreen.routeName);
//                           },
//                           child: CircleAvatar(
//                             radius: 15.r,
//                             backgroundColor: blueShades[3],
//                             child: SvgPicture.asset(
//                               'assets/icons/+.svg',
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//                     ListView.builder(
//                       itemCount: value.linkRequests.length,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final invitation = value.linkRequests[index];
//                         return LinkWidget(invitation: invitation,);
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
