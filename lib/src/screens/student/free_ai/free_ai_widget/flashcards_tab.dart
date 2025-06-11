import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardsTab extends StatefulWidget {
  const FlashcardsTab({
    super.key,
    required this.isLoadingQuestions,
    required this.questions,
    required this.onReload, // New callback field
  });

  final bool isLoadingQuestions;
  final List<Map<String, dynamic>> questions;
  final VoidCallback onReload;

  @override
  State<FlashcardsTab> createState() => _FlashcardsTabState();
}

class _FlashcardsTabState extends State<FlashcardsTab> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _showStarredOnly = false;
  bool _isShuffled = false;
  List<Map<String, dynamic>> _displayedQuestions = [];
  List<Map<String, dynamic>> _originalQuestions = [];
  final Map<int, bool> _showHint = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _originalQuestions = widget.questions.map((q) {
      return {...q, 'isStarred': q['isStarred'] ?? false};
    }).toList();
    _displayedQuestions = List.from(_originalQuestions);
    _applyFilters();
  }

  @override
  void didUpdateWidget(FlashcardsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questions != widget.questions) {
      _originalQuestions = widget.questions.map((q) {
        return {...q, 'isStarred': q['isStarred'] ?? false};
      }).toList();
      _displayedQuestions = List.from(_originalQuestions);
      _showHint.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _applyFilters();
        }
      });
    }
  }

  void _applyFilters() {
    if (!mounted) return;
    setState(() {
      _displayedQuestions = List.from(_originalQuestions);
      if (_showStarredOnly) {
        _displayedQuestions =
            _displayedQuestions.where((q) => q['isStarred'] == true).toList();
      }
      if (_isShuffled) {
        _displayedQuestions.shuffle();
      }
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _showHint.clear();
    });
  }

  void _toggleStarred(int index) {
    setState(() {
      final question = _displayedQuestions[index];
      final isStarred = !(question['isStarred'] ?? false);
      question['isStarred'] = isStarred;
      final originalIndex = _originalQuestions
          .indexWhere((q) => q['content'] == question['content']);
      if (originalIndex != -1) {
        _originalQuestions[originalIndex]['isStarred'] = isStarred;
      }
      _applyFilters();
    });
  }

  void _toggleHint(int index) {
    setState(() {
      _showHint[index] = !(_showHint[index] ?? false);
    });
  }

  void _toggleStarredFilter() {
    setState(() {
      _showStarredOnly = !_showStarredOnly;
      _applyFilters();
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
      _applyFilters();
    });
  }

  void _showAllCards() {
    setState(() {
      _showStarredOnly = false;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: 10.h,
      ),
      child: Scrollbar(
        thickness: 3,
        radius: const Radius.circular(5),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Flashcards",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, size: 24.sp),
                    onPressed: widget.onReload,
                    tooltip: 'Reload Flashcards',
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              widget.isLoadingQuestions
                  ? const AwaitingContent(contentType: 'flashcards')
                  : _displayedQuestions.isEmpty && !_showStarredOnly
                      ? const Center(child: Text("No flashcards available."))
                      : Column(
                          children: [
                            _showStarredOnly && _displayedQuestions.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "No starred flashcards found",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          SizedBox(height: 10.h),
                                          ElevatedButton(
                                            onPressed: _showAllCards,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Show All"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                        });
                                      },
                                      itemCount: _displayedQuestions.length,
                                      itemBuilder: (context, index) {
                                        final question =
                                            _displayedQuestions[index];
                                        final isShowingHint =
                                            _showHint[index] ?? false;
                                        final content =
                                            question['content'] as String? ??
                                                '';
                                        final hint =
                                            question['hint'] as String? ??
                                                'No hint available';
                                        return Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.r),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () =>
                                                          _toggleHint(index),
                                                      icon: Icon(
                                                        Icons.lightbulb,
                                                        size: 20.sp,
                                                        color: isShowingHint
                                                            ? Colors.yellow
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () =>
                                                              _toggleStarred(
                                                                  index),
                                                          icon: Icon(
                                                            question['isStarred'] ??
                                                                    false
                                                                ? Icons.star
                                                                : Icons
                                                                    .star_border,
                                                            size: 20.sp,
                                                            color: question[
                                                                        'isStarred'] ??
                                                                    false
                                                                ? Colors.orange
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      isShowingHint
                                                          ? hint
                                                          : content,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 18.sp),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: _currentPage > 0 &&
                                          _displayedQuestions.isNotEmpty
                                      ? () {
                                          _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.arrow_left,
                                    size: 24.sp,
                                    color: _currentPage > 0 &&
                                            _displayedQuestions.isNotEmpty
                                        ? Colors.grey
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  _displayedQuestions.isNotEmpty
                                      ? "${_currentPage + 1} / ${_displayedQuestions.length}"
                                      : "0 / 0",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                IconButton(
                                  onPressed: _currentPage <
                                          _displayedQuestions.length - 1
                                      ? () {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.arrow_right,
                                    size: 24.sp,
                                    color: _currentPage <
                                            _displayedQuestions.length - 1
                                        ? Colors.grey
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                      value: _showStarredOnly,
                                      onChanged: (value) =>
                                          _toggleStarredFilter(),
                                      activeColor: Colors.blue,
                                    ),
                                    Text(
                                      "Starred",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: _toggleShuffle,
                                      icon: Icon(
                                        Icons.shuffle,
                                        size: 20.sp,
                                        color: _isShuffled
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Shuffle",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
