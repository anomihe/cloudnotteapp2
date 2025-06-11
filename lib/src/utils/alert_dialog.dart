import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AppCustomDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final String action1;
//   final String action2;
//   final void Function() action1Function;
//   final void Function() action2Function;

//   const AppCustomDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.action1,
//     required this.action2,
//     required this.action1Function,
//     required this.action2Function,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(content),
//       actions: <Widget>[
//         TextButton(
//           onPressed: action1Function,
//           child: Text(action1),
//         ),
//         TextButton(
//           onPressed: action2Function,
//           child: Text(action2),
//         ),
//       ],
//     );
//   }
// }

// void showAppCustomDialog(
//     BuildContext context,
//     String title,
//     String content,
//     String action1,
//     String action2,
//     void Function() action1Function,
//     void Function() action2Function) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AppCustomDialog(
//         title: title,
//         content: content,
//         action1: action1,
//         action2: action2,
//         action1Function: action1Function,
//         action2Function: action2Function,
//       );
//     },
//   );
// }

void appCustomDialog(
    {required BuildContext context,
    required String title,
    String? content,
    required String action1,
    required String action2,
    required void Function() action1Function,
    required void Function() action2Function}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: setTextTheme(
            fontSize: 22.sp,
          ),
        ),
        content: content != null
            ? Text(
                content,
                style: setTextTheme(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        actions: <Widget>[
          TextButton(
            onPressed: action1Function,
            child: Text(
              action1,
              style: setTextTheme(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: action2Function,
            child: Text(
              action2,
              style: setTextTheme(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}
void appCustomDialogTwo({
  required BuildContext context,
  required String title,
  String? content,
  required String action1,
  required String action2,
  required void Function(BuildContext dialogContext) action1Function,
  required void Function(BuildContext dialogContext) action2Function,
}) {
  showDialog(
    context: context,
      useRootNavigator: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          style: setTextTheme(fontSize: 22.sp),
        ),
        content: content != null
            ? Text(
                content,
                style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w500),
              )
            : null,
        actions: <Widget>[
          TextButton(
            onPressed: () => action1Function(dialogContext),
            child: Text(
              action1,
              style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => action2Function(dialogContext),
            child: Text(
              action2,
              style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    },
  );
}

void appCustomDialogThree({
  required BuildContext context,
  required String title,
  Widget? content,
  required String action1,
  required String action2,
  required void Function(BuildContext dialogContext) action1Function,
  required void Function(BuildContext dialogContext) action2Function,
}) {
  showDialog(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          style: setTextTheme(fontSize: 22.sp),
        ),
        content: content, 
        actions: <Widget>[
          TextButton(
            onPressed: () => action1Function(dialogContext),
            child: Text(
              action1,
              style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => action2Function(dialogContext),
            child: Text(
              action2,
              style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    },
  );
}
