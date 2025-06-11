import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/typing_dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({
    super.key,
    required this.chatMessages,
    required this.isLoadingChat,
    required this.chatController,
    required this.scrollController,
    required this.onSendMessage,
  });

  final List<Map<String, dynamic>> chatMessages;
  final bool isLoadingChat;
  final TextEditingController chatController;
  final ScrollController scrollController;
  final VoidCallback onSendMessage;

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  void initState() {
    super.initState();
    // Add listener to the controller to detect text changes
    widget.chatController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    widget.chatController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Trigger rebuild when text changes
    setState(() {});
  }

  Widget _buildChatMessage(Map<String, dynamic> message, BuildContext context) {
    final isUser = message["sender"] == "User";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Wrap(
        alignment: isUser ? WrapAlignment.end : WrapAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            margin: EdgeInsets.only(
              top: 5.h,
              left: isUser ? 5.w : 3.w,
              right: isUser ? 3.w : 5.w,
            ),
            decoration: BoxDecoration(
              color: isUser ? Theme.of(context).cardColor : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              message["text"]!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.01),
            child: Scrollbar(
              controller: widget.scrollController,
              thickness: 3,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    children: [
                      if (widget.chatMessages.isEmpty)
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Center(
                            child: Text(
                              "Welcome to the chat! Ask me anything. I may not always be right, but your feedback will help me improve!",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      SizedBox(height: 2.h),
                      ...widget.chatMessages
                          .map((msg) => _buildChatMessage(msg, context))
                          .toList(),
                      if (widget.isLoadingChat) const TypingDotsIndicator(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.chatController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    hintText: 'Ask anything...',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (widget.chatController.text.isNotEmpty) ...[
                GestureDetector(
                  onTap: widget.onSendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.send,
                      size: 18.sp,
                      color: ThemeProvider().isDarkMode
                          ? redShades[1]
                          : Colors.black,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
