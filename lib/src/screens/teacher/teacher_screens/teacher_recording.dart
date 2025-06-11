// ignore_for_file: use_build_context_synchronously

/*
this file contains the teacher recording screen. 
after the recording is saved, the user can view more information about the recording.
 */

import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/models/recording_model.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/recording_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';

import 'package:cloudnottapp2/src/data/repositories/file_uploader_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_recorded.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'dart:async';

class TeacherRecording extends StatefulWidget {
  static const String routeName = "/teacher_recording_screen";
  const TeacherRecording({super.key, required this.classDetails});

  final ClassTimeTable? classDetails;

  @override
  State<TeacherRecording> createState() => _TeacherRecordingState();
}

class _TeacherRecordingState extends State<TeacherRecording>
    with SingleTickerProviderStateMixin {
  bool _playAudio = false;
  bool isRecording = false;
  bool recordCompleted = false;
  late String _timerText = '00:00:00';
  Timer? _timer;
  int _secondsElapsed = 0;
  Duration? _audioDuration;
  Duration? _currentPosition;

  List<String?> myRecord = [];
  late AudioRecorder _audioRecorder;
  late AudioPlayer _audioPlayer;
  String? recordedFilePath;

  // Animation Controller
  double? firstHeight = 204.h;
  double? firstWidth = 204.w;
  double? secondHeight = 140.h;
  double? secondWidth = 140.w;

  String selectedRecordedTopic = '';
  List<String> recordedTopics = [];
  List<LessonNoteModel>? lessons;
  LessonNoteModel? selectedLessonNote;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String termId =
          context.read<UserProvider>().data?.currentSpaceTermId ?? "";
      await Provider.of<LessonNotesProvider>(context, listen: false)
          .fetchLessonNotes(
        spaceId: context.read<UserProvider>().spaceId,
        input: GetLessonNotesInput(
          classGroupId: widget.classDetails?.classInfo?.classGroupId ?? "id",
          subjectId: widget.classDetails?.subject?.id ?? "",
          termId: termId,
        ),
      );
      lessons = context.read<LessonNotesProvider>().lessonNotes;
      if (lessons != null) {
        recordedTopics = lessons!.map((note) => note.topic).toList();
        selectedRecordedTopic = recordedTopics.first;
        selectedLessonNote = lessons!.first;
      }
    });
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _audioDuration = duration;
      });
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _playAudio = false;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        _timerText = _formatTime(_secondsElapsed);
      });
      if (timer.tick.isOdd) {
        firstHeight = 160.h;
        firstWidth = 160.h;
        secondHeight = 120.w;
        secondWidth = 120.w;
      } else {
        firstHeight = 204.h;
        firstWidth = 204.w;
        secondHeight = 140.h;
        secondWidth = 140.w;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerText = '00:00:00';
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  Future<void> startRecording() async {
      if (lessons == null || lessons!.isEmpty) {
    Alert.displaySnackBar(context, message: "No lesson note available to record.");
    return;
  }
    if (await _audioRecorder.hasPermission()) {
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath =
          '${appDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      setState(() {
        isRecording = true;
        recordedFilePath = filePath;
      });

      _startTimer(); // Start timer
    }
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      setState(() {
        recordedFilePath = path;
      });

      _stopTimer(); // Stop timer
    }
  }

  void cancelRecording() async {
    await _audioRecorder.cancel();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> playFunc() async {
    if (recordedFilePath != null) {
      await _audioPlayer.play(DeviceFileSource(recordedFilePath!));
    }
  }

  Future<void> pauseFunc() async {
    await _audioPlayer.pause();
  }

  Future<void> stopPlayFunc() async {
    await _audioPlayer.stop();
  }

  Future<void> seekToPosition(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void saveRecording() async {
    try {
       if (selectedLessonNote == null) {
      Alert.displaySnackBar(context, message: "Please select a topic before saving.");
      return;
    }
      if (recordedFilePath != null) {
        localStore.put('recordings', [recordedFilePath]);
        // final File recordedFile = File(recordedFilePath!);
        await Provider.of<FileUploadNotifier>(context, listen: false)
            .uploadRecordingFile(recordedFilePath!);
        log('FILE_URL ${context.read<FileUploadNotifier>().fileUrl}');
        final recordingProvider =
            Provider.of<RecordingProvider>(context, listen: false);
        log('TIMETABLE ${widget.classDetails?.id ?? ""}');
        await recordingProvider.saveRecording(
          context.read<UserProvider>().spaceId,
          CreateRecordingInput(
            lessonNoteId: selectedLessonNote?.id ?? "",
            recordUrl: context.read<FileUploadNotifier>().fileUrl ?? "",
            timeRecorded: DateTime.now().toIso8601String(),
            timetableId: widget.classDetails?.id ?? "",
          ),
        );
        if (recordingProvider.isError) {
          Alert.displaySnackBar(context,
              message: recordingProvider.errorResponse?.message ??
                  "Failed To Save Recording");
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Recording saved successfully!")),
        );
        context.push(StudentLandingScreen.routeName, extra: {
          'id': context.read<UserProvider>().spaceId,
          'provider': context.read<UserProvider>(),
          'currentIndex': 1,
        });
        stopPlayFunc();
      }
    } catch (error) {
      Alert.displaySnackBar(context, message: "Failed To Save Recording");
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durationText =
        _audioDuration != null ? _formatDuration(_audioDuration!) : '00:00:00';
    final remainingTime = _audioDuration != null && _currentPosition != null
        ? _formatDuration(_audioDuration! - _currentPosition!)
        : '00:00:00';
    final progress = _audioDuration != null && _currentPosition != null
        ? _currentPosition!.inMilliseconds / _audioDuration!.inMilliseconds
        : 0.0;

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
          "${widget.classDetails?.subject?.name}",
          style: setTextTheme(fontSize: 24.sp),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Record Teaching',
              style: setTextTheme(fontSize: 28.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 206.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  isRecording && !recordCompleted
                      ? AnimatedContainer(
                          duration: Duration(microseconds: 5),
                          height: firstHeight,
                          width: firstHeight,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: recordingColor[1],
                          ),
                        )
                      : Container(
                          height: 204.h,
                          width: 204.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: recordingColor[1],
                          ),
                        ),
                  isRecording && !recordCompleted
                      ? AnimatedContainer(
                          duration: Duration(microseconds: 5),
                          height: secondHeight,
                          width: secondWidth,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: recordingColor[0],
                          ),
                        )
                      : Container(
                          height: 140.h,
                          width: 140.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: recordingColor[0],
                          ),
                        ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isRecording) {
                            _playAudio = !_playAudio;
                            if (_playAudio) {
                              playFunc();
                            } else {
                              pauseFunc();
                            }
                          } else {
                            isRecording = !isRecording;
                            if (isRecording) {
                              startRecording.call();
                            } else {
                              stopRecording.call();
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(32.0),
                        height: 75.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: redShades[0],
                        ),
                        child: SvgPicture.asset(
                          !isRecording
                              ? 'assets/icons/recording_icon.svg'
                              : (recordCompleted
                                  ? (!_playAudio
                                      ? 'assets/icons/play_icon.svg'
                                      : 'assets/icons/pause.svg')
                                  : 'assets/icons/recording_icon.svg'),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (!isRecording)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRecording = true;
                  });
                  startRecording();
                },
                child: CustomButton(
                  text: 'Start recording',
                  buttonColor: redShades[0],
                ),
              )
            else ...[
              Container(
                padding: EdgeInsets.all(10.r),
                width: 320.47.w,
                height: 98.h,
                decoration: BoxDecoration(
                  color: blueShades[14],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    if (recordCompleted)
                      Text(
                        durationText,
                        style: setTextTheme(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: whiteShades[0],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (recordCompleted)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Cancel & Delete'),
                                  content:
                                      Text('Do you want to delete this record'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isRecording = false;
                                          recordCompleted = false;
                                        });
                                        cancelRecording();
                                        stopPlayFunc();
                                        Navigator.pop(ctx);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: goldenShades[1],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/fxemoji_cancellationx.svg',
                              ),
                            ),
                          ),
                        Text(
                          recordCompleted ? remainingTime : _timerText,
                          style: setTextTheme(
                            fontWeight: FontWeight.w400,
                            fontSize: 26.sp,
                            color: whiteShades[0],
                          ),
                        ),
                        if (!recordCompleted)
                          GestureDetector(
                            onTap: () async {
                              await stopRecording(); // Stop recording but keep UI state
                              setState(() {
                                _playAudio = true; // Enable playback mode
                                recordCompleted = true;
                              });
                              playFunc(); // Start playing the recording
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Recording completed!")),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              height: 58.h,
                              decoration: BoxDecoration(
                                color: goldenShades[0],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:
                                  SvgPicture.asset('assets/icons/continue.svg'),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    if (recordCompleted)
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (_audioDuration != null) {
                            final newPosition = _currentPosition! +
                                Duration(
                                    milliseconds:
                                        (details.primaryDelta! * 1000).toInt());
                            if (newPosition.inMilliseconds >= 0 &&
                                newPosition.inMilliseconds <=
                                    _audioDuration!.inMilliseconds) {
                              seekToPosition(newPosition);
                            }
                          }
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
              SizedBox(height: 30.h),
              Text(
                'What topic are you teaching?',
                style:
                    setTextTheme(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5.h),
              Container(
                width: 300.sp,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [whiteShades[0], blueShades[3]],
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRecordedTopic,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRecordedTopic = newValue!;
                        selectedLessonNote = lessons!
                            .firstWhere((note) => note.topic == newValue);
                      });
                    },
                    items: recordedTopics
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: setTextTheme(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                      );
                    }).toList(),
                    icon: Icon(CupertinoIcons.chevron_down),
                    dropdownColor: blueShades[3],
                    isExpanded: true, // Ensures full width
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (recordCompleted)
                Consumer2<FileUploadNotifier, RecordingProvider>(builder:
                    (context, fileUploadNotifier, recordingProvider, _) {
                  bool isLoading = recordingProvider.isLoading ||
                      fileUploadNotifier.isUploading;
                  return GestureDetector(
                    onTap: saveRecording,
                    child: CustomButton(
                      text: isLoading ? "Saving" : 'Save',
                      buttonColor: redShades[0],
                    ),
                  );
                }),
            ],
          ],
        ),
      ),
    );
  }
}
