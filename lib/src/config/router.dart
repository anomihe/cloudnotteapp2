import 'package:cloudnottapp2/src/data/local/mockdata/user_chat_mock_data.dart';
import 'package:cloudnottapp2/src/data/models/course_items_model.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:cloudnottapp2/src/screens/accounting/admin_fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/admin_transaction_history_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_details_screen.dart';
import 'package:cloudnottapp2/src/screens/app_screens/support_screen.dart';
import 'package:cloudnottapp2/src/screens/call_screens/one_to_one.dart';
import 'package:cloudnottapp2/src/screens/cloudnottapp2_ai/ai_call_screen.dart';
import 'package:cloudnottapp2/src/screens/cloudnottapp2_ai/ai_call_translation_settings_screen.dart';
import 'package:cloudnottapp2/src/screens/cloudnottapp2_ai/ai_chatting_screen.dart';
import 'package:cloudnottapp2/src/screens/cloudnottapp2_ai/ai_profile_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/auth_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chat_profile_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chatting_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_profile_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/add_chat_user_screen.dart';
import 'package:cloudnottapp2/src/screens/student/courses/browse_course_screen.dart';
import 'package:cloudnottapp2/src/screens/student/courses/course_lesson_screen.dart';
import 'package:cloudnottapp2/src/screens/student/courses/course_summary_screen.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/record_for_free_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learn_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learning_with_ai.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/view_all_topics.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/ai_generating_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/enter_teacher_lesson.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_lesson_view.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_view_lesson_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/make_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/call_settings_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/account_summary.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/change_password_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/join_space_request_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/link_new_user_account_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/link_user_account_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/notification_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/profile_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_history_screen.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/result_view_screen.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/student_score_entry_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/student_submission_view.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_recorded.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_recording.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/demo_start_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/homework_group_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/submission_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_stats_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_submission_view.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/screens/app_screens/splash_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/create_school_screens/create_school2.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/create_school_screens/view_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/find_schools.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/get_started_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/otp.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/forgotten_password.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/signin.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/welcome_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/school_profile.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_chatting_page.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/video_call_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_entry_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_question_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_ready_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_stats_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_submitted_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/lesson_class_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/class_schedules_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/live_class_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/recorded_class_screen.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:livekit_client/livekit_client.dart';
import '../data/providers/user_provider.dart';
import '../screens/onboarding_screens/create_school_screens/creat_school.dart';
import '../screens/onboarding_screens/join_school_screens/join_screen.dart';
import '../screens/onboarding_screens/onboarding_screens.dart/signup.dart';
import '../screens/onboarding_screens/onboarding_screens.dart/walk_throuh.dart';
import '../screens/onboarding_screens/widgets/model_class.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AuthScreen.routeName,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: StudentLandingScreen.routeName,
      builder: (context, state) {
        // Check if extra exists and is of correct type
        if (state.extra == null || state.extra is! Map<String, dynamic>) {
          return const Scaffold(
            body: Center(
              child: Text('Invalid navigation data'),
            ),
          );
        }

        final data = state.extra as Map<String, dynamic>;

        // Validate required parameters
        final id = data['id'] as String?;
        final userProvider = data['provider'] as UserProvider?;

        // Handle missing required data
        if (id == null || userProvider == null) {
          return const Scaffold(
            body: Center(
              child: Text('Missing required navigation parameters'),
            ),
          );
        }

        int currentIndex = data['currentIndex'] ?? 0;

        return StudentLandingScreen(
          id: id,
          value: userProvider,
          currentIndex: currentIndex,
        );
      },
    ),
    GoRoute(
      path: Rolls.routeName,
      builder: (context, state) => const Rolls(),
    ),
    GoRoute(
      path: SignInScreen.routeName,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: VerificationScreen.routeName,
      builder: (context, state) {
        final String email = state.extra as String;
        return VerificationScreen(
          email: email,
        );
      },
    ),
    GoRoute(
      path: ChangeForgottenPasswordScreen.routeName,
      builder: (context, state) {
        //final String email = state.extra as String;
        return ChangeForgottenPasswordScreen();
      },
    ),
    GoRoute(
      path: VerificationResetScreen.routeName,
      builder: (context, state) {
        final String email = state.extra as String;
        return VerificationResetScreen(
          email: email,
        );
      },
    ),
    GoRoute(
      path: ForgottenPasswordScreen.routeName,
      builder: (context, state) => const ForgottenPasswordScreen(),
    ),
    GoRoute(
      path: GetStartedScreen.routeName,
      builder: (context, state) => const GetStartedScreen(),
    ),
    GoRoute(
      path: WelcomeScreen.routeName,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: JoinScreen.routeName,
      builder: (context, state) => const JoinScreen(),
    ),
    GoRoute(
      path: ChooseSchool.routeName,
      builder: (context, state) => const ChooseSchool(),
    ),

    GoRoute(
      path: FindSchools.routeName,
      builder: (context, state) => const FindSchools(),
    ),
    GoRoute(
      path: Profil.routeName,
      builder: (context, state) {
        final profil = state.extra as SchoolModel;
        return Profil(
          schoolModel: profil,
        );
      },
    ),
    GoRoute(
      path: CreateSchool.routeName,
      builder: (context, state) => const CreateSchool(),
    ),
    GoRoute(
      path: CompleteSetUp.routeName,
      builder: (context, state) => const CompleteSetUp(),
    ),
    GoRoute(
      path: ViewSchool.routeName,
      builder: (context, state) => const ViewSchool(),
      // path: ClassSchedules.routeName,
      // builder: (context, state) => const ClassSchedules(),
    ),
    GoRoute(
      path: LiveClassScreen.routeName,
      builder: (context, state) {
        final param = state.extra as Map<String, dynamic>;
        return LiveClassScreen(
          callId: param['callId'],
          username: param['username'],
          userId: param['userId'],
          peerId: param['peerId'],
          room: param['room'] as Room?,
          listener: param['listener'] as EventsListener<RoomEvent>?,
        );
      },
    ),
    GoRoute(
      path: CallSettingsScreen.routeName,
      builder: (context, state) {
        String? callId = state.extra as String?;
        return CallSettingsScreen(
          callId: callId,
        );
      },
    ),
    GoRoute(
      path: GeneratedContentScreen.routeName,
      builder: (context, state) {
        final param = state.extra as Map<String, dynamic>;
        return GeneratedContentScreen(
          topic: param['topic'],
          noteId: param['noteId'],
          spaceId: param['spaceId'],
          subject: param['subject'],
          index: param['index'],
          classGroup: param['classGroup'],
          content: param['content'],
          id: param['id'],
          contentId: param['contentId'],
          mode: param['mode'],
        );
      },
    ),

    GoRoute(
      path: LessonNoteTeacherScreen.routeName,
      builder: (context, state) {
        final param = state.extra as Map<String, dynamic>;
        return LessonNoteTeacherScreen(
          spaceId: param['spaceId'],
          classGroupId: param['classGroupId'],
          termId: param['termId'],
          subjectId: param['subjectId'],
        );
      },
    ),
    GoRoute(
      path: ExamSubmissionsScreen.routeName,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final classGroupId = data['classGroupId'] as String;
        final examGroupId = data['examGroupId'] as String;
        final spaceId = data['spaceId'] as String;
        final title = data['title'] as String;
        final examIds = data['examIds'] as List<String> ?? [];
        return ExamSubmissionsScreen(
          examGroupId: examGroupId,
          classGroupId: classGroupId,
          spaceId: spaceId,
          title: title,
          examIds: examIds,
        );
      },
    ),
    GoRoute(
      path: RecordedClass.routeName,
      builder: (context, state) => const RecordedClass(),
    ),
    GoRoute(
        path: TeacherRecording.routeName,
        builder: (context, state) {
          final value = state.extra as ClassTimeTable?;
          return TeacherRecording(
            classDetails: value,
          );
        }),

    GoRoute(
      path: ClassSchedules.routeName,
      builder: (context, state) {
        final id = state.extra as String;
        return ClassSchedules(id: id);
      },
    ),
    GoRoute(
      path: UserChattingPage.routeName,
      builder: (context, state) {
        final userChatModel = state.extra as UserChatModel;
        return UserChattingPage(userChatModel: userChatModel);
      },
    ),
    GoRoute(
      path: GroupChattingPage.routeName,
      builder: (context, state) {
        final userChatModel = state.extra as UserChatModel;
        return GroupChattingPage(userChatModel: userChatModel);
      },
    ),
    GoRoute(
      path: AddChatUserScreen.routeName,
      builder: (context, state) {
        return AddChatUserScreen();
      },
    ),

    //homework sections
    GoRoute(
        path: DemoStartScreen.routeName,
        builder: (context, state) => const DemoStartScreen()),
    GoRoute(
      path: HomeworkEntryTabScreen.routeName,
      builder: (context, state) {
        String spaceId = state.error as String;
        return HomeworkEntryTabScreen(
          spaceId: spaceId,
        );
      },
    ),
    GoRoute(
      path: VideoCallScreen.routeName,
      builder: (context, state) => VideoCallScreen(),
    ),
    GoRoute(
      path: HomeworkReadyScreen.routeName,
      builder: (context, state) {
        // final homeworkModel = state.extra as HomeworkModel;
        final homeworkModel = state.extra as Map<String, dynamic>;
        final id = homeworkModel['id'] as String?;
        final spaceId = homeworkModel['spaceId'] as String?;
        final examGroupId = homeworkModel['examGroupId'] as String?;
        final examId = homeworkModel['examId'] as String?;
        final pin = homeworkModel['pin'] as String?;

        return HomeworkReadyScreen(
          //  homeworkModel: homeworkModel,
          spaceId: spaceId ?? '', id: id ?? '', examGroupId: examGroupId ?? '',
          examId: examId ?? '', pin: pin ?? '',
        );
      },
    ),
    GoRoute(
        path: HomeworkQuestionScreen.routeName,
        builder: (context, state) {
          // final homeworkModel = state.extra as HomeworkModel;
          final homeworkModel = state.extra as Map<String, dynamic>;
          final id = homeworkModel['id'] as String?;
          final spaceId = homeworkModel['spaceId'] as String?;
          final examGroupId = homeworkModel['examGroupId'] as String?;
          final examId = homeworkModel['examId'] as String?;
          final pin = homeworkModel['pin'] as String?;
          final subject = homeworkModel['subject'] as String?;
          return HomeworkQuestionScreen(
            // homeworkModel: homeworkModel,
            id: id ?? '',
            spaceId: spaceId ?? '',
            examGroupId: examGroupId ?? '',
            examId: examId ?? '',
            pin: pin ?? '',
            subject: subject ?? '',
          );
        }),
    // :TODO
    // GoRoute(
    //   path: HomeworkSubmissionScreen.routeName,
    //   builder: (context, state) {
    //     final data = state.extra as Map<String, dynamic>;

    //     return HomeworkSubmissionScreen(
    //       homeworkModel: data['homeworkModel'],
    //       selectedAnswers: data['selectedAnswers'],
    //       chosenAnswer: data['chosenAnswer'],
    //       uploadFiles: data['uploadFiles'], timer: data['timer'],

    //       // Pass the actual list here
    //     );
    //   },
    // ),
    GoRoute(
      path: HomeworkSubmittedScreen.routeName,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return HomeworkSubmittedScreen(
          session: data['session'],
          // homeworkModel: data['homeworkModel'],
          // selectedAnswers: data['selectedAnswers'],
          // chosenAnswer: data['chosenAnswer'], // Pass the actual list here
          // uploadFiles: data['uploadFiles'],
        );
      },
    ),

    // GoRoute(
    //     path: HomeworkCorrectionScreen.routeName,
    //     builder: (context, state) {
    //       final data = state.extra as Map<String, dynamic>;

    //       return HomeworkCorrectionScreen(
    //         homeworkModel: data['homeworkModel'],
    //         selectedAnswers: data['selectedAnswers'],
    //         chosenAnswer: data['chosenAnswer'],
    //         uploadFiles: data['uploadFiles'],
    //       );
    //     }),
    GoRoute(
        path: HomeworkStatsScreen.routeName,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return HomeworkStatsScreen(
            homeworkModel: data['homeworkModel'],
            selectedAnswers: data['selectedAnswers'],
            chosenAnswer: data['chosenAnswer'],
            uploadFiles: data['uploadFiles'],
          );
        }),

    GoRoute(
        path: ExamSummaryScreen.routeName,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return ExamSummaryScreen(
              spaceId: data['spaceId'],
              studentId: data['studentId'],
              examGroupId: data['examGroupId'],
              examId: data['examId'],
              id: data['id']);
        }),
    // GoRoute(
    //     path: TeacherEntryScreen.routeName,
    //     builder: (context, state) {
    //       final String id = state.extra as String;
    //       return TeacherEntryScreen(
    //         spaceId: id,
    //       );
    //     }),
    GoRoute(
        path: HomeworkGroupScreen.routeName,
        builder: (context, state) {
          //final homeworkModel = state.extra as HomeworkModel;
          final data = state.extra as Map<String, dynamic>;
          final homeworkModel = data['homeworkModel'] as String;
          final classGroupId = data['classGroupId'] as String;
          final examGroupId = data['examGroupId'] as String;
          final spaceId = data['spaceId'] as String;
          final examId = data['examId'] as List<String>;
          final classId = data['classId'] as String;
          return HomeworkGroupScreen(
            homeworkModel: homeworkModel,
            classGroupId: classGroupId,
            examIds: examId,
            examGroupId: examGroupId,
            spaceId: spaceId,
            classId: classId,
          );
        }),
    GoRoute(
        path: SubmissionScreen.routeName,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          // final studentModel = data['studentModel'] as StudentModel;
          // final classGroupId = data['classGroupId'] as String;
          final examGroupId = data['examGroupId'] as String;
          final spaceId = data['spaceId'] as String;
          return SubmissionScreen(
            // studentModel: studentModel,
            spaceId: spaceId,
            examGroupId: examGroupId,
            examId: data['examId'] as List<String>,
            classId: data['classId'] as String,
          );
        }),
    GoRoute(
      path: TeacherSubmissionView.routeName,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic> ?? {};
        return TeacherSubmissionView(
          spaceId: data['spaceId'] as String ?? '',
          examGroupId: data['examGroupId'] as String ?? '',
          examId: data['examId'] as String ?? '',
          id: data['id'] as String ?? '',
          studentId: data['studentId'] as String ?? '',
        );
      },
    ),
    GoRoute(
      path: StudentSubmissionView.routeName,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic> ?? {};
        return StudentSubmissionView(
          spaceId: data['spaceId'] as String ?? '',
          examGroupId: data['examGroupId'] as String ?? '',
          examId: data['examId'] as String ?? '',
          id: data['id'] as String,
          studentId: data['studentId'] as String ?? '',
        );
      },
    ),
    GoRoute(
        path: TeacherStatsScreen.routeName,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic> ?? {};
          final examId = data['examId'] ?? '';
          final examGroupId = data['examGroupId'] ?? '';  
          final spaceId = data['spaceId'] ?? '';
          return  TeacherStatsScreen(examId: examId, examGroupId: examGroupId, spaceId: spaceId,);
        }),
    GoRoute(
        path: TeacherRecorded.routeName,
        builder: (context, state) {
          final value = state.extra as ClassTimeTable?;
          return TeacherRecorded(
            classDetails: value,
          );
        }),
    GoRoute(
      path: LearnWithAi.routeName,
      builder: (context, state) => const LearnWithAi(),
    ),
    GoRoute(
      path: LearningWithAi.routeName,
      builder: (context, state) {
        final freeAiModel = state.extra as FreeAiModel;
        return LearningWithAi(freeAiModel: freeAiModel);
      },
    ),
    GoRoute(
      path: ViewAllTopics.routeName,
      builder: (context, state) => const ViewAllTopics(),
    ),
    GoRoute(
      path: LiveChatScreen.routeName,
      builder: (context, state) => const LiveChatScreen(),
    ),
    // GoRoute(
    //   path: FreeAiSettings.routeName,
    //   builder: (context, state) => const FreeAiSettings(),
    // ),
    GoRoute(
      path: RecordForFreeAi.routeName,
      builder: (context, state) => const RecordForFreeAi(), //syntax error
    ),
    GoRoute(
      path: LessonClassScreen.routeName,
      builder: (context, state) {
        // final lessonNoteModel = state.extra as LessonNoteModel;
        final data = state.extra as Map<String, dynamic>;
        return LessonClassScreen(
            lessonClassModel: data['lessonNoteModel'], spaceId: data['spaceId']
            // lessonClassModel: LessonClassModel(
            //   videoUrl: 'videoUrl',
            //   lessonTitle: 'lessonTitle',
            //   teacherImage: 'teacherImage',
            //   teacherName: 'teacherName',
            //   messageCount: 0,
            //   lessonText: 'lessonText',
            // ),
            );
      },
    ),
    GoRoute(
      path: LessonTeacherClassScreen.routeName,
      builder: (context, state) {
        // final lessonNoteModel = state.extra as LessonNoteModel;
        final data = state.extra as Map<String, dynamic>;
        return LessonTeacherClassScreen(
          lessonNotedId: data['lessonNoteId'],
          spaceId: data['spaceId'],
          topic: data['topic'],
        );
      },
    ),
    GoRoute(
      path: LessonNoteEditorScreen.routeName,
      builder: (context, state) {
        // final lessonNoteModel = state.extra as LessonNoteModel;
        final data = state.extra as Map<String, dynamic>;
        return LessonNoteEditorScreen(
          noteId: data['noteId'] ?? '',
          spaceId: data['spaceId'] ?? '',
          content: data['content'] ?? '',
          topic: data['topic'] ?? '',
          contentId: data['contentId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: LessonPlanEditorScreen.routeName,
      builder: (context, state) {
        // final lessonNoteModel = state.extra as LessonNoteModel;
        final data = state.extra as Map<String, dynamic>;
        return LessonPlanEditorScreen(
          noteId: data['noteId'] ?? '',
          spaceId: data['spaceId'] ?? '',
          content: data['content'] ?? '',
          topic: data['topic'] ?? '',
          id: data['id'] ?? '',
        );
      },
    ),
    GoRoute(
      path: ProfileScreen.routeName,
      builder: (context, state) {
        final value = state.extra as UserProvider;
        return ProfileScreen(
          value: value,
        );
      },
    ),
    GoRoute(
      path: AccountSummaryScreen.routeName,
      builder: (context, state) => AccountSummaryScreen(),
    ),
    GoRoute(
      path: ChangePasswordScreen.routeName,
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: LinkUserAccountScreen.routeName,
      builder: (context, state) => LinkUserAccountScreen(),
    ),
    GoRoute(
      path: LinkNewUserAccountScreen.routeName,
      builder: (context, state) => LinkNewUserAccountScreen(),
    ),
    GoRoute(
      path: JoinSpaceRequestScreen.routeName,
      builder: (context, state) => JoinSpaceRequestScreen(),
    ),
    GoRoute(
      path: NotificationScreen.routeName,
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(
      path: AiChattingScreen.routeName,
      builder: (context, state) {
        final aiChatDisplay = state.extra as UserChatModel;
        return AiChattingScreen(
          aiChatModel: aiChatDisplay,
        );
      },
    ),
    GoRoute(
      path: AiCallScreen.routeName,
      builder: (context, state) {
        return AiCallScreen(userChatModel: aiChatDisplay);
      },
    ),
    GoRoute(
      path: AiCallTranslationSettingsScreen.routeName,
      builder: (context, state) {
        return AiCallTranslationSettingsScreen();
      },
    ),
    GoRoute(
      path: AiProfileScreen.routeName,
      builder: (context, state) {
        return AiProfileScreen();
      },
    ),
    GoRoute(
      path: GroupChatProfileScreen.routeName,
      builder: (context, state) {
        return GroupChatProfileScreen();
      },
    ),
    GoRoute(
      path: UserProfileScreen.routeName,
      builder: (context, state) {
        final userChatModel = state.extra as UserChatModel;
        return UserProfileScreen(userChatModel: userChatModel);
      },
    ),
    GoRoute(
      path: StudentScoreEntryScreen.routeName,
      builder: (context, state) {
        // final scoreWidgetModel = state.extra as SubjectReportModel;
        final data = state.extra as Map<String, dynamic>;
        return StudentScoreEntryScreen(
          scoreWidgetModel: data['scoreWidgetModel'],
          spaceId: data['spaceId'],
          classId: data['classId'],
          assessmentId: data['assessmentId'],
        );
      },
    ),
    GoRoute(
      path: ResultViewScreen.routeName,
      builder: (context, state) {
        // final studentResultModel = state.extra as Student;
        final data = state.extra as Map<String, dynamic>;
        return ResultViewScreen(
          studentResultModel: data['studentResultModel'],
          termId: data['termId'],
          sessionId: data['sessionId'],
          assessmentId: data['assessmentId'],
          userId: data['userId'],
          classId: data['classId'],
          spaceId: data['spaceId'],
        );
      },
    ),
    GoRoute(
      path: FeePaymentScreen.routeName,
      builder: (context, state) {
        return FeePaymentScreen();
      },
    ),
    GoRoute(
      path: MakePaymentScreen.routeName,
      builder: (context, state) {
        return MakePaymentScreen();
      },
    ),
    GoRoute(
      path: TransactionHistoryScreen.routeName,
      builder: (context, state) {
        return const TransactionHistoryScreen();
      },
    ),
    GoRoute(
      path: AdminTransactionHistoryScreen.routeName,
      builder: (context, state) {
        return const AdminTransactionHistoryScreen();
      },
    ),
    GoRoute(
      path: TransactionDetailsScreen.routeName,
      builder: (context, state) {
        final transaction = state.extra as TransactionModel;
        return TransactionDetailsScreen(transaction: transaction);
      },
    ),

    GoRoute(
      path: AdminFeePaymentScreen.routeName,
      builder: (context, state) {
        return const AdminFeePaymentScreen();
      },
    ),
    GoRoute(
      path: BrowseCoursesScreen.routeName,
      builder: (context, state) => const BrowseCoursesScreen(),
    ),
    GoRoute(
      path: CourseSummaryScreen.routeName,
      builder: (context, state) {
        final course = state.extra as CourseItemsModel;
        return CourseSummaryScreen(course: course);
      },
    ),
    GoRoute(
      path: CourseLessonScreen.routeName,
      builder: (context, state) {
        final extra = state.extra as ({
          CourseItemsModel course,
          LessonItem lesson,
          int currentLessonIndex
        });
        return CourseLessonScreen(
          course: extra.course,
          lesson: extra.lesson,
          currentLessonIndex: extra.currentLessonIndex,
        );
      },
    ),
    GoRoute(
      path: OneToOneCallScreen.routeName,
      builder: (context, state) => const OneToOneCallScreen(),
    ),
  ],
);
