import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/get_started_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/appbar_leading.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../utils/alert.dart';

class VerificationScreen extends StatelessWidget {
  final String email;

  static const String routeName = "/verificationscreen";

  const VerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Received a code?",
                style: setTextTheme(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // SizedBox(height: 5.h),
              Text(
                "We sent a verification code to",
                style: setTextTheme(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                // email,
                email,
                style: setTextTheme(
                  color: blueShades[1],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 30.h),
              PinCodeTextField(
                appContext: context,
                length: 5,
                controller: otpController,
                onChanged: (value) {},
                textStyle: setTextTheme(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: Colors.black,
                cursorHeight: 15.h,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                pinTheme: PinTheme(
                  fieldHeight: 40.h,
                  fieldWidth: 44.w,
                  activeFillColor: whiteShades[1],
                  inactiveFillColor: whiteShades[1],
                  selectedFillColor: whiteShades[1],
                  activeColor: whiteShades[1],
                  inactiveColor: whiteShades[1],
                  selectedColor: whiteShades[1],
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enableActiveFill: true,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    "Didn’t receive code?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.resendPasswordProvider(
                          email: email,
                          activity: 'email_verification'); // Pass user's email
                      if (authProvider.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("OTP resent successfully")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Failed to resend OTP. Try again later.")),
                        );
                      }
                    },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: blueShades[1],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              Consumer<AuthProvider>(
                builder: (context, authProvider, _) => Buttons(
                  text: authProvider.isLoading ? "Loading..." : 'Proceed',
                  isLoading: false,
                  onTap: () async {
                    String otp = otpController.text.trim();

                    if (otp.length != 5) {
                      Alert.displaySnackBar(context,
                          message: "Enter a valid OTP.");
                      return;
                    }

                    authProvider.verifyToken;

                    if (authProvider.isError) {
                      Alert.displaySnackBar(
                        context,
                        message: authProvider.errorResponse?.message ??
                            "Verification failed",
                      );
                    } else {
                      print(
                          "Verification Success: ${authProvider.successResponse?.data}");
                      context.go(ChooseSchool.routeName);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationResetScreen extends StatefulWidget {
  final String email;

  static const String routeName = "/verificationResetScreen";

  const VerificationResetScreen({super.key, required this.email});

  @override
  State<VerificationResetScreen> createState() =>
      _VerificationResetScreenState();
}

class _VerificationResetScreenState extends State<VerificationResetScreen> {
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, _) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Received a code?",
                  style: setTextTheme(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // SizedBox(height: 5.h),
                Text(
                  "We sent a verification code to",
                  style: setTextTheme(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  // email,
                  widget.email,
                  style: setTextTheme(
                    color: blueShades[1],
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30.h),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: pinController,
                  onChanged: (value) {},
                  textStyle: setTextTheme(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  cursorColor: Colors.black,
                  cursorHeight: 15.h,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  pinTheme: PinTheme(
                    fieldHeight: 40.h,
                    fieldWidth: 44.w,
                    activeFillColor: whiteShades[1],
                    inactiveFillColor: whiteShades[1],
                    selectedFillColor: whiteShades[1],
                    activeColor: whiteShades[1],
                    inactiveColor: whiteShades[1],
                    selectedColor: whiteShades[1],
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enableActiveFill: true,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "Didn’t receive code?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () async {
                        // Add resend functionality
                        await value.resendPasswordProvider(
                            email: widget.email, activity: "forgot_password");
                        if (value.isError) {
                          Alert.displaySnackBar(
                            context,
                            message:
                                value.errorResponse?.errors?.first.message ??
                                    "",
                          );
                        } else {
                          Alert.displaySnackBar(context,
                              message: "Verification resent successfully",
                              title: "Success");
                        }
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: blueShades[1],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Buttons(
                  text: 'Proceed',
                  isLoading: value.isLoading,
                  onTap: () async {
                    await value.verifyOtpPassword(
                        email: widget.email,
                        otp: pinController.text,
                        activity: "forgot_password");
                    if (value.isError) {
                      Alert.displaySnackBar(
                        context,
                        message:
                            value.errorResponse?.errors?.first.message ?? "",
                      );
                    } else {
                      context.push(ChangeForgottenPasswordScreen.routeName);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ChangeForgottenPasswordScreen extends StatefulWidget {
  const ChangeForgottenPasswordScreen({super.key});
  static const String routeName = "/change_forgotten_password_screen";

  @override
  State<ChangeForgottenPasswordScreen> createState() =>
      _ChangeForgottenPasswordScreenState();
}

class _ChangeForgottenPasswordScreenState
    extends State<ChangeForgottenPasswordScreen> {
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: Consumer<AuthProvider>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Password',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: !_oldPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: whiteShades[1],
                        filled: true,
                        hintText: '********',
                        hintStyle: setTextTheme(
                          color: whiteShades[3],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _oldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: whiteShades[3],
                          ),
                          onPressed: () {
                            setState(() {
                              _oldPasswordVisible = !_oldPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please provide your password";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Confirm Password',
                      style: setTextTheme(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: !_newPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: whiteShades[1],
                        filled: true,
                        hintText: '********',
                        hintStyle: setTextTheme(
                          color: whiteShades[3],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: whiteShades[3],
                          ),
                          onPressed: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please provide your password";
                        }
                        if (value != oldPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    Buttons(
                      text: 'Change Password',
                      isLoading: value.isLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          print('Form Validated!');
                          var success = await value.changePassword(
                              password: newPasswordController.text);
                          if (success) {
                            Alert.displaySnackBar(
                              context,
                              message: "Password changed Successfully",
                              title: 'Success',
                            );
                            context.push(SignInScreen.routeName);
                          } else {
                            Alert.displaySnackBar(
                              context,
                              message: value.errorResponse?.message ??
                                  "Failed to change password",
                            );
                          }
                        }
                      },
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
// class ChangeForgottenPasswordScreen extends StatefulWidget {
//   const ChangeForgottenPasswordScreen({super.key});
//   static const String routeName = "/change_forgotten_password_screen";

//   @override
//   State<ChangeForgottenPasswordScreen> createState() =>
//       _ChangeForgottenPasswordScreenState();
// }

// class _ChangeForgottenPasswordScreenState
//     extends State<ChangeForgottenPasswordScreen> {
//   bool _oldPasswordVisible = false;
//   bool _newPasswordVisible = false;
//   final TextEditingController? oldPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Change Password',
//           style: setTextTheme(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: customAppBarLeadingIcon(context),
//         centerTitle: false,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Consumer<AuthProvider>(builder: (context, value, _) {
//           return SingleChildScrollView(
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 15.w,
//                   vertical: 40.h,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'New Password',
//                       style: setTextTheme(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//                     TextFormField(
//                       controller: oldPasswordController,
//                       obscureText: _oldPasswordVisible,
//                       decoration: InputDecoration(
//                         fillColor: whiteShades[1],
//                         filled: true,
//                         hintText: '********',
//                         hintStyle: setTextTheme(
//                           color: whiteShades[3],
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _oldPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: whiteShades[3],
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _oldPasswordVisible = !_oldPasswordVisible;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.text,
//                       validator: (value) {
//                         if (value == null) {
//                           return "Please provide your password";
//                         }

//                         return "";
//                       },
//                     ),
//                     SizedBox(height: 15.h),
//                     Text(
//                       'Confirm Password',
//                       style: setTextTheme(
//                           fontSize: 14.sp, fontWeight: FontWeight.w700),
//                     ),
//                     SizedBox(height: 5.h),
//                     TextFormField(
//                       controller: newPasswordController,
//                       obscureText: _newPasswordVisible,
//                       decoration: InputDecoration(
//                         fillColor: whiteShades[1],
//                         filled: true,
//                         hintText: '********',
//                         hintStyle: setTextTheme(
//                           color: whiteShades[3],
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _newPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: whiteShades[3],
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _newPasswordVisible = !_newPasswordVisible;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.text,
//                       validator: (value) {
//                         if (value == null) {
//                           return "Please provide your password";
//                         }
//                         if (value != oldPasswordController!.text) {
//                           return "Password must be same ";
//                         }
//                         return "";
//                       },
//                     ),
//                     SizedBox(height: 30.h),
//                     Buttons(
//                       text: 'Change Password',
//                       isLoading: value.isLoading,
//                       onTap: () async {
//                         print('my data');
//                         // if (_formKey.currentState!.validate()) {
//                         print('Form Validated!');
//                         var v = await value.changePassword(
//                             password: newPasswordController.text);
//                         if (v) {
//                           Alert.displaySnackBar(
//                             context,
//                             message: "Password changed Successfully",
//                             title: 'Success',
//                           );
//                           context.push(SignInScreen.routeName);
//                         } else {
//                           Alert.displaySnackBar(
//                             context,
//                             message: value.errorResponse?.message,
//                           );
//                         }
//                         // } else {
//                         //   print('Form Validation Failed');
//                         //   // You can also print the error messages from the form fields if needed
//                         //   _formKey.currentState!
//                         //       .validate(); // This will trigger the error messages to show up
//                         // }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
