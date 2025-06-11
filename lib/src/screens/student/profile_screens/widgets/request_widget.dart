import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatelessWidget {
  final UserSpaceInvitation invitation;
  const RequestWidget({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: screenSize.width,
          height: 140.h,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
              // color: blueShades[10],
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: blueShades[3], width: 1.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
  radius: 25.r,
  backgroundImage: (invitation.space?.logo != null && invitation.space!.logo!.isNotEmpty)
      ? NetworkImage(invitation.space!.logo!)
      : AssetImage('assets/images/default_avatar.png') as ImageProvider,
),

                  // CircleAvatar(
                  //   radius: 25.r,
                  //   backgroundImage: NetworkImage(
                  //     // profile image
                  //     '${invitation.space?.logo}',
                  //   ),
                  // ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // student name
                          '${invitation.space?.name}',
                          overflow: TextOverflow.ellipsis,
                          style: setTextTheme(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          // username
                          '${invitation.space?.alias}',
                          style: setTextTheme(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          // school name
                          '${invitation.space?.description}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: setTextTheme(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Buttons(
                    onTap: () {
                      // accept 
                      Provider.of<UserProvider>(context, listen: false)
                          .acceptInvite(
                        context: context,
                        spaceId: invitation.spaceId ?? '',
                        inviteId: invitation.id,
                      );
                    },
                    width: 130.w,
                    height: 30.h,
                    boxColor: redShades[1],
                    text: 'Accept',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(16.r),
                    isLoading: false,
                  ),
                  Buttons(
                    onTap: () {
                      // decline
                      Provider.of<UserProvider>(context, listen: false)
                          .rejectInvite(
                        context: context,
                        spaceId: invitation.spaceId ?? '',
                        inviteId: invitation.id,
                      );
                    },
                    width: 130.w,
                    height: 30.h,
                    boxColor: blueShades[2],
                    text: 'Decline',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(16.r),
                    isLoading: false,
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}

class LinkWidget extends StatelessWidget {
   final PendingSpaceLinkRequest invitation;
  const LinkWidget({super.key,required this.invitation});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: screenSize.width,
          height: 140.h,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
              // color: blueShades[10],
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: blueShades[3], width: 1.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
  radius: 25.r,
  backgroundImage: (invitation.requester?.profileImageUrl != null && invitation.requester!.profileImageUrl!.isNotEmpty)
      ? NetworkImage(invitation.requester!.profileImageUrl!)
      : AssetImage('assets/images/default_avatar.png') as ImageProvider,
),

                  // CircleAvatar(
                  //   radius: 25.r,
                  //   backgroundImage: AssetImage(
                  //     // profile image
                  //     'assets/images/default_avatar.png',
                  //   ),
                  // ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // student name
                          '${invitation.requester?.firstName} ${invitation.requester?.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: setTextTheme(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          // username
                          '${invitation.requester?.email}',
                          style: setTextTheme(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          // school name
                          '${invitation..status}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: setTextTheme(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Buttons(
                    onTap: () {
                      // accept 
                      Provider.of<UserProvider>(context, listen: false)
                          .linkResponse(
                        context: context,
                        spaceId: invitation.spaceId ?? '',
                        requesterId: invitation.requesterId ?? '',
                        status: 'accepted'
                      );
                    },
                    width: 130.w,
                    height: 30.h,
                    boxColor: redShades[1],
                    text: 'Accept',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(16.r),
                    isLoading: false,
                  ),
                  Buttons(
                    onTap: () {
                      // decline
                         Provider.of<UserProvider>(context, listen: false)
                          .linkResponse(
                        context: context,
                        spaceId: invitation.spaceId ?? '',
                        requesterId: invitation.requesterId ?? '',
                        status: 'rejected'
                      );
                    },
                    width: 130.w,
                    height: 30.h,
                    boxColor: blueShades[2],
                    text: 'Decline',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(16.r),
                    isLoading: false,
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
