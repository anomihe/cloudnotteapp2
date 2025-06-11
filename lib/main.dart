import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloudnottapp2/src/data/repositories/result_repositories.dart';
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/ai_provider.dart'
    show AiContentProvider;

import 'package:cloudnottapp2/src/data/providers/chat_provider.dart';
import 'package:cloudnottapp2/src/data/providers/recording_provider.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/repositories/accounting_repositories.dart';
import 'package:cloudnottapp2/src/data/repositories/chat_repository.dart';
import 'package:cloudnottapp2/src/data/repositories/recording_repository.dart';
import 'package:cloudnottapp2/src/data/repositories/result_repositories.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/data/repositories/auth_repository.dart';
import 'package:cloudnottapp2/src/data/repositories/exam_or_home_work_repo.dart';
import 'package:cloudnottapp2/src/data/repositories/file_uploader_provider.dart';
import 'package:cloudnottapp2/src/data/repositories/lesson_note_repo.dart';
import 'package:cloudnottapp2/src/data/repositories/user_repository.dart';
import 'package:cloudnottapp2/src/data/service/chat_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloudnottapp2/src/app.dart';
import 'package:cloudnottapp2/src/data/providers/live_kit_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// @pragma('vm:entry-point')
// Future<bool> startForegroundService() async {
//   try {
//     const androidConfig = FlutterBackgroundAndroidConfig(
//       notificationTitle: 'Title of the notification',
//       notificationText: 'Text of the notification',
//     );
//     await FlutterBackground.initialize(androidConfig: androidConfig);
//     return true;
//   } catch (e) {
//     log("Error initializing background: $e");
//     return false;
//   }
// }

// @pragma('vm:entry-point')
// Future<bool> startForegroundService() async {
//   try {
//     if (Platform.isAndroid) { 
//       const androidConfig = FlutterBackgroundAndroidConfig(
//         notificationTitle: 'cloudnottapp2 Background Service',
//         notificationText: 'Keeping your session active',
//       );
//       await FlutterBackground.initialize(androidConfig: androidConfig);
//     }
//     return true;
//   } catch (e) {
//     log("Error initializing background: $e");
//     return false;
//   }}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   await Permission.camera.request();
//   await Permission.microphone.request();
//   //hive
//   final dir = await getApplicationSupportDirectory();
//   Hive.init(dir.path);
//   await Hive.openBox("localStorage");

//   //background service
//   await startForegroundService();

//   await Firebase.initializeApp();

//   await SentryFlutter.init(
//     (options) {
//       options.dsn =
//           'https://ffb93211af0cc811406770ba05aec487@o4509158108430336.ingest.us.sentry.io/4509158113148928';
//       options.sendDefaultPii = true;
//     },
//     appRunner: () => runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//           ChangeNotifierProvider<ChatService>(create: (_) => ChatService()),
//           ChangeNotifierProvider(create: (_) => FreeAiProvider()),
//           ChangeNotifierProvider(create: (context) => AiContentProvider()),
//           ChangeNotifierProvider<FileUploadNotifier>(
//               create: (_) => FileUploadNotifier()),

//           Provider<AccountingRepositories>(
//               create: (_) => AccountingRepositoriesImpl()),
//           ChangeNotifierProvider(
//             create: (context) => AccountingProvider(
//               accountProvider: context.read<AccountingRepositories>(),
//             ),
//           ),

//           Provider<ResultRepositories>(create: (_) => ResultRepositoryImpl()),
//           ChangeNotifierProvider(
//             create: (context) => ResultProvider(
//               resultProvider: context.read<ResultRepositories>(),
//             ),
//           ),

//           Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
//           ChangeNotifierProvider(
//             create: (context) => AuthProvider(
//               authRepository: context.read<AuthRepository>(),
//             ),
//           ),
//           Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
//           ChangeNotifierProvider(
//             create: (context) => UserProvider(
//               userRepository: context.read<UserRepository>(),
//             ),
//           ),
//           //RECORDING
//           Provider<RecordingRepository>(
//               create: (_) => RecordingRepositoryImpl()),
//           ChangeNotifierProvider<RecordingProvider>(
//             create: (context) => RecordingProvider(
//               recordingRepository: context.read<RecordingRepository>(),
//             ),
//           ),
//           //CHAT REPO
//           Provider<ChatRepository>(create: (_) => ChatRepositoryImpl()),
//           ChangeNotifierProvider(
//             create: (context) => ChatProvider(
//               chatRepository: context.read<ChatRepository>(),
//             ),
//           ),
//           ChangeNotifierProvider(
//             create: (_) => LiveKitController(),
//           ),

//           // Lesson Notes
//           Provider<LessonNotesRepository>(
//             create: (_) => LessonNotesRepositoryImpl(),
//           ),
//           ChangeNotifierProvider<LessonNotesProvider>(
//             create: (context) => LessonNotesProvider(
//               lessonNoteRepository: context.read<LessonNotesRepository>(),
//             ),
//           ),
//           //exam
//           Provider<ExamOrHomeWorkRepo>(
//             create: (_) => ExamOrHomeWorkRepoImpl(),
//           ),
//           ChangeNotifierProvider<ExamHomeProvider>(
//             create: (context) => ExamHomeProvider(
//               examOrHomeWorkRepo: context.read<ExamOrHomeWorkRepo>(),
//             ),
//           ),
//         ],
//         child: SentryWidget(
//           child: const MyApp(),
//         ),
//       ),
//     ),
//   );
// }

@pragma('vm:entry-point')
Future<bool> startForegroundService() async {
  try {
    if (Platform.isAndroid) { 
      const androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: 'cloudnottapp2 Background Service',
        notificationText: 'Keeping your session active',
      );
      await FlutterBackground.initialize(androidConfig: androidConfig);
      return true;
    } else if (Platform.isIOS) {
      // iOS doesn't need flutter_background, handle iOS-specific background tasks here if needed
      log("iOS background service handling - no action needed");
      return true;
    }
    return true;
  } catch (e, stackTrace) {
    log("Error initializing background service: $e");
    Sentry.captureException(e, stackTrace: stackTrace);
    return false;
  }
}

Future<void> _requestPermissions() async {
  try {
    // Request permissions with proper error handling
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    
    log("Camera permission: $cameraStatus");
    log("Microphone permission: $microphoneStatus");
    
    // Handle denied permissions gracefully
    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      log("Some permissions were denied, but continuing app initialization");
    }
  } catch (e, stackTrace) {
    log("Permission request failed: $e");
    Sentry.captureException(e, stackTrace: stackTrace);
    // Don't crash the app, just log the error
  }
}

Future<void> _initializeHive() async {
  try {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    await Hive.openBox("localStorage");
    log("Hive initialized successfully");
  } catch (e, stackTrace) {
    log("Hive initialization failed: $e");
    Sentry.captureException(e, stackTrace: stackTrace);
    // Don't crash the app, just log the error
  }
}

Future<void> _initializeBackgroundService() async {
  try {
    final success = await startForegroundService();
    if (success) {
      log("Background service initialized successfully");
    } else {
      log("Background service initialization failed, but continuing");
    }
  } catch (e, stackTrace) {
    log("Background service initialization error: $e");
    Sentry.captureException(e, stackTrace: stackTrace);
    // Don't crash the app, just log the error
  }
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    log("Firebase initialized successfully");
  } catch (e, stackTrace) {
    log("Firebase initialization failed: $e");
    Sentry.captureException(e, stackTrace: stackTrace);
    // This might be more critical, but still try to continue
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations with error handling
    try {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } catch (e) {
      log("Failed to set orientation: $e");
    }
    
    // Initialize components with individual error handling
    await _requestPermissions();
    await _initializeHive();
    await _initializeBackgroundService();
    await _initializeFirebase();

    // Initialize Sentry with error handling
    await SentryFlutter.init(
      (options) {
        // Consider using environment variables for sensitive data
        options.dsn = const String.fromEnvironment(
          'SENTRY_DSN',
          defaultValue: 'https://ffb93211af0cc811406770ba05aec487@o4509158108430336.ingest.us.sentry.io/4509158113148928',
        );
        options.sendDefaultPii = true;
        options.environment = const String.fromEnvironment('SENTRY_ENVIRONMENT', defaultValue: 'production');
      },
      appRunner: () => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider<ChatService>(create: (_) => ChatService()),
            ChangeNotifierProvider(create: (_) => FreeAiProvider()),
            ChangeNotifierProvider(create: (context) => AiContentProvider()),
            ChangeNotifierProvider<FileUploadNotifier>(
                create: (_) => FileUploadNotifier()),

            Provider<AccountingRepositories>(
                create: (_) => AccountingRepositoriesImpl()),
            ChangeNotifierProvider(
              create: (context) => AccountingProvider(
                accountProvider: context.read<AccountingRepositories>(),
              ),
            ),

            Provider<ResultRepositories>(create: (_) => ResultRepositoryImpl()),
            ChangeNotifierProvider(
              create: (context) => ResultProvider(
                resultProvider: context.read<ResultRepositories>(),
              ),
            ),

            Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
            ChangeNotifierProvider(
              create: (context) => AuthProvider(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
            ChangeNotifierProvider(
              create: (context) => UserProvider(
                userRepository: context.read<UserRepository>(),
              ),
            ),
            //RECORDING
            Provider<RecordingRepository>(
                create: (_) => RecordingRepositoryImpl()),
            ChangeNotifierProvider<RecordingProvider>(
              create: (context) => RecordingProvider(
                recordingRepository: context.read<RecordingRepository>(),
              ),
            ),
            //CHAT REPO
            Provider<ChatRepository>(create: (_) => ChatRepositoryImpl()),
            ChangeNotifierProvider(
              create: (context) => ChatProvider(
                chatRepository: context.read<ChatRepository>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => LiveKitController(),
            ),

            // Lesson Notes
            Provider<LessonNotesRepository>(
              create: (_) => LessonNotesRepositoryImpl(),
            ),
            ChangeNotifierProvider<LessonNotesProvider>(
              create: (context) => LessonNotesProvider(
                lessonNoteRepository: context.read<LessonNotesRepository>(),
              ),
            ),
            //exam
            Provider<ExamOrHomeWorkRepo>(
              create: (_) => ExamOrHomeWorkRepoImpl(),
            ),
            ChangeNotifierProvider<ExamHomeProvider>(
              create: (context) => ExamHomeProvider(
                examOrHomeWorkRepo: context.read<ExamOrHomeWorkRepo>(),
              ),
            ),
          ],
          child: SentryWidget(
            child: const MyApp(),
          ),
        ),
      ),
    );
  } catch (e, stackTrace) {
    // If Sentry initialization fails, still try to run the app
    log("Critical initialization error: $e");
    debugPrint('Critical initialization error: $e\n$stackTrace');
    
    // Try to run the app without Sentry if needed
    try {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            // Add other providers as needed for fallback
          ],
          child: const MyApp(),
        ),
      );
    } catch (fallbackError) {
      log("Fallback app initialization also failed: $fallbackError");
    }
  }
} 
