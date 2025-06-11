import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AwaitingTopic extends StatefulWidget {
  const AwaitingTopic({super.key});

  @override
  State<AwaitingTopic> createState() => _AwaitingTopicState();
}

class _AwaitingTopicState extends State<AwaitingTopic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentQuoteIndex = 0;

  final List<Map<String, String>> _quotes = [
    {
      'text': 'Hang tight, knowledge is brewing! ☕',
      'emoji': '☕',
    },
    {
      'text': 'Processing your topic, almost there! 🚀',
      'emoji': '🚀',
    },
    {
      'text': 'Learning is worth the wait! 🌟',
      'emoji': '🌟',
    },
    {
      'text': 'Your topic is cooking in the AI oven! 🍳',
      'emoji': '🍳',
    },
    {
      'text': 'Patience, genius takes time! ⏳',
      'emoji': '⏳',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 160.h,
      margin: EdgeInsets.only(right: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _quotes[_currentQuoteIndex]['text']!,
                key: ValueKey<int>(_currentQuoteIndex),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 25.w,
              height: 25.h,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.redAccent
                      : Colors.blueAccent,
                ),
                strokeWidth: 2.w,
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            child: Text(
              'Please wait while we process your file...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
