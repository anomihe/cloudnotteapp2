import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:cloudnottapp2/src/api_strings/api_quries/graphql_queries.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/data/repositories/free_ai_repo.dart';
import 'package:cloudnottapp2/src/data/repositories/file_uploader_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeAiProvider extends ChangeNotifier {
  final FreeAiRepo _freeAiRepo = FreeAiRepoImpl();
  List<FreeAiModel> _userAddedTopics = [];
  List<FreeAiModel> _exploreTopics = [];
  bool _isSubmitting = false;
  bool _isLoadingExploreTopics = false;
  bool _isLoadingSessions = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _chatMessages = [];
  bool _isLoadingChat = false;

  // Media states
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  audio.AudioPlayer _audioPlayer = audio.AudioPlayer();
  bool _isVideoInitialized = false;
  String? _videoError;
  bool _isYoutubeInitialized = false;
  String? _youtubeError;
  String? _textContent;
  bool _isPlayingAudio = false;
  bool _isAudioLoading = false;
  String? _audioError;
  Duration? _audioDuration;
  Duration? _currentPosition;
  bool _isPlayingVideo = false;
  bool _isVideoLoading = false;
  String? _pdfFilePath;
  String? _pdfError;

  // Getters
  YoutubePlayerController? get youtubeController => _youtubeController;
  VideoPlayerController? get videoController => _videoController;
  bool get isVideoInitialized => _isVideoInitialized;
  String? get videoError => _videoError;
  bool get isYoutubeInitialized => _isYoutubeInitialized;
  String? get youtubeError => _youtubeError;
  String? get textContent => _textContent;
  bool get isPlayingAudio => _isPlayingAudio;
  bool get isAudioLoading => _isAudioLoading;
  String? get audioError => _audioError;
  Duration? get audioDuration => _audioDuration;
  Duration? get currentPosition => _currentPosition;
  bool get isPlayingVideo => _isPlayingVideo;
  bool get isVideoLoading => _isVideoLoading;
  String? get pdfFilePath => _pdfFilePath;
  String? get pdfError => _pdfError;

  List<FreeAiModel> get userAddedTopics => _userAddedTopics;
  List<FreeAiModel> get exploreTopics => _exploreTopics;
  bool get isSubmitting => _isSubmitting;
  bool get isLoadingExploreTopics => _isLoadingExploreTopics;
  bool get isLoadingSessions => _isLoadingSessions;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get chatMessages => _chatMessages;
  bool get isLoadingChat => _isLoadingChat;

  FreeAiProvider() {
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      _audioDuration = duration;
      notifyListeners();
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlayingAudio = state == audio.PlayerState.playing;
      _isAudioLoading = false;
      if (state == audio.PlayerState.completed) {
        _currentPosition = Duration.zero;
      }
      notifyListeners();
    });
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  void resetMedia() {
    _youtubeController?.pause();
    _youtubeController?.dispose();
    _youtubeController = null;
    _isYoutubeInitialized = false;
    _youtubeError = null;

    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
    _isVideoInitialized = false;
    _isVideoLoading = false;
    _videoError = null;
    _isPlayingVideo = false;

    _audioPlayer.pause();
    _audioPlayer.release();
    _isPlayingAudio = false;
    _isAudioLoading = false;
    _audioError = null;
    _audioDuration = null;
    _currentPosition = null;

    if (_pdfFilePath != null) {
      File(_pdfFilePath!).delete();
      _pdfFilePath = null;
    }
    _pdfError = null;

    _textContent = null;
    notifyListeners();
  }

  Future<void> seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      _audioError = "Error seeking audio: $e";
      notifyListeners();
    }
  }

  Future<void> initializeMedia(FreeAiModel model) async {
    resetMedia();
    log("Initializing media for ${model.name}, fileType: ${model.fileType}, extractedText: ${model.extractedText}");
    switch (model.fileType) {
      case "youtube":
        await _initializeYoutube(model.url);
        break;
      case "mp4":
        if (_isYouTubeUrl(model.url)) {
          await _initializeYoutube(model.url);
        } else if (model.url.contains('tiktok.com')) {
          await _initializeVideo(model.url);
        } else {
          await _initializeVideo(model.url);
        }
        break;
      case "txt":
        await _loadTextFile(model.url);
        break;
      case "text":
        _textContent = model.extractedText ?? "No text content available";
        log("Set textContent for ${model.name}: $_textContent");
        notifyListeners();
        break;
      case "pdf":
        await _loadPdf(model.url);
        break;
      case "mp3":
      case "m4a":
      case "wav":
        _isAudioLoading = true;
        _audioError = null;
        notifyListeners();
        try {
          await _audioPlayer.setSource(audio.UrlSource(model.url));
          _isAudioLoading = false;
          notifyListeners();
        } catch (e) {
          _isAudioLoading = false;
          _audioError = "Error initializing audio: $e";
          notifyListeners();
        }
        break;
      case "docx":
      case "pptx":
        _textContent =
            "Unsupported file type: ${model.fileType}. This format is not displayable.";
        notifyListeners();
        break;
      default:
        _textContent = "Unknown file type: ${model.fileType}";
        notifyListeners();
        break;
    }
  }

  Future<void> _initializeYoutube(String url) async {
    _isYoutubeInitialized = false;
    _youtubeError = null;
    notifyListeners();

    try {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId == null) {
        _youtubeError = "Invalid YouTube URL";
        notifyListeners();
        return;
      }
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      )..addListener(() {
          if (_youtubeController!.value.hasError) {
            _youtubeError = "Error playing YouTube video";
            notifyListeners();
          }
        });
      _isYoutubeInitialized = true;
    } catch (e) {
      _youtubeError = "Error initializing YouTube: $e";
    }
    notifyListeners();
  }

  Future<void> _initializeVideo(String url) async {
    _isVideoInitialized = false;
    _videoError = null;
    _isVideoLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute || !uri.hasScheme) {
        throw Exception("Invalid video URL: $url");
      }
      _videoController = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          _isVideoInitialized = true;
          _isVideoLoading = false;
          notifyListeners();
        }).catchError((error) {
          _videoError = "Error initializing video: $error";
          _isVideoLoading = false;
          notifyListeners();
        });
    } catch (e) {
      _videoError = "Invalid video URL: $e";
      _isVideoLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadTextFile(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute || !uri.hasScheme) {
        throw Exception("Invalid text file URL: $url");
      }
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        _textContent = utf8.decode(response.bodyBytes);
      } else {
        _textContent = "Failed to load text file: ${response.statusCode}";
      }
    } catch (e) {
      _textContent = "Error loading text file: $e";
    }
    notifyListeners();
  }

  Future<void> _loadPdf(String url) async {
    _pdfFilePath = null;
    _pdfError = null;
    notifyListeners();

    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute || !uri.hasScheme) {
        throw Exception("Invalid PDF URL: $url");
      }
      log("Downloading PDF from $url");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final tempDir = Directory.systemTemp;
        final file = File(
            '${tempDir.path}/temp_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(response.bodyBytes);
        _pdfFilePath = file.path;
        log("PDF saved to $_pdfFilePath");
      } else {
        _pdfError = "Failed to download PDF: ${response.statusCode}";
        log("PDF download error: $_pdfError");
      }
    } catch (e) {
      _pdfError = "Error loading PDF: $e";
      log("PDF loading exception: $e");
    }
    notifyListeners();
  }

  Future<void> playAudio(String url) async {
    try {
      _isAudioLoading = true;
      notifyListeners();
      await _audioPlayer.play(audio.UrlSource(url));
    } catch (e) {
      _isAudioLoading = false;
      _audioError = "Error playing audio: $e";
      notifyListeners();
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _audioError = "Error pausing audio: $e";
      notifyListeners();
    }
  }

  Future<void> playVideo() async {
    if (_videoController != null && _isVideoInitialized) {
      await _videoController!.play();
      _isPlayingVideo = true;
      _isVideoLoading = false;
      notifyListeners();
    }
  }

  Future<void> pauseVideo() async {
    if (_videoController != null && _isVideoInitialized) {
      await _videoController!.pause();
      _isPlayingVideo = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoController?.dispose();
    _audioPlayer.dispose();
    if (_pdfFilePath != null) {
      File(_pdfFilePath!).delete();
    }
    super.dispose();
  }

  Future<void> loadSessions(BuildContext context) async {
    _isLoadingSessions = true;
    _errorMessage = null;
    notifyListeners();
    final result = await _freeAiRepo.getSessions(context: context);
    if (result.response is ResponseSuccess) {
      _userAddedTopics =
          (result.response as ResponseSuccess<List<FreeAiModel>>).data!;
      for (var session in _userAddedTopics) {
        if (session.status == "PENDING" && session.sessionId != null) {
          await _pollSessionStatus(context, session.sessionId!);
        }
      }
      log("Loaded ${_userAddedTopics.length} sessions");
    } else {
      _errorMessage = (result.response as ResponseError).message;
      log("Load sessions error: $_errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load sessions: $_errorMessage")),
      );
    }
    _isLoadingSessions = false;
    notifyListeners();
  }

  Future<void> loadExploreTopics(BuildContext context) async {
    _isLoadingExploreTopics = true;
    _errorMessage = null;
    notifyListeners();
    final result = await _freeAiRepo.getExploreTopics(context: context);
    if (result.response is ResponseSuccess) {
      _exploreTopics =
          (result.response as ResponseSuccess<List<FreeAiModel>>).data!;
      log("Loaded ${_exploreTopics.length} explore topics");
    } else {
      _errorMessage = (result.response as ResponseError).message;
      log("Load explore topics error: $_errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to load explore topics: $_errorMessage")),
      );
    }
    _isLoadingExploreTopics = false;
    notifyListeners();
  }

  Future<void> submitFile(BuildContext context, File file, String fileExtension,
      String name) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final uploader = FileUploadNotifier();
    await uploader.uploadFile(file);
    final uploadedUrl = uploader.fileUrl;
    if (uploadedUrl == null) {
      _errorMessage = "Failed to upload file";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      _isSubmitting = false;
      notifyListeners();
      return;
    }

    final result = await _freeAiRepo.submitUrl(
      context: context,
      url: uploadedUrl,
      fileType: fileExtension,
      name: name,
    );

    if (result.response is ResponseSuccess) {
      final model = (result.response as ResponseSuccess<FreeAiModel>).data!;
      _userAddedTopics.add(model);
      if (model.status == "PENDING" && model.sessionId != null) {
        await _pollSessionStatus(context, model.sessionId!);
      }
      _errorMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File submitted successfully")),
      );
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit file: $_errorMessage")),
      );
    }
    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> submitUrl(BuildContext context, String url, String name) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    String fileType = "website";
    String resolvedName = name;

    final youtubeVideoId = YoutubePlayer.convertUrlToId(url);
    if (youtubeVideoId != null) {
      fileType = "youtube";
      resolvedName = name.isEmpty ? "YouTube Video" : name;
    } else if (url.contains('tiktok.com')) {
      final tiktokVideoId = await _extractTikTokVideoId(url);
      if (tiktokVideoId != null) {
        fileType = "mp4";
        resolvedName = name.isEmpty ? "TikTok Video" : name;
      }
    } else if (Uri.parse(url).host.contains('arxiv.org')) {
      fileType = "arxiv";
      resolvedName = name.isEmpty ? "ArXiv Paper" : name;
    }

    final result = await _freeAiRepo.submitUrl(
      context: context,
      url: url,
      fileType: fileType,
      name: resolvedName,
    );

    if (result.response is ResponseSuccess) {
      final model = (result.response as ResponseSuccess<FreeAiModel>).data!;
      _userAddedTopics.add(model);
      if (model.status == "PENDING" && model.sessionId != null) {
        await _pollSessionStatus(context, model.sessionId!);
      }
      _errorMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("URL submitted successfully")),
      );
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit URL: $_errorMessage")),
      );
    }
    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> submitText(
      BuildContext context, String text, String name) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _freeAiRepo.submitText(
      context: context,
      text: text,
      name: name.isEmpty ? "Text Submission" : name,
    );

    if (result.response is ResponseSuccess) {
      final model = (result.response as ResponseSuccess<FreeAiModel>).data!;
      _userAddedTopics.add(model);
      if (model.status == "PENDING" && model.sessionId != null) {
        await _pollSessionStatus(context, model.sessionId!);
      }
      _errorMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Text submitted successfully")),
      );
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit text: $_errorMessage")),
      );
    }
    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> deleteTopic(BuildContext context, String sessionId) async {
    _errorMessage = null;
    notifyListeners();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final username = userProvider.user?.username;
    if (username == null) {
      _errorMessage = "User not logged in";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      notifyListeners();
      return;
    }

    final result = await _freeAiRepo.deleteSession(
      context: context,
      sessionId: sessionId,
      username: username,
    );

    if (result.response is ResponseSuccess) {
      _userAddedTopics.removeWhere((topic) => topic.sessionId == sessionId);
      _errorMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topic deleted successfully')),
      );
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete topic: $_errorMessage')),
      );
    }
    notifyListeners();
  }

  Future<void> submitRecording(BuildContext context, String filePath) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final file = File(filePath);
    final uploader = FileUploadNotifier();
    await uploader.uploadRecordingFile(filePath);
    final uploadedUrl = uploader.fileUrl;

    if (uploadedUrl == null) {
      _errorMessage = "Failed to upload recording";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      _isSubmitting = false;
      notifyListeners();
      return;
    }

    final result = await _freeAiRepo.submitUrl(
      context: context,
      url: uploadedUrl,
      fileType: "m4a",
      name: "Audio Recording ${DateTime.now().toString().split('.').first}",
    );

    if (result.response is ResponseSuccess) {
      final model = (result.response as ResponseSuccess<FreeAiModel>).data!;
      _userAddedTopics.add(model);
      if (model.status == "PENDING" && model.sessionId != null) {
        await _pollSessionStatus(context, model.sessionId!);
      }
      _errorMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recording submitted successfully")),
      );
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit recording: $_errorMessage")),
      );
    }
    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> _pollSessionStatus(
      BuildContext context, String sessionId) async {
    bool isProcessed = false;
    int retryCount = 0;
    const maxRetries = 30;
    while (!isProcessed && retryCount < maxRetries) {
      final result =
          await _freeAiRepo.getSession(context: context, sessionId: sessionId);
      if (result.response is ResponseSuccess) {
        final updatedModel =
            (result.response as ResponseSuccess<FreeAiModel>).data!;
        final index =
            _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
        if (index != -1) {
          _userAddedTopics[index] = updatedModel;
          notifyListeners();
        }
        if (updatedModel.status == "COMPLETED" ||
            updatedModel.status == "FAILED") {
          isProcessed = true;
        }
      } else {
        log("Poll session $sessionId error: ${(result.response as ResponseError).message}");
      }
      if (!isProcessed) {
        await Future.delayed(const Duration(seconds: 2));
        retryCount++;
      }
    }
    if (retryCount >= maxRetries) {
      log("Polling timed out for session $sessionId");
      _errorMessage = "Processing timed out for session $sessionId";
      notifyListeners();
    }
  }

  void clearSessionData() {
    _chatMessages = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearCache() {
    _userAddedTopics.clear();
    _exploreTopics.clear();
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> regenerateSummary(BuildContext context, String sessionId) async {
    final result = await _freeAiRepo.regenerateSummary(
        context: context, sessionId: sessionId);
    if (result.response is ResponseSuccess) {
      final summary = (result.response as ResponseSuccess<String>).data!;
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(summary: summary);
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Summary regenerated successfully")),
        );
      }
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to regenerate summary: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  Future<void> regenerateChapters(
      BuildContext context, String sessionId) async {
    final result = await _freeAiRepo.regenerateChapters(
        context: context, sessionId: sessionId);
    if (result.response is ResponseSuccess) {
      final chapters =
          (result.response as ResponseSuccess<List<Map<String, dynamic>>>)
              .data!;
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(chapters: chapters);
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chapters regenerated successfully")),
        );
      }
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to regenerate chapters: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  Future<void> regenerateQuestions(
      BuildContext context, String sessionId) async {
    final result = await _freeAiRepo.regenerateQuestions(
        context: context, sessionId: sessionId);
    if (result.response is ResponseSuccess) {
      final questions =
          (result.response as ResponseSuccess<List<Map<String, dynamic>>>)
              .data!;
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(questions: questions);
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Questions regenerated successfully")),
        );
      }
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to regenerate questions: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  Future<void> regenerateQuiz(BuildContext context, String sessionId) async {
    final result = await _freeAiRepo.regenerateQuiz(
        context: context, sessionId: sessionId);
    if (result.response is ResponseSuccess) {
      final quiz =
          (result.response as ResponseSuccess<Map<String, dynamic>>).data!;
      // Ensure questions is List<Map<String, dynamic>>
      final questions = (quiz['questions'] as List<dynamic>?)?.map((q) {
            return {
              'id': q['id'] as String?,
              'content': q['content'] as String?,
              'options': (q['options'] as List<dynamic>?)?.map((o) {
                return {
                  'id': o['id'] as String?,
                  'content': o['content'] as String?,
                  'isCorrect': o['isCorrect'] as bool?,
                };
              }).toList(),
              'hint': q['hint'] as String?,
              'explanation': q['explanation'] as String?,
            };
          }).toList() ??
          [];
      final updatedQuiz = {
        'id': quiz['id'],
        'questions': questions,
        'createdAt': quiz['createdAt'],
      };
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(quiz: updatedQuiz);
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quiz regenerated successfully")),
        );
      }
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to regenerate quiz: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  Future<void> addNoteToSession(
      BuildContext context, String sessionId, String note) async {
    final result = await _freeAiRepo.addNoteToSession(
      context: context,
      sessionId: sessionId,
      note: note,
    );
    if (result.response is ResponseSuccess) {
      final noteContent = (result.response as ResponseSuccess<String>).data!;
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(note: noteContent);
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note added successfully")),
        );
      }
    } else {
      _errorMessage = (result.response as ResponseError).message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add note: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  Future<void> sendChatMessage(
      BuildContext context, String sessionId, String question) async {
    if (question.trim().isEmpty) return;
    _chatMessages.add({
      "sender": "User",
      "text": question,
      "createdAt": DateTime.now().toIso8601String(),
    });
    _isLoadingChat = true;
    notifyListeners();

    final result = await _freeAiRepo.chat(
      context: context,
      sessionId: sessionId,
      question: question,
    );
    _isLoadingChat = false;

    if (result.response is ResponseSuccess) {
      final chatData =
          (result.response as ResponseSuccess<Map<String, dynamic>>).data!;
      _chatMessages.add({
        "sender": "AI",
        "text": _cleanText(chatData['content'] as String?),
        "createdAt": chatData['createdAt'] ?? DateTime.now().toIso8601String(),
      });
      log("Added AI chat response: ${_cleanText(chatData['content'] as String?)}");
      final index =
          _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
      if (index != -1) {
        final updatedChats =
            List<Map<String, dynamic>>.from(_userAddedTopics[index].chats ?? [])
              ..add({
                'id': chatData['id'],
                'question': question,
                'content': chatData['content'],
                'createdAt':
                    chatData['createdAt'] ?? DateTime.now().toIso8601String(),
              });
        _userAddedTopics[index] =
            _userAddedTopics[index].copyWith(chats: updatedChats);
      }
    } else {
      _chatMessages.add({
        "sender": "AI",
        "text": "Error: Chat not available yet.",
        "createdAt": DateTime.now().toIso8601String(),
      });
      _errorMessage = (result.response as ResponseError).message;
      log("Chat error: $_errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send chat: $_errorMessage")),
      );
    }
    notifyListeners();
  }

  void clearTopics() {
    _userAddedTopics.clear();
    clearSessionData();
    notifyListeners();
  }

  String _cleanText(String? text) {
    if (text == null || text.isEmpty) return "No content available.";
    return text
        .replaceAll(RegExp(r'[^\x20-\x7E\n]'), '')
        .replaceAll(RegExp(r'\n{2,}'), '\n\n')
        .trim();
  }

  Future<String?> _extractTikTokVideoId(String url) async {
    try {
      if (url.contains('vm.tiktok.com') || url.contains('vt.tiktok.com')) {
        final client = http.Client();
        final request = http.Request('GET', Uri.parse(url))
          ..followRedirects = false;
        final response = await client.send(request);
        if (response.statusCode == 301 || response.statusCode == 302) {
          final redirectedUrl = response.headers['location'];
          if (redirectedUrl == null) return null;
          final regex = RegExp(r'tiktok\.com/[^/]+/video/(\d+)');
          final match = regex.firstMatch(redirectedUrl);
          return match?.group(1);
        }
      } else {
        final regex = RegExp(r'tiktok\.com/[^/]+/video/(\d+)');
        final match = regex.firstMatch(url);
        return match?.group(1);
      }
    } catch (e) {
      log("Error resolving TikTok URL: $e");
      return null;
    }
    return null;
  }

  Future<void> updateTikTokThumbnail(
      BuildContext context, String sessionId) async {
    final topic = _userAddedTopics.firstWhere((t) => t.sessionId == sessionId,
        orElse: FreeAiModel.empty);
    if (topic.fileType == 'mp4' && topic.url.contains('tiktok.com')) {
      final thumbnail = await _fetchTikTokThumbnail(topic.url);
      if (thumbnail != null) {
        final index =
            _userAddedTopics.indexWhere((t) => t.sessionId == sessionId);
        if (index != -1) {
          _userAddedTopics[index] =
              _userAddedTopics[index].copyWith(image: thumbnail);
          notifyListeners();
        }
      }
    }
  }

  Future<String?> _fetchTikTokThumbnail(String videoUrl) async {
    try {
      final uri = Uri.parse('https://www.tiktok.com/oembed?url=$videoUrl');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['thumbnail_url'] as String?;
      }
    } catch (e) {
      log('Error fetching TikTok thumbnail: $e');
    }
    return null;
  }
}
