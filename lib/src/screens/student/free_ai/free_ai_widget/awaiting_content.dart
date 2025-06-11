import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AwaitingContent extends StatefulWidget {
  final String
      contentType; // 'summary', 'transcripts', 'chapters', 'questions', 'flashcards'
  const AwaitingContent({super.key, required this.contentType});

  @override
  State<AwaitingContent> createState() => _AwaitingContentState();
}

class _AwaitingContentState extends State<AwaitingContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;

  final List<String> quotes = [
    "‘The only way to learn is to keep going!’ 😊",
    "‘Patience is the key to knowledge.’ 🌟",
    "‘Great things take time.’ ⏳",
    "‘Learning is a journey, not a race.’ 🚀",
  ];

  final List<String> encouragements = [
    "Hang tight, your content is almost ready!",
    "Just a moment, we’re cooking up something good!",
    "Stay with us, the best is yet to come!",
    "Loading wisdom, please wait...",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    // Start cycling quotes every 4 seconds
    _startQuoteCycling();
  }

  void _startQuoteCycling() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % quotes.length;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSkeletonLine(double width, {bool isHeading = false}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: width,
        height: isHeading ? 20.h : 16.h,
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.contentType) {
      case 'summary':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.4,
                isHeading: true),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.8),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.6),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.7),
          ],
        );
      case 'transcripts':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.3,
                isHeading: true),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.5),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.7),
            SizedBox(height: 20.h),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.3,
                isHeading: true),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.6),
          ],
        );
      case 'chapters':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.5,
                isHeading: true),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.7),
            SizedBox(height: 10.h),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.5,
                isHeading: true),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.6),
          ],
        );
      case 'questions':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.8),
            SizedBox(height: 5.h),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.7),
            SizedBox(height: 5.h),
            _buildSkeletonLine(MediaQuery.of(context).size.width * 0.6),
          ],
        );
      case 'flashcards':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSkeletonLine(40.w),
                _buildSkeletonLine(50.w),
                _buildSkeletonLine(40.w),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSkeletonLine(100.w),
                Row(
                  children: [
                    _buildSkeletonLine(60.w),
                    SizedBox(width: 10.w),
                    _buildSkeletonLine(60.w),
                  ],
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Center(
          child: Text(
            quotes[_currentQuoteIndex],
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        _buildContent(),
        SizedBox(height: 20.h),
        Center(
          child: Text(
            encouragements[_currentQuoteIndex % encouragements.length],
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
