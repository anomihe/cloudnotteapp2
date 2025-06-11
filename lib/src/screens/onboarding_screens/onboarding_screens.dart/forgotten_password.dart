import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/otp.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/auth_provider.dart';

class ForgottenPasswordScreen extends StatelessWidget {
  const ForgottenPasswordScreen({super.key});
  static const String routeName = "/forgottenpasswordscreen";

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final form = GlobalKey<FormState>();

    return Form(
      key: form,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "Forgotten Password",
            style: setTextTheme(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Row(
            children: [customAppBarLeadingIcon(context)],
          ),
        ),
        body: Consumer<AuthProvider>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    Text(
                      "We will send a verification code to you",
                      style: setTextTheme(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFormField(
                      text: 'Enter your email or username',
                      hintText: "email or username",
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/person_icon.svg',
                        fit: BoxFit.none,
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.infinity,
                      child: Buttons(
                        text: 'Get code',
                        isLoading: value.isLoading,
                        onTap: () async {
                          if (form.currentState!.validate()) {
                            var isTrue = await value
                                .resetPasswordProvider(emailController.text);
                            log('is data $isTrue');
                            if (isTrue) {
                              Alert.displaySnackBar(context,
                                  message:
                                      'verification code sent to your email',
                                  title: 'Success');
                              context.push(VerificationResetScreen.routeName,
                                  extra: emailController.text);
                            } else {
                              Alert.displaySnackBar(
                                context,
                                message: 'User not found',
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
