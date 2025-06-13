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

    await _initializeHive();


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
          child: const MyApp(),
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
