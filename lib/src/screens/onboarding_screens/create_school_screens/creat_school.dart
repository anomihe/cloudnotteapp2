import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/create_school_screens/create_school2.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateSchool extends StatefulWidget {
  static const String routeName = "/creatschool";

  const CreateSchool({super.key});

  @override
  State<CreateSchool> createState() => _CreateSchoolState();
}

class _CreateSchoolState extends State<CreateSchool> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
                ),
              ],
            ),
            Text(
              "Let's get to know you better",
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/app/Ellipse 14.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Icon(Icons.camera_alt, color: blueShades[0]),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Icon(Icons.edit, size: 20, color: redShades[1]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                      text: 'School Description',
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
                    // const Components(
                    //   text: 'School Type',
                    //   hintText: '',
                    //   type: TextInputType.text,
                    // ),
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(10)),
                    //     color: whiteShades[1],
                    //     border: Border.all(color: whiteShades[1], width: 1),
                    //   ),
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
                    //     fontSize: 14.sp,
                    //   ),
                    //   dropdownHeadingStyle: setTextTheme(
                    //     fontSize: 14.sp,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   dropdownItemStyle: setTextTheme(
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
                    const SizedBox(height: 24),
                    Buttons(
                      text: 'Next',
                      isLoading: false,
                      onTap: () {
                        context.go(CompleteSetUp.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //    return Scaffold(
  //     body: Container(
  //       color: whiteShades[0],
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Back button
  //           Padding(
  //             padding: const EdgeInsets.only(top: 40.0),
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
  //                   onPressed: () {},
  //                 ),
  //                 Text(
  //                   'Create School',
  //                   style: setTextTheme(
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w700,
  //                     color: redShades[1],
  //                   ),
  //                 )
  //               ],
  //                child: Stack(
  //                 children: [
  //                   ClipOval(
  //                     child: Image.asset(
  //                       '',
  //                     ),
  //                   ),
  //                   Icon(Icons.camera_alt, color: whiteShades[1]),
  //                   Positioned(
  //                     bottom: 5,
  //                     right: 5,
  //                     child: Icon(Icons.edit, size: 20, color: redShades[1]),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // const SizedBox(height: 16),
  //                   const SizedBox(height: 15),
  //                   const Components(
  //                     text: 'School Name',
  //                     hintText: '',
  //                     type: TextInputType.text,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   const Components(
  //                     text: 'School description',
  //                     hintText: 'Enter school description',
  //                     type: TextInputType.text,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   const Components(
  //                     text: 'School Type',
  //                     hintText: '',
  //                     type: TextInputType.text,
  //                   ),
  //                   DropdownButtonFormField<String>(
  //                     items: ["Private", "Public", "International"]
  //                         .map((type) => DropdownMenuItem(
  //                               value: type,
  //                               child: Text(type),
  //                             ))
  //                         .toList(),
  //                     onChanged: (value) {},
  //                   ),
  //                   const SizedBox(height: 16),
  //                   CSCPicker(
  //                     layout: Layout.vertical,
  //                     showStates: true,
  //                     showCities: true,
  //                     flagState: CountryFlag.DISABLE,
  //                     dropdownDecoration: BoxDecoration(
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(10)),
  //                         color: whiteShades[1],
  //                         border: Border.all(color: whiteShades[1], width: 1)),
  //                     disabledDropdownDecoration: BoxDecoration(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(10)),
  //                       color: whiteShades[1],
  //                     ),
  //                     countrySearchPlaceholder: "Country",
  //                     stateSearchPlaceholder: "State",
  //                     citySearchPlaceholder: "City",
  //                     countryDropdownLabel: "Country",
  //                     stateDropdownLabel: "State",
  //                     cityDropdownLabel: "City",
  //                     selectedItemStyle: setTextTheme(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                     ),
  //                     dropdownHeadingStyle: setTextTheme(
  //                         color: Colors.black,
  //                         fontSize: 14.sp,
  //                         fontWeight: FontWeight.bold),
  //                     dropdownItemStyle: setTextTheme(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                     ),
  //                     dropdownDialogRadius: 10.0,
  //                     searchBarRadius: 10.0,
  //                     onCountryChanged: (value) {
  //                       setState(() {
  //                         countryValue = value;
  //                       });
  //                     },
  //                     onStateChanged: (value) {
  //                       setState(() {
  //                         stateValue = value!;
  //                       });
  //                     },
  //                     onCityChanged: (value) {
  //                       setState(() {
  //                         cityValue = value!;
  //                       });
  //                     },
  //                   ),
  //             const SizedBox(height: 24),
  //             Buttons(
  //               board: 'Next',
  //               isLoading: false,
  //               onTap: () {
  //                 context.go(CompleteSetUp.routeName);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     ]
  //     ),
  //     ),
  //   );
  // }
}
