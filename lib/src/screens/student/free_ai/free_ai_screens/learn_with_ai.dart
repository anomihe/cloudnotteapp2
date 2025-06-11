import 'dart:io';

import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learning_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/record_for_free_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/adding_file.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_topic.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/drawer_learn_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/link_or_text.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/topics_box.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LearnWithAi extends StatefulWidget {
  const LearnWithAi({super.key});
  static const String routeName = "/learn_with_ai";

  @override
  State<LearnWithAi> createState() => _LearnWithAiState();
}

class _LearnWithAiState extends State<LearnWithAi> {
  bool _isProcessingSubmission = false;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    provider.loadSessions(context);
    provider.loadExploreTopics(context);
  }

  Future<void> _pickFileAndSubmit(BuildContext context) async {
    if (_isProcessingSubmission) return;
    _isProcessingSubmission = true;
    try {
      final pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'txt',
          'docx',
          'pptx',
          'mp3',
          'mp4',
          'm4a',
          'wav',
        ],
      );

      if (pickerResult != null) {
        final provider = Provider.of<FreeAiProvider>(context, listen: false);
        final file = File(pickerResult.files.single.path!);
        final fileExtension =
            pickerResult.files.single.extension?.toLowerCase();
        await provider.submitFile(context, file, fileExtension ?? 'unknown',
            pickerResult.files.single.name);

        if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      }
    } finally {
      _isProcessingSubmission = false;
    }
  }

  void _showLinkOrTextOverlay(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          insetPadding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: LinkOrText(
              onSubmit: (String url) async {
                final provider =
                    Provider.of<FreeAiProvider>(dialogContext, listen: false);
                await provider.submitUrl(dialogContext, url, "Content");
                if (provider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage!)),
                  );
                }
              },
              onAddNote: (String note) async {
                final provider =
                    Provider.of<FreeAiProvider>(dialogContext, listen: false);
                await provider.submitText(dialogContext, note, "Text Note");
                if (provider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage!)),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      context: context,
      builder: (BuildContext modalContext) {
        return Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: RecordForFreeAi(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FreeAiProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
            title: Row(
              children: [
                Image.asset("assets/app/cloudnottapp2_logo_two.png",
                    width: 33, height: 30),
                Image.asset("assets/app/cloudnottapp2_logo_one.png", height: 30),
              ],
            ),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
            ],
          ),
          drawer:
              const DrawerLearnWithAi(), // i wonder why this drawer is not showing
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (provider.userAddedTopics.isEmpty &&
                      !provider.isSubmitting)
                    SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'What do you want to learn today?',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        AddingFile(
                          titleAction: 'Upload',
                          acceptables: 'PDF, AUDIO',
                          iconAction: Icon(Icons.upload_file,
                              color: Theme.of(context).dividerColor,
                              size: 18.sp),
                          onTapAction: provider.isSubmitting
                              ? () {}
                              : () => _pickFileAndSubmit(context),
                        ),
                        AddingFile(
                          titleAction: "Paste",
                          acceptables: "YouTube, Text, TikTok",
                          iconAction: Icon(Icons.link,
                              color: Theme.of(context).dividerColor,
                              size: 18.sp),
                          onTapAction: provider.isSubmitting
                              ? () {}
                              : () => _showLinkOrTextOverlay(context),
                        ),
                        AddingFile(
                          titleAction: "Record",
                          acceptables: "Record Your Lecture",
                          iconAction: Icon(Icons.mic,
                              color: Theme.of(context).dividerColor,
                              size: 18.sp),
                          onTapAction: provider.isSubmitting
                              ? () {}
                              : () => _showModalBottomSheet(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Column(
                      children: [
                        if (provider.userAddedTopics.isNotEmpty ||
                            provider.isSubmitting) ...[
                          Row(
                            children: [
                              Text('Continue learning',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const Spacer(),
                              TextButton(
                                onPressed: () =>
                                    context.push('/view_all_topics'),
                                child: Text('View all',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey)),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          SizedBox(
                            height: 160.h,
                            child: provider.isSubmitting
                                ? const AwaitingTopic()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: provider.userAddedTopics.length,
                                    itemBuilder: (ctx, index) {
                                      final reversedIndex =
                                          provider.userAddedTopics.length -
                                              1 -
                                              index;
                                      final topic = provider
                                          .userAddedTopics[reversedIndex];
                                      return GestureDetector(
                                        onTap: topic.sessionId == null
                                            ? null
                                            : () => context.push(
                                                LearningWithAi.routeName,
                                                extra: topic),
                                        child: TopicsBox(
                                          freeAiModel: topic,
                                          isUserAddedTopic: true,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                        SizedBox(height: 20.h),
                        Row(children: [
                          Text('Explore topics',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                        SizedBox(height: 15.h),
                        SizedBox(
                          height: 160.h,
                          child: provider.isLoadingExploreTopics
                              ? const Center(child: CircularProgressIndicator())
                              : provider.exploreTopics.isEmpty
                                  ? const Center(
                                      child:
                                          Text("No explore topics available"))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: provider.exploreTopics.length,
                                      itemBuilder: (ctx, index) {
                                        final topic =
                                            provider.exploreTopics[index];
                                        return GestureDetector(
                                          onTap: topic.sessionId == null
                                              ? null
                                              : () => context.push(
                                                  LearningWithAi.routeName,
                                                  extra: topic),
                                          child: TopicsBox(
                                            freeAiModel: topic,
                                            isUserAddedTopic: false,
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
