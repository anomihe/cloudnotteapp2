import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class RecordForFreeAi extends StatefulWidget {
  const RecordForFreeAi({
    super.key,
  });

  static const String routeName = "/demo_record";

  @override
  State<RecordForFreeAi> createState() => _RecordForFreeAiState();
}

enum SubmissionStage { recording, submitting, failed }

class _RecordForFreeAiState extends State<RecordForFreeAi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioRecorder _audioRecorder;
  late AudioPlayer _audioPlayer;
  String? _recordedFilePath;
  String _timerCount = "0:00";
  bool _isRecording = false;
  bool _isRecordingCompleted = false;
  bool _isPlaying = false;
  Timer? _timer;
  Timer? _quoteTimer;
  int _secondsElapsed = 0;
  Duration? _audioDuration;
  Duration? _currentPosition;
  int _currentQuoteIndex = 0;
  SubmissionStage _submissionStage =
      SubmissionStage.recording; // Added missing variable

  final List<Map<String, String>> _quotes = [
    {'text': 'Your audio is on its way! 🚀', 'emoji': '🚀'},
    {'text': 'Processing your voice, stay tuned! 🎙️', 'emoji': '🎙️'},
    {'text': 'Knowledge is being crafted! ✨', 'emoji': '✨'},
    {'text': 'Almost there, hang tight! ⏳', 'emoji': '⏳'},
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
        if (_isPlaying) {
          _timerCount = _formatDuration(position);
        }
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _audioDuration = duration;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
          _timerCount = "0:00";
          _stopTimer();
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_isRecording || _isPlaying) {
          _secondsElapsed++;
          _timerCount = _formatDuration(Duration(seconds: _secondsElapsed));
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _startQuoteTimer() {
    _quoteTimer?.cancel();
    _quoteTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
      }
    });
  }

  void _stopQuoteTimer() {
    _quoteTimer?.cancel();
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath);
      setState(() {
        _isRecording = true;
        _recordedFilePath = filePath;
        _isRecordingCompleted = false;
      });
      _startTimer();
      log("Recording started: $_recordedFilePath");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied")));
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
        _isRecordingCompleted = true;
      });
      _stopTimer();
      log("Recording stopped: $_recordedFilePath");
    }
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath != null && await File(_recordedFilePath!).exists()) {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() => _isPlaying = true);
      _startTimer();
      log("Playing recording: $_recordedFilePath");
    } else {
      log("No recording to play: $_recordedFilePath");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No recording available to play")));
    }
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() => _isPlaying = false);
    _stopTimer();
    log("Paused recording");
  }

  Future<void> _resetRecordingState() async {
    log("Re-record button tapped");
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      }
      if (_recordedFilePath != null &&
          await File(_recordedFilePath!).exists()) {
        await File(_recordedFilePath!).delete();
        log("Deleted previous recording: $_recordedFilePath");
      }
      setState(() {
        _recordedFilePath = null;
        _isRecordingCompleted = false;
        _isPlaying = false;
        _timerCount = "0:00";
        _currentPosition = null;
        _audioDuration = null;
        _submissionStage = SubmissionStage.recording; // Reset submission stage
      });
      _stopTimer();
      log("Recording state reset successfully");
    } catch (e) {
      log("Error resetting recording state: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to reset recording")));
    }
  }

  Future<void> _submitRecording() async {
    log("Submit button pressed");
    if (_recordedFilePath == null) {
      log("No recording to submit");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No recording to submit")));
      return;
    }

    log("Submitting recording: $_recordedFilePath");
    final file = File(_recordedFilePath!);
    if (!await file.exists()) {
      log("File does not exist: $_recordedFilePath");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Recorded file not found")));
      return;
    }

    setState(() {
      _submissionStage = SubmissionStage.submitting;
    });
    _startQuoteTimer();

    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    await provider.submitRecording(
        context, _recordedFilePath!); // Updated to pass context

    if (provider.errorMessage != null) {
      setState(() {
        _submissionStage = SubmissionStage.failed;
      });
      _stopQuoteTimer();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
      if (await file.exists()) {
        await file.delete();
        log("Temporary file deleted due to submission failure: $_recordedFilePath");
      }
      return;
    }

    if (await file.exists()) {
      await file.delete();
      log("Temporary file deleted: $_recordedFilePath");
    }
    if (context.mounted) {
      context.pop();
    }
  }

  Widget _buildSubmitButton() {
    final provider = Provider.of<FreeAiProvider>(context);
    return _isRecordingCompleted
        ? ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CustomButton(
                    text: "Re-record",
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    buttonColor: Theme.of(context).cardColor,
                    onTap: _resetRecordingState,
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: CustomButton(
                    text: provider.isSubmitting ? "Submitting..." : "Submit",
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    buttonColor: provider.isSubmitting
                        ? Theme.of(context).disabledColor
                        : ThemeProvider().isDarkMode
                            ? blueShades[15]
                            : Theme.of(context).cardColor,
                    onTap: provider.isSubmitting ? null : _submitRecording,
                    leading: provider.isSubmitting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: _controller,
                              color: ThemeProvider().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildControlButton() {
    if (_isRecording) {
      return GestureDetector(
        onTap: _stopRecording,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: redShades[1],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: freeAiColors[0], width: 1),
          ),
          child: Icon(Icons.stop, color: freeAiColors[0], size: 20.sp),
        ),
      );
    } else if (_recordedFilePath != null) {
      return GestureDetector(
        onTap: _isPlaying ? _pauseRecording : _playRecording,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: freeAiColors[0], width: 1),
          ),
          child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
              color: freeAiColors[0], size: 20.sp),
        ),
      );
    } else {
      return GestureDetector(
        onTap: _startRecording,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: freeAiColors[0], width: 1),
          ),
          child: Text("Start Recording",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontSize: 15.sp)),
        ),
      );
    }
  }

  Widget _buildSoundwave() {
    const int barCount = 30;
    final double progress = _audioDuration != null && _currentPosition != null
        ? _currentPosition!.inMilliseconds / _audioDuration!.inMilliseconds
        : 0.0;
    final int activeBarIndex = (_isPlaying && _audioDuration != null)
        ? (progress * barCount).floor()
        : -1;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(barCount, (index) {
          final double height = (index % 3 == 0)
              ? 16.h
              : (index % 2 == 0)
                  ? 12.h
                  : 8.h;
          final bool isActive = _isPlaying && index == activeBarIndex;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Container(
              width: 3.w,
              height: _isRecording || _isPlaying ? height : 8.h,
              color: isActive ? Colors.red : freeAiColors[0],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProcessingUI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              _quotes[_currentQuoteIndex]['text']!,
              key: ValueKey<int>(_currentQuoteIndex),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.redAccent
                    : Colors.blueAccent,
              ),
              strokeWidth: 2.w,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Processing audio...",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 10.sp, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (_submissionStage == SubmissionStage.failed) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => setState(() {
                _submissionStage = SubmissionStage.recording;
              }),
              child: Text(
                "Try Again",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.blue, fontSize: 10.sp),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _quoteTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _submissionStage == SubmissionStage.submitting ||
            _submissionStage == SubmissionStage.failed
        ? Center(child: _buildProcessingUI())
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close,
                          color: ThemeProvider().isDarkMode
                              ? redShades[1]
                              : Colors.black,
                          size: 18.sp),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                Text(
                  'Record For AI to Explain',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontSize: 30.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Record a question or topic for AI to explain',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      _buildControlButton(),
                      _buildSoundwave(),
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(_timerCount,
                            style: TextStyle(fontSize: 18.sp)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                _buildSubmitButton(),
              ],
            ),
          );
  }
}
