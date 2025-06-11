import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/one_to_one.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import '../../../data/models/course_items_model.dart';

class CourseLessonScreen extends StatefulWidget {
  static const String routeName = '/course-lesson';
  final CourseItemsModel course;
  final LessonItem lesson;
  final int currentLessonIndex;

  const CourseLessonScreen({
    super.key,
    required this.course,
    required this.lesson,
    required this.currentLessonIndex,
  });

  @override
  State<CourseLessonScreen> createState() => _CourseLessonScreenState();
}

class _CourseLessonScreenState extends State<CourseLessonScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _showControls = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.lesson.lessonVideoUrl),
      );
      await _controller.initialize();
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _exitFullScreen();
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        _exitFullScreen();
      }
    });
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFullScreen
          ? buildVideoPlayer()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildVideoPlayer(),
                    Padding(
                      padding: EdgeInsets.all(15.r),
                      child: Column(
                        spacing: 20.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTeacherInfo(),
                          _buildCourseDetails(),
                          // _buildLessonSummary(),
                          _buildAssessments(),
                          _buildLessonsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildVideoPlayer() {
    if (!_isInitialized) {
      return Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls; // Toggle all controls on tap
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: _isFullScreen
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height / 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _isFullScreen ? 2.22 : 1.8,
              // aspectRatio: _isFullScreen ? 2.22 : _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (_showControls) buildVideoControls(),
          ],
        ),
      ),
    );
  }

  Widget buildVideoControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.1),
                  Color.fromRGBO(0, 0, 0, 0.7),
                ],
              ),
            ),
          ),
          Center(
            child: buildControlButton(
              icon: _isPlaying ? Icons.pause : Icons.play_arrow,
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              size: _isFullScreen ? 100.r : 40.r,
            ),
          ),
          // Bottom controls
          Positioned(
            left: 5.w,
            right: 5.w,
            bottom: 10.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      formatDuration(_controller.value.position),
                      style: setTextTheme(fontSize: 12.sp, color: Colors.white),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        colors: VideoProgressColors(
                          playedColor: blueShades[0],
                          bufferedColor: Color.fromRGBO(255, 255, 255, 0.5),
                          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      formatDuration(_controller.value.duration),
                      style: setTextTheme(fontSize: 12.sp, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    buildControlButton(
                        icon: _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        onTap: _toggleFullScreen,
                        size: _isFullScreen ? 60.r : 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 30.0,
    Color? boxCol,
    Color? iconCol,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: boxCol ?? Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Icon(
          icon,
          color: iconCol ?? Colors.white,
          size: size,
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildTeacherInfo() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.courseTitle,
                style: setTextTheme(fontSize: 18.sp)),
            Row(
              children: [
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage(widget.course.teacherProfilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Row(
                  children: [
                    Text(
                      '${widget.course.teacherName} | ',
                      style: setTextTheme(fontWeight: FontWeight.w400),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.r, horizontal: 10),
                      decoration: BoxDecoration(
                        color: redShades[10],
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        widget.course.subject,
                        style:
                            setTextTheme(fontSize: 10.sp, color: redShades[11]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // context.push(OneToOneCallScreen.routeName);
          },
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color:
                  ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: ThemeProvider().isDarkMode
                    ? Colors.transparent
                    : blueShades[18],
              ),
            ),
            child: Icon(Icons.file_download_outlined, color: blueShades[0]),
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget _buildCourseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: setTextTheme(fontSize: 15.sp)),
        SizedBox(height: 5.h),
        Text(widget.course.description,
            style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildLessonSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lesson Summary', style: setTextTheme(fontSize: 15.sp)),
        SizedBox(height: 5.h),
        Text(
          widget.lesson.lessonSummaryText,
          style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10.h),
        Text('Lesson Details', style: setTextTheme(fontSize: 15.sp)),
        SizedBox(height: 5.h),
        Text(
          widget.lesson.description,
          style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildAssessments() {
    if (widget.lesson.assessments == null ||
        widget.lesson.assessments!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assessments', style: setTextTheme(fontWeight: FontWeight.w600)),
        SizedBox(height: 10.h),
        ...widget.lesson.assessments!.map((assessment) => Container(
              margin: EdgeInsets.only(bottom: 5.h),
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : blueShades[17],
                border: Border.all(
                  color: ThemeProvider().isDarkMode
                      ? Colors.transparent
                      : blueShades[18],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment, color: blueShades[0]),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      assessment,
                      style: setTextTheme(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            )),
        Stack(
          children: [
            Container(
              // the assessment box
              height: 120.h,
              width: 361.w,
              decoration: BoxDecoration(
                color: purpleShades[0],
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            Positioned(
              top: 20.h,
              right: 10.w,
              child: SvgPicture.asset(
                'assets/icons/time_sand_icon.svg',
                colorFilter: ColorFilter.mode(
                  blueShades[13],
                  BlendMode.srcIn,
                ),
                fit: BoxFit.none,
              ),
            ),
            Positioned(
              right: 18.w,
              bottom: 20.h,
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: whiteShades[0],
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Center(
                  child: Text(
                    '10 Marks',
                    style: setTextTheme(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Container(
                      width: 46.w,
                      height: 41.h,
                      decoration: BoxDecoration(
                        color: redShades[2],
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 25.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Largest bone in the body',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: setTextTheme(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                        lineHeight: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLessonsList() {
    final nextIndex = widget.currentLessonIndex + 1;
    if (nextIndex >= widget.course.lessons.length) {
      return const SizedBox.shrink();
    }
    final nextLesson = widget.course.lessons[nextIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Next Topic', style: setTextTheme(fontWeight: FontWeight.w600)),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
            border: Border.all(
              color: ThemeProvider().isDarkMode
                  ? Colors.transparent
                  : blueShades[18],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            onTap: () {
              context.push(
                CourseLessonScreen.routeName,
                extra: (
                  course: widget.course,
                  lesson: nextLesson,
                  currentLessonIndex: nextIndex,
                ),
              );
            },
            leading: Icon(
              nextLesson.isCompleted ? Icons.check_circle : Icons.play_circle,
              color: nextLesson.isCompleted ? Colors.green : blueShades[0],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nextLesson.title, style: setTextTheme(fontSize: 14.sp)),
                Text(nextLesson.duration.toString(),
                    style: setTextTheme(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
