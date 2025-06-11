import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/service/chat_service.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/widgets/live_messages_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LiveClassChat extends StatelessWidget {
  final String? callId;
  LiveClassChat({super.key, this.callId});
  static const String routeName = "/live_class_chat";

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: customAppBarLeadingIcon(context),
        title: Text(
          'Chat',
          style: setTextTheme(
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<ChatService>(builder: (context, chatService, _) {
        // chatService.initialize(
        //   callId: callId ?? "",
        //   username: chatService.username ?? "",
        //   userId: chatService.userId ?? "",
        // );
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatService
                    .getChatMessageById(chatService.callId ?? "")
                    .length,
                itemBuilder: (ctx, index) => LiveMessagesWidget(
                  liveClassChatModel: chatService
                      .getChatMessageById(chatService.callId ?? "")[index],
                  isFirstMessage: index == 0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(13.r),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: blueShades[3],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          child: Center(
                            child: Form(
                              // child: CustomTextFormField(
                              //   hintText: "Type a message",
                              // ),
                              child: TextFormField(
                                controller: messageController,
                                textAlignVertical:
                                    const TextAlignVertical(y: 0),
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        // send message
                                        if (messageController.text.isEmpty) {
                                          return;
                                        }
                                        chatService.sendMessage(
                                          callId ?? "",
                                          messageController.text,
                                          chatService.username ?? "",
                                        );
                                        messageController.clear();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/send_icon.svg',
                                        fit: BoxFit.none,
                                      ),
                                    ),
                                  ),
                                  hintText: "Type a message",
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  hintStyle: setTextTheme(
                                    color: whiteShades[3],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: SvgPicture.asset('assets/icons/more_icon.svg'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
