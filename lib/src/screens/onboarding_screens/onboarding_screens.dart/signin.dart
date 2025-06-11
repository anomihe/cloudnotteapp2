// ignore_for_file: use_build_context_synchronously

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/service/google_service.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/auth_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/forgotten_password.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/otp.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/signup.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../components/shared_widget/general_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = "/signinscreen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = true;
  final TextEditingController? passwordController = TextEditingController();
  final TextEditingController? emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: whiteShades[0],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Image.asset(scale: 2, 'assets/app/cloudnotte_logo_two.png'),
                    const SizedBox(width: 5),
                    Image.asset(
                      scale: 1.5,
                      'assets/app/cloudnotte_logo_one.png',
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Title
                Text(
                  "Sign in",
                  style: setTextTheme(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        text: 'Email or User ID',
                        hintText: 'email@mail.com',
                        keyboardType: TextInputType.text,
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/person_icon.svg',
                          fit: BoxFit.none,
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null) {
                            return "Please provide your Email or User ID";
                          }
                          return "";
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        controller: passwordController,
                        obscureText: _isPasswordVisible,
                        maxLines: 1,
                        rowText: 'Password',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/password_icon.svg',
                          fit: BoxFit.none,
                        ),
                        rowWidget: GestureDetector(
                          onTap: () {
                            context.push(ForgottenPasswordScreen.routeName);
                          },
                          child: Text(
                            "Forgot password?",
                            // style: 14.sp.w700.color(redShades[4]).textTheme(),
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: redShades[1],
                            ),
                          ),
                        ),
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) {
                            return "Please provide your password";
                          }
                          return "";
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text("Don’t have an account? ", style: setTextTheme()),
                    GestureDetector(
                      onTap: () {
                        context.push(SignUpScreen.routeName);
                      },
                      child: Text(
                        "Sign up",
                        // style: 14
                        //     .sp
                        //     .w700
                        //     .decoration(TextDecoration.underline)
                        //     .color(redShades[4])
                        //     .textTheme(),
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: redShades[1],
                          decoration: TextDecoration.underline,
                          decorationColor: redShades[1],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Sign In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) => Buttons(
                    text: authProvider.isLoading ? "Loading..." : 'Sign In',
                    isLoading: false,
                    boxColor: blueShades[0],
                    onTap: () async {
                      // if (!_formKey.currentState!.validate()) return;
                      await authProvider.signIn(
                        email: emailController?.text.trim() ?? "",
                        password: passwordController?.text.trim() ?? "",
                      );
                      if (authProvider.isError) {
                        Alert.displaySnackBar(
                          context,
                          message: authProvider.errorResponse?.message ?? "",
                        );
                      } else {
                        context.push(AuthScreen.routeName);
                        //                 if (authProvider.loginResponse?.isVerified == true) {
                        //   context.push(ChooseSchool.routeName);
                        // } else {
                        //   context.push(
                        //     VerificationScreen.routeName,
                        //     extra: emailController?.text ?? "",
                        //   );
                        // }
                      }
                    },
                  ),
                ),

                SizedBox(height: 30.h),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Buttons(
                      onTap: () async {
                        // await authProvider.googleSignIn();
                        // if (authProvider.isError) {
                        //   Alert.displaySnackBar(
                        //     context,
                        //     message: authProvider.errorResponse?.message ?? "",
                        //   );
                        // } else {
                        //   context.push(AuthScreen.routeName);
                        // }
                      },
                      isLoading: false,
                      borderRadius: BorderRadius.circular(100),
                      boxColor: Colors.transparent,
                      border: Border.all(color: whiteShades[1]),
                      text: authProvider.isLoadingStateTwo
                          ? "Loading..."
                          : 'Continue with Google',
                      textColor: ThemeProvider().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14.sp,
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/google_logo.svg',
                      ),
                    );
                  },
                ),
                // SizedBox(height: 3.h),
                // Buttons(
                //   onTap: () {},
                //   isLoading: false,
                //   borderRadius: BorderRadius.circular(100),
                //   boxColor: Colors.transparent,
                //   border: Border.all(color: whiteShades[1]),
                //   text: 'Continue with Apple',
                //   textColor:
                //       ThemeProvider().isDarkMode ? Colors.white : Colors.black,
                //   fontSize: 14.sp,
                //   prefixIcon: SvgPicture.asset(
                //     'assets/icons/apple_logo.svg',
                //     colorFilter: ColorFilter.mode(
                //       ThemeProvider().isDarkMode ? Colors.white : Colors.black,
                //       BlendMode.srcIn,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
