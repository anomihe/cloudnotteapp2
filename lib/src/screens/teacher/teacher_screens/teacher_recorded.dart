/* 
This is the entry screen for the teacher to record a lesson.
it implements audio recording and playback functionality.
FUTURE IMPLEMENTATION: The recorded file should be saved on the user's device.
 */

import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart'; // For date formatting

class TeacherRecorded extends StatefulWidget {
  const TeacherRecorded({super.key, this.classDetails});
  static const String routeName = '/teacher_recorded_screen';

  final ClassTimeTable? classDetails;
  @override
  State<TeacherRecorded> createState() => _TeacherRecordedState();
}

class _TeacherRecordedState extends State<TeacherRecorded> {
  bool _playAudio = false;
  late AudioPlayer _audioPlayer;
  Duration? _audioDuration;
  Duration? _currentPosition;
  DateTime? _recordingDateTime;
  String recordingDate = "";
  String durationText = "";
  String remainingTime = "";
  double progress = 0.0;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudio();

    // Listen to position changes
    setState(() {
      _recordingDateTime = DateTime.parse(
          widget.classDetails?.classRecordings?.first.timeRecorded ??
              DateTime.now().toIso8601String());
      recordingDate = _recordingDateTime != null
          ? DateFormat('MMM dd, yyyy - hh:mm a').format(_recordingDateTime!)
          : 'N/A';
      durationText = _audioDuration != null
          ? _formatDuration(_audioDuration!)
          : '00:00:00';
      remainingTime = _audioDuration != null && _currentPosition != null
          ? _formatDuration(_audioDuration! - _currentPosition!)
          : '00:00:00';
      progress = _audioDuration != null && _currentPosition != null
          ? _currentPosition!.inMilliseconds / _audioDuration!.inMilliseconds
          : 0.0;
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    // Listen for when the audio completes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _playAudio = false; // Switch back to play icon
          _currentPosition = Duration.zero; // Reset position
        });
      }
    });
  }

  Future<void> _initializeAudio() async {
    try {
      // Set the source URL
      await _audioPlayer.setSourceUrl(
          widget.classDetails?.classRecordings?.first.recordUrl ?? "");

      // Get the duration
      final duration = await _audioPlayer.getDuration();

      setState(() {
        _audioDuration = duration;
      });
    } catch (e) {
      log("AUDIO_ERROR: ${e.toString()}");
    }
  }
  Future<void> playFunc() async {
    if (_currentPosition != null && _currentPosition!.inMilliseconds > 0) {
      // Resume from the paused position
      await _audioPlayer.seek(_currentPosition!);
      await _audioPlayer.resume();
    } else {
      if (widget.classDetails?.classRecordings?.first.recordUrl?.isEmpty ==
          true) {
        Alert.displaySnackBar(context, message: "Could not load audio url");
        return;
      }
      // Start from the beginning
      await _audioPlayer.play(UrlSource(
          widget.classDetails?.classRecordings?.first.recordUrl ?? ""));
    }
  }

  Future<void> pauseFunc() async {
    await _audioPlayer.pause(); // Pause instead of stop to retain position
  }

  Future<void> seekAudio(double value) async {
    if (_audioDuration != null) {
      final newPosition = _audioDuration! * value;
      await _audioPlayer.seek(newPosition);
      setState(() {
        _currentPosition = newPosition;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(14.w, 6.h, 6.w, 4.h),
            child: SvgPicture.asset(
              'assets/icons/back_arrow_icon.svg',
              fit: BoxFit.none,
              height: 50.h,
              width: 50.w,
            ),
          ),
        ),
        leadingWidth: 45.w,
        title: Text(
          '${widget.classDetails?.subject?.name}',
          style: TextStyle(fontSize: 24.sp),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.05,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [whiteShades[0], blueShades[3]],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: redShades[0],
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset('assets/icons/smile.svg'),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: redShades[0],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: EdgeInsets.all(1.r),
                              child: SvgPicture.asset(
                                'assets/icons/yellow_star.svg',
                              ),
                            ),
                          )..add(
                              Padding(
                                padding: EdgeInsets.all(1.r),
                                child: SvgPicture.asset(
                                  'assets/icons/solar_star-bold.svg',
                                ),
                              ),
                            ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$recordingDate - $durationText',
                        style:
                            setTextTheme(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Properly Taught',
                        style: setTextTheme(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  width: 320.47.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: blueShades[14],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _playAudio = !_playAudio;
                              });
                              if (_playAudio) {
                                playFunc();
                              } else {
                                pauseFunc();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: redShades[0],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: _playAudio
                                  ? SvgPicture.asset('assets/icons/pause.svg')
                                  : SvgPicture.asset(
                                      'assets/icons/play_icon.svg'),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Column(
                            children: [
                              Text(
                                "${widget.classDetails?.subject?.teacher?.firstName} ${widget.classDetails?.subject?.teacher?.lastName}",
                                style: setTextTheme(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: whiteShades[0],
                                ),
                              ),
                              Text(
                                recordingDate,
                                style: setTextTheme(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: whiteShades[0],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            durationText,
                            style: setTextTheme(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp,
                              color: whiteShades[0],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            remainingTime,
                            style: setTextTheme(
                              fontWeight: FontWeight.w400,
                              fontSize: 8.sp,
                              color: whiteShades[0],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final newValue =
                              (details.localPosition.dx / context.size!.width)
                                  .clamp(0.0, 1.0);
                          seekAudio(newValue);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 2.h,
                          decoration: BoxDecoration(color: whiteShades[0]),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.black,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(whiteShades[0]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Teaching Summary',
                    style: setTextTheme(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Our Mission is to enable schools function effectively without barriers, '
                  'Having schools to run hybrid, Remote and On-site enabling them expand their horizon, '
                  'this will enable schools not only develop local curriculums but a more standard curriculum '
                  'that will enable students from around the country enroll in their school.',
                  style: setTextTheme(
                      fontSize: 14.sp, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
