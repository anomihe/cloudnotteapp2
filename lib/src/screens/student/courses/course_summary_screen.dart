import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/courses/course_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/course_items_model.dart';

class CourseSummaryScreen extends StatefulWidget {
  static const String routeName = '/course-learning';
  final CourseItemsModel course;

  const CourseSummaryScreen({super.key, required this.course});

  @override
  State<CourseSummaryScreen> createState() => _CourseSummaryScreenState();
}

class _CourseSummaryScreenState extends State<CourseSummaryScreen> {
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
        Uri.parse(widget.course.lessons[0].coverVideoUrl),
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

  String _getDayWithSuffix(DateTime date) {
    final day = date.day;
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildVideoPlayer(),
                          Padding(
                            padding: EdgeInsets.all(15.r),
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTeacherInfo(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailsCard(
                                      icon: Icons.calendar_today_rounded,
                                      label: 'Published',
                                      value:
                                          '${_getDayWithSuffix(widget.course.publishedDate)} ${DateFormat('MMMM, yyyy').format(widget.course.publishedDate)}',
                                    ),
                                    _buildDetailsCard(
                                      icon: Icons.people_alt,
                                      label: 'Enrolled',
                                      value: widget.course.enrolledStudents
                                          .toString(),
                                    ),
                                  ],
                                ),
                                _buildCourseDetails(),
                                _buildLessonsList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.course.isPurchased == false) _buildPaymentRow(),
                ],
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
            if (_showControls) _buildVideoControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
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
            child: _buildControlButton(
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
                      _formatDuration(_controller.value.position),
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
                      _formatDuration(_controller.value.duration),
                      style: setTextTheme(fontSize: 12.sp, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    _buildControlButton(
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

  Widget _buildControlButton({
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

  String _formatDuration(Duration duration) {
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
        Spacer(),
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: ThemeProvider().isDarkMode
                  ? Colors.transparent
                  : blueShades[18],
            ),
          ),
          child: Icon(Icons.file_download_outlined, color: blueShades[0]),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget _buildDetailsCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.sizeOf(context).width / 2.3,
      decoration: BoxDecoration(
        color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
        border: Border.all(
          color:
              ThemeProvider().isDarkMode ? Colors.transparent : blueShades[18],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: blueShades[0], size: 30),
          SizedBox(width: 5.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: setTextTheme(fontSize: 13.sp)),
              Text(value,
                  style: setTextTheme(
                      fontSize: 11.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
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

  Widget _buildLessonsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Topics', style: setTextTheme()),
            SizedBox(width: 15.w),
            Text(
              '(${widget.course.lessons.length} topics | ${_formatCourseDuration(widget.course.totalLessonHours)})',
              style: setTextTheme(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.course.lessons.length,
          separatorBuilder: (_, __) => SizedBox(height: 5),
          itemBuilder: (context, index) {
            final lesson = widget.course.lessons[index];
            return Container(
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
              child: ListTile(
                onTap: () {
                  context.push(
                    CourseLessonScreen.routeName,
                    extra: (
                      course: widget.course,
                      lesson: lesson,
                      currentLessonIndex: index,
                    ),
                  );
                },
                leading: Icon(
                  lesson.isCompleted ? Icons.check_circle : Icons.play_circle,
                  color: lesson.isCompleted ? Colors.green : blueShades[0],
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: setTextTheme(fontSize: 14.sp)),
                    Text('${lesson.duration.toStringAsFixed(0)} mins',
                        style:
                            setTextTheme(fontSize: 12.sp, color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

// helper method to formatting total duration
  String _formatCourseDuration(double totalMinutes) {
    if (totalMinutes <= 60) {
      return '${totalMinutes.toStringAsFixed(0)} mins';
    } else {
      final hours = (totalMinutes / 60).floor();
      final minutes = (totalMinutes % 60).toStringAsFixed(0);
      return '$hours hours $minutes mins';
    }
  }

  Widget _buildPaymentRow() {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 15.r, right: 15.r, bottom: 5.r),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: setTextTheme(
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'NGN 1,000',
                    style: setTextTheme(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Buttons(
                height: 45.h,
                width: 140.w,
                text: 'Buy Course',
                onTap: () {},
                isLoading: false,
              ),
            ],
          ),
        )
      ],
    );
  }
}
