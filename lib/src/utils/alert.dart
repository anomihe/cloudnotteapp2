import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Alert {
  static void hideDialog(context) {
    Navigator.pop(context);
    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => Navigator.popUntil(context, (route) => route.isFirst));
  }

  static void showLoading(context) => showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        useSafeArea: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: blueShades[0],
            ),
          );
        },
      );

  static void displaySnackBar(
    context, {
    String? message,
    String title = 'Error',
    Function()? press,
    bool persist = false,
  }) =>
      showTopSnackBar(
        Overlay.of(context),
        title.contains('Success')
            ? CustomSnackBar.success(
                message: message!,
              )
            : title.contains('Info')
                ? CustomSnackBar.info(
                    message: message!,
                  )
                : CustomSnackBar.error(
                    message: message!,
                  ),
        persistent: persist,
        onTap: press,
      );
}
