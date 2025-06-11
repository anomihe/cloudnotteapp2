import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learning_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/drawer_learn_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/topics_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewAllTopics extends StatelessWidget {
  const ViewAllTopics({super.key});

  static const String routeName = "/view_all_topics";

  @override
  Widget build(BuildContext context) {
    return Consumer<FreeAiProvider>(builder: (context, freeAiProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkShades[0]
            : whiteShades[0],
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? darkShades[0]
              : whiteShades[0],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.pop(),
          ),
          leadingWidth: 45.w,
          title: Text(
            'Learning History',
            style: setTextTheme(fontSize: 24.sp, fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: freeAiProvider.userAddedTopics.length,
                    itemBuilder: (ctx, index) {
                      final topic = freeAiProvider.userAddedTopics[index];
                      return GestureDetector(
                        onTap: topic.sessionId == null
                            ? null
                            : () => context.push(LearningWithAi.routeName,
                                extra: topic),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: TopicsBox(
                            freeAiModel: topic,
                            isUserAddedTopic: true,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// constraints: BoxConstraints(maxWidth: 320.w),
