import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/join_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/image_picker.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String routeName = "/WelcomeScreen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(),
                Text(
                  "Welcome Ugo",
                  style: setTextTheme(
                    color: redShades[1],
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //  SizedBox(height: 10.h),
                Text(
                  "Let's get to know you better",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 25.h),
                // Reusable Image Picker with ClipOval
                Center(
                  child: ImagePickerWidget(
                    radius: 45,
                    placeholderAsset: 'assets/app/Ellipse 14.png',
                    onImageSelected: (image) {
                      // print("Image selected: ${image?.path}");
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Gender",
                  style: setTextTheme(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  items: ["Male", "Female", "Other"]
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
                  hint: Text('Select gender'),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteShades[1],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Date of Birth",
                  style: setTextTheme(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteShades[1],
                    hintText: "17-07-2000",
                    hintStyle: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteShades[3]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                // CSCPicker(
                //   layout: Layout.vertical,
                //   showStates: true,
                //   showCities: true,
                //   flagState: CountryFlag.DISABLE,
                //   dropdownDecoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(10.r)),
                //       color: whiteShades[1],
                //       border: Border.all(color: whiteShades[1], width: 1)),
                //   disabledDropdownDecoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(10.r)),
                //     color: whiteShades[1],
                //   ),
                //   countrySearchPlaceholder: "Country",
                //   stateSearchPlaceholder: "State",
                //   citySearchPlaceholder: "City",
                //   countryDropdownLabel: "Country",
                //   stateDropdownLabel: "State",
                //   cityDropdownLabel: "City",
                //   selectedItemStyle: setTextTheme(
                //     fontSize: 14.sp,
                //   ),
                //   dropdownHeadingStyle: setTextTheme(
                //       fontSize: 17.sp, fontWeight: FontWeight.bold),
                //   dropdownItemStyle: TextStyle(
                //     fontSize: 14.sp,
                //   ),
                //   dropdownDialogRadius: 10.0.r,
                //   searchBarRadius: 10.0.r,
                //   onCountryChanged: (value) {
                //     setState(() {
                //       countryValue = value;
                //     });
                //   },
                //   onStateChanged: (value) {
                //     setState(() {
                //       stateValue = value!;
                //     });
                //   },
                //   onCityChanged: (value) {
                //     setState(() {
                //       cityValue = value!;
                //     });
                //   },
                // ),
                SizedBox(height: 20.h),
                const CustomTextFormField(
                  text: 'Address',
                  hintText: 'Enter your address',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                Buttons(
                  text: 'Update Profile',
                  isLoading: false,
                  onTap: () {
                    context.push(JoinScreen.routeName);
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

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});
//   static const String routeName = "/WelcomeScreen";

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   String countryValue = "";
//   String stateValue = "";
//   String cityValue = "";
//   String address = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 50.h,
//               ),
//               Text(
//                 "Welcome Ugo",
//                 style: setTextTheme(
//                   color: redShades[1],
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Let's get to know you better",
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Center(
//                 child: ClipOval(
//                   child: Image.asset(
//                     'assets/app/Ellipse 14.png',
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Gender",
//                 style: setTextTheme(fontSize: 14.sp),
//               ),
//               DropdownButtonFormField<String>(
//                 items: ["Male", "Female", "Other"]
//                     .map(
//                       (gender) => DropdownMenuItem(
//                         value: gender,
//                         child: Text(gender),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: (value) {},
//                 decoration: const InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFF1F1F1),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Date of Birth",
//                 style: setTextTheme(fontSize: 14.sp),
//               ),
//               TextFormField(
//                 initialValue: "17-07-2000",
//                 decoration: const InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFF1F1F1),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               CSCPicker(
//                 layout: Layout.vertical,
//                 showStates: true,
//                 showCities: true,
//                 flagState: CountryFlag.DISABLE,
//                 dropdownDecoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                     color: const Color(0xFFF1F1F1),
//                     border: Border.all(color: whiteShades[1], width: 1)),
//                 disabledDropdownDecoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   color: whiteShades[1],
//                 ),
//                 countrySearchPlaceholder: "Country",
//                 stateSearchPlaceholder: "State",
//                 citySearchPlaceholder: "City",
//                 countryDropdownLabel: "Country",
//                 stateDropdownLabel: "State",
//                 cityDropdownLabel: "City",
//                 selectedItemStyle: setTextTheme(
//                   color: Colors.black,
//                   fontSize: 14,
//                 ),
//                 dropdownHeadingStyle: setTextTheme(
//                     color: Colors.black,
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold),
//                 dropdownItemStyle: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                 ),
//                 dropdownDialogRadius: 10.0,
//                 searchBarRadius: 10.0,
//                 onCountryChanged: (value) {
//                   setState(() {
//                     countryValue = value;
//                   });
//                 },
//                 onStateChanged: (value) {
//                   setState(() {
//                     stateValue = value!;
//                   });
//                 },
//                 onCityChanged: (value) {
//                   setState(() {
//                     cityValue = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               const Components(
//                 text: 'Adress',
//                 hintText: 'email@mail.com',
//                 type: TextInputType.text,
//               ),
//               const SizedBox(height: 24),
//               Buttons(
//                 board: 'Update Profile',
//                 isLoading: false,
//                 onTap: () {
//                   context.go(JoinScreen.routeName);
//                 },
//               ),
//               const SizedBox(
//                 height: 10,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
