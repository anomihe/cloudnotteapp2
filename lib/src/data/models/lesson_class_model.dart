class LessonClassModel {
  LessonClassModel({
    required this.videoUrl,
    required this.lessonTitle,
    required this.teacherImage,
    required this.teacherName,
    required this.messageCount,
    required this.lessonText,
  });

  final String videoUrl;
  final String lessonTitle;
  final String teacherImage;
  final String teacherName;
  final int messageCount;
  final String lessonText;
}
