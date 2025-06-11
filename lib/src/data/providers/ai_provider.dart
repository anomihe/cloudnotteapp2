import 'dart:async';
import 'dart:developer';

import 'package:cloudnottapp2/src/config/ai_api_prompt.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

//  existing Message, ApiRequest, ApiResponse, etc. models remain unchanged

class AiContentProvider extends ChangeNotifier {
  bool _isGenerating = false;
  String _aiResult = "";
  String _aiError = "";
  double _progress = 0.0;
  bool get isGenerating => _isGenerating;
  String get aiResult => _aiResult;
  String get aiError => _aiError;
  double get progress => _progress;
  Future<void> generateContent({
    required String mode,
    String tone = "BALANCED",
    required String topic,
    required String subject,
    required String classGroup,
    List<String> curriculums = const ["Nigerian", "British"],
    bool includeImages = false,
  }) async {
    _isGenerating = true;
    _aiResult = "";
    _aiError = "";
    _progress = 0.0;
    notifyListeners();

    Timer? progressTimer;
    progressTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_progress < 0.9) {
        _progress += 0.05;
        notifyListeners();
      }
    });

    String contentLabel = mode == "plan" ? "lesson plan" : "class note";
    String lessonNotePrompt = """
      You are an expert Educator, that can write perfect ${contentLabel}s. Write a $tone ${contentLabel} for the topic "$topic" 
      under the subject "$subject" for $classGroup class, for a school using ${curriculums.join(", ")} curriculum${includeImages ? ", NOTE: It is compulsory that you include image resource links (ending with an image extension) from image sites in your output." : ""}, and output it in rich text string format.
    """;

    try {
      final messages = [
        Message(
          role: MessageRole.system,
          content:
              "You are an expert Educator that creates high-quality educational content.",
        ),
        Message(
          role: MessageRole.user,
          content: lessonNotePrompt,
        ),
      ];

      final temperature = tone == "CREATIVE"
          ? 0.9
          : tone == "BALANCED"
              ? 0.7
              : 0.5;
      final response = await generateAIResponse(
        messages: messages,
        temperature: temperature,
      );

      if (response != null && response.choices.isNotEmpty) {
        log('ai ${response.choices}');
        // _aiResult = response.choices[0].message.content;
        String rawContent = response.choices[0].message.content;

        _aiResult = rawContent.split('</think>').last.trim();
        _isGenerating = false;
        notifyListeners();
      } else {
        _aiError = "No response from AI.";
      }
    } catch (e) {
      _aiError = "Error: $e";
    } finally {
      progressTimer?.cancel();
      _isGenerating = false;
      _progress = _aiResult.isNotEmpty ? 1.0 : _progress;
      notifyListeners();
    }
  }

  Future<ApiResponse?> fetchAIResponse(ApiRequest request) async {
    try {
      final response = await dio.post(
        "/api/v1/chat/completions",
        data: request.toJson(),
      );
      print("data ${response.data}");

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        print("Error: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("AI API request failed: $e");
      return null;
    }
  }

  Future<ApiResponse?> generateAIResponse({
    required List<Message> messages,
    required double temperature,
  }) async {
    final request = ApiRequest(
      messages: messages,
      temperature: temperature,
    );
    return await fetchAIResponse(request);
  }
}
