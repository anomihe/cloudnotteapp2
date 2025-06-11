import 'dart:developer';

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddChatUserScreen extends StatelessWidget {
  static const routeName = "/add_chat_user";

  AddChatUserScreen({super.key});

  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: TextFormField(
              controller: _searchTextController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search...',
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                hintStyle: setTextTheme(
                  color: Colors.black,
                ),
                focusColor: Colors.black,
                fillColor: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                size: 32,
              ),
              onPressed: () async {
                // Perform search operation here
                log('Searching for: ');
                await userProvider
                    .getUserByUsername(_searchTextController.text);
                if (userProvider.isError) {
                  Alert.displaySnackBar(
                    context,
                    message: userProvider.errorResponse?.message,
                  );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                userProvider.searchedUser != null
                    ? Container(
                        width: 400,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              CircleAvatar(),
                              20.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userProvider.searchedUser?.firstName} ${userProvider.searchedUser?.lastName}",
                                    style: setTextTheme(
                                      fontSize: 17.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "@${userProvider.searchedUser?.username}",
                                    style: setTextTheme(
                                      fontSize: 15.sp,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Text("Find A Friend"),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }
}
