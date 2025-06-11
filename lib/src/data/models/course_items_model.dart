class CourseItemsModel {
  final String courseTitle;
  final String status;
  final bool isPurchased;
  final String teacherName;
  final String imageUrl;
  final String review;
  final String subject;
  final String summaryText;
  final String teacherProfilePic;
  final int totalReviews;
  final String description;
  final DateTime publishedDate;
  final int enrolledStudents;
  final List<LessonItem> lessons;

  const CourseItemsModel({
    required this.courseTitle,
    required this.status,
    required this.isPurchased,
    required this.teacherName,
    required this.imageUrl,
    required this.review,
    required this.subject,
    required this.summaryText,
    required this.teacherProfilePic,
    required this.description,
    required this.publishedDate,
    required this.enrolledStudents,
    required this.lessons,
    this.totalReviews = 0,
  });

  double get totalLessonHours {
    return lessons.fold(0.0, (sum, lesson) => sum + lesson.duration);
  }

  int get totalLessons {
    return lessons.length.toInt();
  }

  int get completedLessons {
    return lessons.where((lesson) => lesson.isCompleted).length.toInt();
  }

  double get progressPercentage {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons) * 100;
  }
}

class LessonItem {
  final String title;
  final double duration;
  final bool isCompleted;
  final String coverVideoUrl;
  final String lessonVideoUrl;
  final String lessonSummaryText;
  final String description;
  final List<String>? assessments;

  const LessonItem({
    required this.coverVideoUrl,
    required this.lessonVideoUrl,
    required this.title,
    required this.duration,
    required this.lessonSummaryText,
    required this.description,
    this.isCompleted = false,
    this.assessments,
  });
}
