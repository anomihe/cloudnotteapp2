import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LinkNewUserAccountScreen extends StatefulWidget {
  const LinkNewUserAccountScreen({super.key});
  static const routeName = '/link_new_user_account';

  @override
  State<LinkNewUserAccountScreen> createState() =>
      _LinkNewUserAccountScreenState();
}

class _LinkNewUserAccountScreenState extends State<LinkNewUserAccountScreen> {
  bool isContact = false;
  String selectedRole = '';
  String spaceId ='';
  TextEditingController usernames = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserSpaces(context);
  }
  @override
  void dispose() {
    usernames.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Link new user account',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            spacing: 10.r,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                text: 'Usernames',
                controller: usernames,
                hintText: 'Username',
                keyboardType: TextInputType.text,
              ),
              Consumer<UserProvider>(
                builder: (context,value,_) {
                  return CustomDropdownFormField(
                      title: 'Select space',
                      hintText: 'Select Space',
                      onChanged: (value) {
                        // Handle space selection
                        setState(() {
                          spaceId = value ?? '';
                        });
                        print('Selected space: $value');
                      },
                      items: value.space.map((space) {
                        return DropdownMenuItem(
                          value: space.id,
                          child: Text(
                            space.name ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList());
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This user is my contact person?',
                    style: setTextTheme(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: isContact,
                      activeTrackColor: redShades[1],
                      inactiveThumbColor: Colors.grey[600],
                      inactiveTrackColor: redShades[8],
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      onChanged: (value) {
                        setState(
                          () {
                            isContact = value;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
             CustomDropdownFormField(
  title: 'Select Role',
  hintText: 'Select your role in the family',
  onChanged: (value) {
    // Handle role selection
    setState(() {
      selectedRole = value ?? '';
    });
    print('Selected role: $value');
  },
  items: [
    DropdownMenuItem(value: 'father', child: Text('Father')),
    DropdownMenuItem(value: 'mother', child: Text('Mother')),
    DropdownMenuItem(value: 'brother', child: Text('Brother')),
    DropdownMenuItem(value: 'sister', child: Text('Sister')),
    
    DropdownMenuItem(value: 'uncle', child: Text('Uncle')),
    DropdownMenuItem(value: 'aunt', child: Text('Aunt')),
    DropdownMenuItem(value: 'cousin', child: Text('Cousin')),
    DropdownMenuItem(value: 'nephew', child: Text('Nephew')),
    DropdownMenuItem(value: 'grandfather', child: Text('Grandfather')),
    DropdownMenuItem(value: 'grandmother', child: Text('Grandmother')),
        DropdownMenuItem(value: 'others', child: Text('Others')),
  ],
),
SizedBox(height: 10.h),
     Consumer<UserProvider>(
       builder: (context,value,_) {
         return Buttons(
           text:value.isLoadingStateTwo ? "Sending Invite..." : 'Send Invitation',
           fontSize: 15.sp,
           onTap:selectedRole.isNotEmpty && spaceId.isNotEmpty && usernames.text.isNotEmpty ?
            (){ value.sendSpaceLinkInvite(
               context: context,
               requestedUserUsernames: usernames.text,
               contactPerson: selectedRole,
               spaceId: spaceId,
             );
           }:(){},
           isLoading: false,
         );
       }
     ),
            ],
          ),
        ),
      ),
    );
  }
}
