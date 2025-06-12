import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       // splitScreenMode: true,
//       builder: (_, child) {
//         return MaterialApp.router(
//           localizationsDelegates: const [
//             ...GlobalMaterialLocalizations.delegates,
//             quill.FlutterQuillLocalizations.delegate, // Add this delegate
//           ],
//           supportedLocales: const [
//             Locale('en'), // Add the locales you need
//           ],
//           // restorationScopeId: 'app',
//           debugShowCheckedModeBanner: false,
//           // theme: ThemeData.light(
//           //   useMaterial3: true,
//           // ),
//           theme: themeProvider.themeMode,
//           routeInformationParser: router.routeInformationParser,
//           routerDelegate: router.routerDelegate,
//           routeInformationProvider: router.routeInformationProvider,
//         );
//       },
//     );
//   }
// }
// Fixed main.dart



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

// void main() async {
//   // Add error handling for platform initialization
//   runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
    
//     // Add platform error handling
//     PlatformDispatcher.instance.onError = (error, stack) {
//       log('Platform error: $error');
//       log('Stack trace: $stack');
//       return true;
//     };
    
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
//     // Add try-catch for permissions
//     try {
//       await Permission.camera.request();
//       await Permission.microphone.request();
//     } catch (e) {
//       log("Permission error: $e");
//     }
    
//     //hive
//     final dir = await getApplicationSupportDirectory();
//     Hive.init(dir.path);
//     await Hive.openBox("localStorage");

//     //background service
//     await startForegroundService();

//     await Firebase.initializeApp();

//     await SentryFlutter.init(
//       (options) {
//         options.dsn =
//             'https://ffb93211af0cc811406770ba05aec487@o4509158108430336.ingest.us.sentry.io/4509158113148928';
//         options.sendDefaultPii = true;
//       },
//       appRunner: () => runApp(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => ThemeProvider()),
//             ChangeNotifierProvider<ChatService>(create: (_) => ChatService()),
//             ChangeNotifierProvider(create: (_) => FreeAiProvider()),
//             ChangeNotifierProvider(create: (context) => AiContentProvider()),
//             ChangeNotifierProvider<FileUploadNotifier>(
//                 create: (_) => FileUploadNotifier()),

//             Provider<AccountingRepositories>(
//                 create: (_) => AccountingRepositoriesImpl()),
//             ChangeNotifierProvider(
//               create: (context) => AccountingProvider(
//                 accountProvider: context.read<AccountingRepositories>(),
//               ),
//             ),

//             Provider<ResultRepositories>(create: (_) => ResultRepositoryImpl()),
//             ChangeNotifierProvider(
//               create: (context) => ResultProvider(
//                 resultProvider: context.read<ResultRepositories>(),
//               ),
//             ),

//             Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
//             ChangeNotifierProvider(
//               create: (context) => AuthProvider(
//                 authRepository: context.read<AuthRepository>(),
//               ),
//             ),
//             Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
//             ChangeNotifierProvider(
//               create: (context) => UserProvider(
//                 userRepository: context.read<UserRepository>(),
//               ),
//             ),
//             //RECORDING
//             Provider<RecordingRepository>(
//                 create: (_) => RecordingRepositoryImpl()),
//             ChangeNotifierProvider<RecordingProvider>(
//               create: (context) => RecordingProvider(
//                 recordingRepository: context.read<RecordingRepository>(),
//               ),
//             ),
//             //CHAT REPO
//             Provider<ChatRepository>(create: (_) => ChatRepositoryImpl()),
//             ChangeNotifierProvider(
//               create: (context) => ChatProvider(
//                 chatRepository: context.read<ChatRepository>(),
//               ),
//             ),
//             ChangeNotifierProvider(
//               create: (_) => LiveKitController(),
//             ),

//             // Lesson Notes
//             Provider<LessonNotesRepository>(
//               create: (_) => LessonNotesRepositoryImpl(),
//             ),
//             ChangeNotifierProvider<LessonNotesProvider>(
//               create: (context) => LessonNotesProvider(
//                 lessonNoteRepository: context.read<LessonNotesRepository>(),
//               ),
//             ),
//             //exam
//             Provider<ExamOrHomeWorkRepo>(
//               create: (_) => ExamOrHomeWorkRepoImpl(),
//             ),
//             ChangeNotifierProvider<ExamHomeProvider>(
//               create: (context) => ExamHomeProvider(
//                 examOrHomeWorkRepo: context.read<ExamOrHomeWorkRepo>(),
//               ),
//             ),
//           ],
//           child: SentryWidget(
//             child: const MyApp(),
//           ),
//         ),
//       ),
//     );
//   }, (error, stack) {
//     log('Unhandled error: $error');
//     log('Stack trace: $stack');
//   });
// }

// // Fixed MyApp class
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // Clean up resources
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       builder: (_, child) {
//         return MaterialApp.router(
//           // FIX 1: Add proper locale fallback handling
//           localeResolutionCallback: (locale, supportedLocales) {
//             // Handle case where locale might be null
//             if (locale == null) {
//               return const Locale('en');
//             }
            
//             // Check if the current locale is supported
//             for (var supportedLocale in supportedLocales) {
//               if (supportedLocale.languageCode == locale.languageCode) {
//                 return supportedLocale;
//               }
//             }
            
//             // Return default locale if not supported
//             return const Locale('en');
//           },
          
//           // FIX 2: Wrap localization delegates in try-catch
//           localizationsDelegates: _buildLocalizationDelegates(),
          
//           // FIX 3: Ensure supported locales is not empty
//           supportedLocales: const [
//             Locale('en', 'US'),
//             Locale('en'),
//           ],
          
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeMode,
//           routeInformationParser: router.routeInformationParser,
//           routerDelegate: router.routerDelegate,
//           routeInformationProvider: router.routeInformationProvider,
//         );
//       },
//     );
//   }

//   // Helper method to safely build localization delegates
//   List<LocalizationsDelegate<dynamic>> _buildLocalizationDelegates() {
//     try {
//       return [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         // Only add quill delegate if it's properly imported
//         if (quill.FlutterQuillLocalizations.delegate != null)
//           quill.FlutterQuillLocalizations.delegate,
//       ];
//     } catch (e) {
//       log('Error building localization delegates: $e');
//       // Return minimal delegates if there's an error
//       return [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ];
//     }
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeAsync();
//   }

//   Future<void> _initializeAsync() async {
//     try {
//       // Any late initialization can go here
//     } catch (e, stack) {
//       debugPrint('Async initialization error: $e\n$stack');
//       Sentry.captureException(e, stackTrace: stack);
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('App state changed to: $state');
//     // Handle any state-specific logic
//   }

//   List<LocalizationsDelegate<dynamic>> _getLocalizationDelegates() {
//     final delegates = <LocalizationsDelegate<dynamic>>[
//       GlobalMaterialLocalizations.delegate,
//       GlobalWidgetsLocalizations.delegate,
//       GlobalCupertinoLocalizations.delegate,
//     ];

//     try {
//       // Conditionally add Quill localizations if available
//       const hasQuill = bool.fromEnvironment('HAS_QUILL', defaultValue: false);
//       if (hasQuill) {
//         delegates.add(quill.FlutterQuillLocalizations.delegate!);
//       }
//     } catch (e) {
//       debugPrint('Failed to add Quill localizations: $e');
//       Sentry.captureException(e);
//     }

//     return delegates;
//   }

//   Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
//     try {
//       if (locale == null || supportedLocales.isEmpty) {
//         return const Locale('en', 'US');
//       }

//       // Try exact match first
//       for (final supportedLocale in supportedLocales) {
//         if (supportedLocale.languageCode == locale.languageCode &&
//             supportedLocale.countryCode == locale.countryCode) {
//           return supportedLocale;
//         }
//       }

//       // Fall back to language code match
//       for (final supportedLocale in supportedLocales) {
//         if (supportedLocale.languageCode == locale.languageCode) {
//           return supportedLocale;
//         }
//       }

//       // Default fallback
//       return const Locale('en', 'US');
//     } catch (e, stack) {
//       debugPrint('Locale resolution failed: $e\n$stack');
//       Sentry.captureException(e, stackTrace: stack);
//       return const Locale('en', 'US');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       builder: (_, child) {
//         return MaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeMode,
//           localeResolutionCallback: _resolveLocale,
//           localizationsDelegates: _getLocalizationDelegates(),
//           supportedLocales: const [
//             Locale('en', 'US'),
//             Locale('en'),
//           ],
//           routeInformationParser: router.routeInformationParser,
//           routerDelegate: router.routerDelegate,
//           routeInformationProvider: router.routeInformationProvider,
//         );
//       },
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      // Any late initialization can go here
      log("Async initialization completed");
    } catch (e, stack) {
      debugPrint('Async initialization error: $e\n$stack');
      Sentry.captureException(e, stackTrace: stack);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App state changed to: $state');
    
    // Handle app lifecycle states
    switch (state) {
      case AppLifecycleState.resumed:
        log("App resumed");
        break;
      case AppLifecycleState.inactive:
        log("App inactive");
        break;
      case AppLifecycleState.paused:
        log("App paused");
        break;
      case AppLifecycleState.detached:
        log("App detached");
        break;
      case AppLifecycleState.hidden:
        log("App hidden");
        break;
    }
  }

// List<LocalizationsDelegate<dynamic>> _getLocalizationDelegates() {
//   return  [
//     GlobalMaterialLocalizations.delegate,
//     GlobalCupertinoLocalizations.delegate,
//     GlobalWidgetsLocalizations.delegate,
//     if(Platform.isAndroid)FlutterQuillLocalizations.delegate,
//     // Remove the dynamic Quill delegate addition for now
//     // This could be causing the initialization crash
//   ];
// }
// List<LocalizationsDelegate<dynamic>> _getLocalizationDelegates() {
//   final delegates = <LocalizationsDelegate<dynamic>>[
//     GlobalMaterialLocalizations.delegate,
//     GlobalCupertinoLocalizations.delegate,
//     GlobalWidgetsLocalizations.delegate,
//   ];

//   try {
//     if (Platform.isAndroid) {
//       delegates.add(FlutterQuillLocalizations.delegate);
//       debugPrint('Added FlutterQuillLocalizations for Android');
//     }
//   } catch (e) {
//     debugPrint('Platform detection error: $e');
//   }

//   return delegates;
// }
// Also simplify your _resolveLocale method:
// Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
//   // Simplified version to avoid potential crashes during initialization
//   if (locale == null) {
//     return const Locale('en', 'US');
//   }
  
//   // Just return the first supported locale that matches language code
//   for (final supportedLocale in supportedLocales) {
//     if (supportedLocale.languageCode == locale.languageCode) {
//       return supportedLocale;
//     }
//   }
  
//   return const Locale('en', 'US');
// }

  @override
  Widget build(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeMode,
            // localeResolutionCallback: _resolveLocale,
            // localizationsDelegates: _getLocalizationDelegates(),
            // supportedLocales: const [
            //   Locale('en', 'US'),
            //   // Locale('en'),
            // ],
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            // Add error handling for router
            builder: (context, child) {
              return child ?? const Scaffold(
                body: Center(
                  child: Text('App loading...'),
                ),
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Build error: $e\n$stackTrace');
      Sentry.captureException(e, stackTrace: stackTrace);
      
      // Return a fallback UI
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Please restart the app'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // You could add a restart mechanism here
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}