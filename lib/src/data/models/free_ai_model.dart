import 'dart:developer';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeAiModel {
  final String name;
  final String? title;
  final String fileType;
  final String? image;
  final String url;
  final String? summary; // String to match getSession's summary.content
  final String? sessionId;
  final String? status;
  final String? username;
  final List<Map<String, dynamic>>? chats; // Changed from chat to chats
  final String? extractedText;
  final List<Map<String, dynamic>>? transcript;
  final List<Map<String, dynamic>>? chapters;
  final List<Map<String, dynamic>>? questions;
  final Map<String, dynamic>? quiz;
  final String? note; // New field for addNoteToSession

  FreeAiModel({
    required this.name,
    required this.fileType,
    required this.url,
    this.title,
    this.image,
    this.summary,
    this.sessionId,
    this.status,
    this.username,
    this.chats,
    this.extractedText,
    this.transcript,
    this.chapters,
    this.questions,
    this.quiz,
    this.note,
  });

  factory FreeAiModel.fromJson(Map<String, dynamic> json) {
    log("FreeAiModel.fromJson: json=${json.toString().substring(0, 200)}...");
    final fileType = json['fileType'] as String? ?? 'unknown';
    final url = json['url'] as String? ?? '';
    String? previewImage;
    switch (fileType) {
      case 'pdf':
        previewImage =
            'assets/app/pngtree-pdf-file-icon-png-png-image_7965915-removebg-preview.png';
        break;
      case 'ppt':
      case 'pptx':
        previewImage = 'assets/app/pptx_image.png';
        break;
      case 'doc':
      case 'docx':
        previewImage = 'assets/app/dos_image-removebg-preview.png';
        break;
      case 'txt':
        previewImage = 'assets/app/txt_image-removebg-preview.png';
        break;
      case 'text':
        previewImage = 'assets/app/text_topic-removebg-preview.png';
        break;
      case 'mp3':
      case 'wav':
      case 'm4a':
        previewImage = 'assets/app/recorde_voice_image-removebg-preview.png';
        break;
      case 'mp4':
        if (url.contains('youtube.com') || url.contains('youtu.be')) {
          final videoId = YoutubePlayer.convertUrlToId(url);
          previewImage = videoId != null
              ? 'https://img.youtube.com/vi/$videoId/0.jpg'
              : 'assets/app/new_topic_image-removebg-preview.png';
        } else if (url.contains('tiktok.com')) {
          previewImage = 'assets/app/tiktok_image.jpg';
        } else {
          previewImage = 'assets/app/tiktok_image.jpg';
        }
        break;
      default:
        previewImage = 'assets/app/new_topic_image-removebg-preview.png';
    }
    final extractedText = json['processedData']?['extractedText'] as String?;
    log("Parsed extractedText: $extractedText");
    return FreeAiModel(
      name:
          json['name'] as String? ?? json['url']?.split('/').last ?? "Unnamed",
      title: json['title'] as String?,
      fileType: fileType,
      image: json['image'] as String? ?? previewImage,
      url: url,
      summary: json['summary']?['content'] as String?,
      sessionId: json['id'] as String?,
      status: json['status'] as String?,
      username: json['username'] as String?,
      extractedText: extractedText,
      chats: (json['chats'] as List<dynamic>?)?.map((chat) {
        return {
          'id': chat['id'] as String?,
          'question': chat['question'] as String?,
          'content': chat['content'] as String?,
          'createdAt': chat['createdAt'] as String?,
        };
      }).toList(),
      transcript: (json['transcript'] as List<dynamic>?)?.map((t) {
        return {
          'startTime': (t['startTime'] is int)
              ? (t['startTime'] as int).toDouble()
              : t['startTime'] as double?,
          'pageNumber': t['pageNumber'] as int?,
          'content': t['content'] as String?,
        };
      }).toList(),
      chapters: (json['chapters'] as List<dynamic>?)?.map((c) {
        return {
          'title': c['title'] as String?,
          'summary': c['summary'] as String?,
          'startTime': (c['startTime'] is int)
              ? (c['startTime'] as int).toDouble()
              : c['startTime'] as double?,
          'pageNumber': c['pageNumber'] as int?,
        };
      }).toList(),
      questions: (json['questions'] as List<dynamic>?)?.map((q) {
        return {
          'content': q['content'] as String?,
          'hint': q['hint'] as String?,
        };
      }).toList(),
      quiz: json['quiz'] != null
          ? {
              'id': json['quiz']['id'] as String?,
              'sessionId': json['quiz']['sessionId'] as String?,
              'questions':
                  (json['quiz']['questions'] as List<dynamic>?)?.map((q) {
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
              }).toList(),
              'createdAt': json['quiz']['createdAt'] as String?,
            }
          : null,
      note: json['note']?['content'] as String?,
    );
  }

  FreeAiModel copyWith({
    String? name,
    String? title,
    String? fileType,
    String? image,
    String? url,
    String? summary,
    String? sessionId,
    String? status,
    String? username,
    List<Map<String, dynamic>>? chats,
    String? extractedText,
    List<Map<String, dynamic>>? transcript,
    List<Map<String, dynamic>>? chapters,
    List<Map<String, dynamic>>? questions,
    Map<String, dynamic>? quiz,
    String? note,
  }) {
    return FreeAiModel(
      name: name ?? this.name,
      title: title ?? this.title,
      fileType: fileType ?? this.fileType,
      image: image ?? this.image,
      url: url ?? this.url,
      summary: summary ?? this.summary,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      username: username ?? this.username,
      chats: chats ?? this.chats,
      extractedText: extractedText ?? this.extractedText,
      transcript: transcript ?? this.transcript,
      chapters: chapters ?? this.chapters,
      questions: questions ?? this.questions,
      quiz: quiz ?? this.quiz,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'fileType': fileType,
      'image': image,
      'url': url,
      'summary': summary,
      'sessionId': sessionId,
      'status': status,
      'username': username,
      'chats': chats,
      'extractedText': extractedText,
      'transcript': transcript,
      'chapters': chapters,
      'questions': questions,
      'quiz': quiz,
      'note': note,
    };
  }

  // Default empty model for fallback cases
  factory FreeAiModel.empty() {
    return FreeAiModel(
      name: "Unnamed",
      fileType: "unknown",
      url: "",
    );
  }
}
