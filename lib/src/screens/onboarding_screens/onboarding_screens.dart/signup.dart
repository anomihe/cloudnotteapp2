import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/otp.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = "/signUpscreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController? passwordController = TextEditingController();
  final TextEditingController? emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create an account",
                  style: setTextTheme(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                // Buttons(
                //   onTap: () {},
                //   isLoading: false,
                //   borderRadius: BorderRadius.circular(100),
                //   boxColor: Colors.transparent,
                //   border: Border.all(color: whiteShades[1]),
                //   text: 'Continue with Google',
                //   fontSize: 14.sp,
                //   textColor: Colors.black,
                //   prefixIcon: SvgPicture.asset(
                //     'assets/icons/google_logo.svg',
                //   ),
                // ),
                // SizedBox(height: 3.h),
                // Buttons(
                //   onTap: () {},
                //   isLoading: false,
                //   borderRadius: BorderRadius.circular(100),
                //   boxColor: Colors.transparent,
                //   border: Border.all(color: whiteShades[1]),
                //   text: 'Continue with Apple',
                //   fontSize: 14.sp,
                //   textColor: Colors.black,
                //   prefixIcon: SvgPicture.asset(
                //     'assets/icons/apple_logo.svg',
                //   ),
                // ),
                // SizedBox(height: 15.h),
                // Align(
                //   alignment: Alignment.center,
                //   child: Text(
                //     "or",
                //     style: setTextTheme(
                //       fontSize: 24.sp,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  text: 'First name',
                  hintText: 'Ugo',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  text: 'Last name',
                  hintText: 'Matt',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Phone Number',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomIntlPhoneField(
                  hintText: '000 000 000',
                  initialCountryCode: 'NG',
                ),
                SizedBox(height: 15.h),
                // Email Input
                CustomTextFormField(
                  text: 'Email or Username',
                  hintText: 'email or username',
                  keyboardType: TextInputType.text,
                  controller: emailController,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  text: 'Password',
                  hintText: '********',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: whiteShades[3],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  controller: passwordController,
                  obscureText: _isPasswordVisible,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),

                // Confirm Password Input
                SizedBox(height: 15.h),
                CustomTextFormField(
                  text: 'Confirm Password',
                  hintText: '********',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: whiteShades[3],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  controller: passwordController,
                  obscureText: _isPasswordVisible,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 30.h),
                // Sign Up Button
                Buttons(
                  text: 'Sign Up',
                  isLoading: false,
                  onTap: () {
                    context.push(VerificationScreen.routeName,
                        extra: emailController?.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
