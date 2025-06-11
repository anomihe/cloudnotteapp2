import 'package:cloudnottapp2/src/screens/onboarding_screens/create_school_screens/view_school.dart';
// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes.dart';
import '../../../components/shared_widget/general_button.dart';
import '../widgets/text_field_widget.dart';

class CompleteSetUp extends StatefulWidget {
  static const String routeName = "/completesetup";

  const CompleteSetUp({super.key});

  @override
  State<CompleteSetUp> createState() => _CompleteSetUpState();
}

class _CompleteSetUpState extends State<CompleteSetUp> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteShades[0],
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        Text(
                          'Create School',
                          style: setTextTheme(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: redShades[1],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const CustomTextFormField(
                          text: 'School Name',
                          hintText: '',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        const CustomTextFormField(
                          text: 'School description',
                          hintText: 'Enter school description',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "School type",
                          style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        DropdownButtonFormField<String>(
                          items: ["Private", "Public", "International"]
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF1F1F1),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // CSCPicker(
                        //   layout: Layout.vertical,
                        //   showStates: true,
                        //   showCities: true,
                        //   flagState: CountryFlag.DISABLE,
                        //   dropdownDecoration: BoxDecoration(
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10)),
                        //       color: whiteShades[1],
                        //       border:
                        //           Border.all(color: whiteShades[1], width: 1)),
                        //   disabledDropdownDecoration: BoxDecoration(
                        //     borderRadius:
                        //         const BorderRadius.all(Radius.circular(10)),
                        //     color: whiteShades[1],
                        //   ),
                        //   countrySearchPlaceholder: "Country",
                        //   stateSearchPlaceholder: "State",
                        //   citySearchPlaceholder: "City",
                        //   countryDropdownLabel: "Country",
                        //   stateDropdownLabel: "State",
                        //   cityDropdownLabel: "City",
                        //   selectedItemStyle: setTextTheme(
                        //     color: Colors.black,
                        //     fontSize: 14.sp,
                        //   ),
                        //   dropdownHeadingStyle: setTextTheme(
                        //       color: Colors.black,
                        //       fontSize: 14.sp,
                        //       fontWeight: FontWeight.bold),
                        //   dropdownItemStyle: setTextTheme(
                        //     color: Colors.black,
                        //     fontSize: 14.sp,
                        //   ),
                        //   dropdownDialogRadius: 10.0,
                        //   searchBarRadius: 10.0,
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
                        const SizedBox(height: 50),
                        Buttons(
                          text: 'Complete school setup',
                          isLoading: false,
                          onTap: () {
                            context.go(ViewSchool.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class CompleteSetUp extends StatefulWidget {
//   static const String routeName = "/completesetup";

//   const CompleteSetUp({super.key});

//   @override
//   State<CompleteSetUp> createState() => _CompleteSetUpState();
// }

// class _CompleteSetUpState extends State<CompleteSetUp> {
//   String countryValue = "";
//   String stateValue = "";
//   String cityValue = "";
//   String schoolName = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: whiteShades[0],
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Back button
//             Padding(
//               padding: const EdgeInsets.only(top: 40.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     'Create School',
//                     style: setTextTheme(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w700,
//                       color: redShades[1],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // const SizedBox(height: 16),
//                     const SizedBox(height: 15),
//                     const Components(
//                       text: 'School Name',
//                       hintText: '',
//                       type: TextInputType.text,
//                     ),
//                     const SizedBox(height: 16),
//                     const Components(
//                       text: 'School description',
//                       hintText: 'Enter school description',
//                       type: TextInputType.text,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "School type",
//                       style: setTextTheme(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black),
//                     ),
//                     DropdownButtonFormField<String>(
//                       items: ["Private", "Public", "International"]
//                           .map((type) => DropdownMenuItem(
//                                 value: type,
//                                 child: Text(type),
//                               ))
//                           .toList(),
//                       onChanged: (value) {},
//                       decoration: const InputDecoration(
//                         filled: true,
//                         fillColor: Color(0xFFF1F1F1),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     CSCPicker(
//                       layout: Layout.vertical,
//                       showStates: true,
//                       showCities: true,
//                       flagState: CountryFlag.DISABLE,
//                       dropdownDecoration: BoxDecoration(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(10)),
//                           color: whiteShades[1],
//                           border: Border.all(color: whiteShades[1], width: 1)),
//                       disabledDropdownDecoration: BoxDecoration(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(10)),
//                         color: whiteShades[1],
//                       ),
//                       countrySearchPlaceholder: "Country",
//                       stateSearchPlaceholder: "State",
//                       citySearchPlaceholder: "City",
//                       countryDropdownLabel: "Country",
//                       stateDropdownLabel: "State",
//                       cityDropdownLabel: "City",
//                       selectedItemStyle: setTextTheme(
//                         color: Colors.black,
//                         fontSize: 14.sp,
//                       ),
//                       dropdownHeadingStyle: setTextTheme(
//                           color: Colors.black,
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.bold),
//                       dropdownItemStyle: setTextTheme(
//                         color: Colors.black,
//                         fontSize: 14.sp,
//                       ),
//                       dropdownDialogRadius: 10.0,
//                       searchBarRadius: 10.0,
//                       onCountryChanged: (value) {
//                         setState(() {
//                           countryValue = value;
//                         });
//                       },
//                       onStateChanged: (value) {
//                         setState(() {
//                           stateValue = value!;
//                         });
//                       },
//                       onCityChanged: (value) {
//                         setState(() {
//                           cityValue = value!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 50),
//                     Buttons(
//                       board: 'Complete school setup',
//                       isLoading: false,
//                       onTap: () {
//                         context.go(ViewSchool.routeName);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
