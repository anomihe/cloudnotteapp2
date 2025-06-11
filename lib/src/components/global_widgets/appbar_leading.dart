import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';




customAppBarLeadingIcon(BuildContext context, {Color? color}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return IconButton(
    onPressed: () {
      context.pop();
      // context.push(StudentLandingScreen.routeName, extra: {
      //   'id': context.read<UserProvider>().spaceId,
      //   'provider': context.read<UserProvider>(),
      //   "currentIndex": 0,
      // });
    },
    icon: Icon(
      Icons.arrow_back_ios_new_rounded,
      color: themeProvider.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}
