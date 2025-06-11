// ignore_for_file: use_build_context_synchronously

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../components/global_widgets/appbar_leading.dart';
import '../../../components/shared_widget/general_button.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../utils/alert.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String routeName = "/change_password_screen";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  final TextEditingController? oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

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
      body: Consumer<AuthProvider>(builder: (context, value, _) {
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
                  CustomTextFormField(
                    controller: oldPasswordController,
                    obscureText: _oldPasswordVisible,
                    text: 'Old Password',
                    hintText: '********',
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
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return "Please provide your password";
                      }
                      return "";
                    },
                  ),
                  SizedBox(height: 15.h),
                  CustomTextFormField(
                    controller: newPasswordController,
                    obscureText: _newPasswordVisible,
                    text: 'New Password',
                    hintText: '********',
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
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return "Please provide your password";
                      }
                      return "";
                    },
                  ),
                  SizedBox(height: 30.h),
                  Buttons(
                    text: 'Update Password',
                    isLoading: false,
                    onTap: () async {
                      var v = await value
                          .changePasswordSpaceLevel(newPasswordController.text);
                      if (v) {
                        Alert.displaySnackBar(
                          context,
                          message: "Password changed Successfully",
                        );
                      } else {
                        Alert.displaySnackBar(
                          context,
                          message: "Unable to change password",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}






// TextFormField(
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   labelStyle: TextStyle(
//                     color: Colors.grey.shade700,
//                   ),
//                   hintText: "********",
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey.shade700,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide(color: redShades[1]),
//                   ),
//                 ),
//               ),