import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/chat_tab.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/chapters_tab.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/content_viewer.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/flashcards_tab.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/free_ai_quiz.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/notes_tab.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/summary_tab.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/transcripts_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LearningWithAi extends StatefulWidget {
  const LearningWithAi({super.key, required this.freeAiModel});
  final FreeAiModel freeAiModel;
  static const String routeName = "/learning_with_ai";

  @override
  State<LearningWithAi> createState() => _LearningWithAiState();
}

class _LearningWithAiState extends State<LearningWithAi>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  late TabController _tabController;
  bool _isCollapsed = false;
  bool _isPdfExpanded = false;
  Map<String, bool> _isReloading = {
    'summary': false,
    'chapters': false,
    'questions': false,
    'quiz': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    provider.initializeMedia(widget.freeAiModel);
  }

  List<Map<String, String>> _structureText(String? text) {
    if (text == null || text.isEmpty) {
      return [
        {'type': 'paragraph', 'content': 'No content available.'}
      ];
    }
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    final structured = <Map<String, String>>[];
    for (var line in lines) {
      if ((line.length < 40 && line.endsWith(':')) ||
          line == line.toUpperCase()) {
        structured.add({'type': 'heading', 'content': line});
      } else {
        structured.add({'type': 'paragraph', 'content': line});
      }
    }
    return structured;
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    provider.sendChatMessage(
        context, widget.freeAiModel.sessionId!, _chatController.text);
    _chatController.clear();
  }

  Future<void> _reloadTab(String tab, VoidCallback reloadFunction) async {
    setState(() => _isReloading[tab] = true);
    await Future(() => reloadFunction());
    if (mounted) {
      setState(() => _isReloading[tab] = false);
    }
  }

  @override
  void dispose() {
    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    if (provider.isPlayingAudio) {
      provider.pauseAudio();
    }
    if (provider.isPlayingVideo) {
      provider.pauseVideo();
    }
    provider.clearSessionData();
    _tabController.dispose();
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final provider = Provider.of<FreeAiProvider>(context, listen: false);
        if (provider.isPlayingAudio) {
          await provider.pauseAudio();
        }
        if (provider.isPlayingVideo) {
          await provider.pauseVideo();
        }
        provider.clearSessionData();
        if (mounted) {
          context.pop();
        }
      },
      child: Consumer<FreeAiProvider>(
        builder: (context, provider, child) {
          final topic = provider.userAddedTopics.firstWhere(
            (t) => t.sessionId == widget.freeAiModel.sessionId,
            orElse: () => widget.freeAiModel,
          );
          final chatMessages = provider.chatMessages;
          // Safely cast quiz questions
          final quizQuestions =
              (topic.quiz?['questions'] as List<dynamic>?)?.map((q) {
                    return {
                      'id': q['id'] as String?,
                      'content': q['content'] as String?,
                      'options': (q['options'] as List<dynamic>?)?.map((o) {
                        return {
                          'id': o['id'] as String?,
                          'content': o['content'] as String?,
                          'isCorrect': o['isCorrect'] as bool?,
                        };
                      }).toList(),
                      'hint': q['hint'] as String?,
                      'explanation': q['explanation'] as String?,
                    };
                  }).toList() ??
                  [];

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? darkShades[0]
                : whiteShades[0],
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? darkShades[0]
                  : whiteShades[0],
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  final provider =
                      Provider.of<FreeAiProvider>(context, listen: false);
                  if (provider.isPlayingAudio) {
                    provider.pauseAudio();
                  }
                  if (provider.isPlayingVideo) {
                    provider.pauseVideo();
                  }
                  provider.clearSessionData();
                  context.pop();
                },
              ),
              leadingWidth: 45.w,
              title: Text(
                (topic.title ?? topic.name).length > 40
                    ? '${(topic.title ?? topic.name).substring(0, 40)}...'
                    : topic.title ?? topic.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              centerTitle: false,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  firstChild: ContentViewer(
                    freeAiModel: topic,
                    isCollapsed: _isCollapsed,
                    onPdfToggle: () =>
                        setState(() => _isPdfExpanded = !_isPdfExpanded),
                    isPdfExpanded: _isPdfExpanded,
                    pdfError: provider.pdfError,
                    pdfFilePath: provider.pdfFilePath,
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: _isCollapsed
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        margin: EdgeInsets.only(left: 5.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: TabBar(
                          controller: _tabController,
                          dividerColor: Colors.transparent,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          splashBorderRadius: BorderRadius.circular(10),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? darkShades[0]
                                    : whiteShades[0],
                          ),
                          tabs: [
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.chat_bubble,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Chat",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.description,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Summary",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.quiz,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Quiz",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.collections,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Flashcards",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.transcribe,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Transcripts",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.book,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Chapters",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Icon(Icons.note,
                                      size: 18.sp,
                                      color: ThemeProvider().isDarkMode
                                          ? redShades[1]
                                          : Colors.black),
                                  SizedBox(width: 5.w),
                                  Text("Notes",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ])),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _isCollapsed = !_isCollapsed;
                        if (_isCollapsed && provider.isPlayingAudio) {
                          provider.pauseAudio();
                        }
                        if (_isCollapsed && provider.isPlayingVideo) {
                          provider.pauseVideo();
                        }
                      }),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.height * 0.046,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Icon(
                            _isCollapsed
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 18.sp,
                            color: ThemeProvider().isDarkMode
                                ? redShades[1]
                                : Colors.black),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ChatTab(
                        chatMessages: chatMessages,
                        isLoadingChat: provider.isLoadingChat,
                        chatController: _chatController,
                        scrollController: _scrollController,
                        onSendMessage: _sendMessage,
                      ),
                      SummaryTab(
                        isLoadingSummary: _isReloading['summary']!,
                        summary: topic.summary,
                        structureText: _structureText,
                        onReload: () => _reloadTab(
                            'summary',
                            () => provider.regenerateSummary(
                                context, topic.sessionId!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical: 30.h),
                        child: Scrollbar(
                          controller: _scrollController,
                          thickness: 3,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            child: FreeAiQuiz(
                              sessionId: topic.sessionId!,
                              quizQuestions: quizQuestions,
                              isLoadingQuiz: _isReloading['quiz']!,
                              onReload: () => _reloadTab(
                                  'quiz',
                                  () => provider.regenerateQuiz(
                                      context, topic.sessionId!)),
                            ),
                          ),
                        ),
                      ),
                      FlashcardsTab(
                        isLoadingQuestions: _isReloading['questions']!,
                        questions: topic.questions ?? [],
                        onReload: () => _reloadTab(
                            'questions',
                            () => provider.regenerateQuestions(
                                context, topic.sessionId!)),
                      ),
                      TranscriptsTab(
                        transcripts: topic.transcript ?? [],
                        structureText: _structureText,
                      ),
                      ChaptersTab(
                        isLoadingChapters: _isReloading['chapters']!,
                        chapters: topic.chapters ?? [],
                        onReload: () => _reloadTab(
                            'chapters',
                            () => provider.regenerateChapters(
                                context, topic.sessionId!)),
                      ),
                      NotesTab(sessionId: topic.sessionId!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
