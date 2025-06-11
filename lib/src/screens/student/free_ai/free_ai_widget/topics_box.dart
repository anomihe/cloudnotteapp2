import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learning_with_ai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopicsBox extends StatelessWidget {
  const TopicsBox({
    super.key,
    required this.freeAiModel,
    required this.isUserAddedTopic, // New parameter
  });

  final FreeAiModel freeAiModel;
  final bool isUserAddedTopic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(LearningWithAi.routeName, extra: freeAiModel),
      child: Container(
        width: 200.w,
        height: 160.h,
        margin: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 180.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    child: freeAiModel.image != null &&
                            freeAiModel.image!.startsWith('http')
                        ? Image.network(
                            freeAiModel.image!,
                            height: 100.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/app/teacher_image.png',
                              height: 80.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(freeAiModel.image ??
                                'assets/app/teacher_image.png'),
                          ),
                  ),
                  if (isUserAddedTopic) // Show delete icon only for user-added topics
                    Positioned(
                      top: -8,
                      right: -8,
                      child: IconButton(
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Delete Topic'),
                                content: Text(
                                  'Are you sure you want to delete "${freeAiModel.title ?? freeAiModel.name}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext)
                                        .pop(), // Cancel
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Delete topic
                                      context
                                          .read<FreeAiProvider>()
                                          .deleteTopic(
                                            context,
                                            freeAiModel.sessionId!,
                                          );
                                      Navigator.of(dialogContext)
                                          .pop(); // Close dialog
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.xmark_circle,
                          size: 20.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? redShades[0]
                              : darkShades[0],
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Theme.of(context).cardColor,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      (freeAiModel.title ?? freeAiModel.name).length > 40
                          ? '${(freeAiModel.title ?? freeAiModel.name).substring(0, 40)}...'
                          : freeAiModel.title ?? freeAiModel.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
