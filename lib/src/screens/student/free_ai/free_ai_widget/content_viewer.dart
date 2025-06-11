import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:cloudnottapp2/src/components/global_widgets/custom_pdf_viewer.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentViewer extends StatelessWidget {
  const ContentViewer({
    super.key,
    required this.freeAiModel,
    required this.isCollapsed,
    required this.onPdfToggle,
    required this.isPdfExpanded,
    this.pdfError,
    this.pdfFilePath,
  });

  final FreeAiModel freeAiModel;
  final bool isCollapsed;
  final VoidCallback onPdfToggle;
  final bool isPdfExpanded;
  final String? pdfError;
  final String? pdfFilePath;

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) return const SizedBox.shrink();
    return Consumer<FreeAiProvider>(
      builder: (context, provider, child) {
        log("ContentViewer: fileType=${freeAiModel.fileType}, sessionId=${freeAiModel.sessionId}, extractedText=${freeAiModel.extractedText?.substring(0, 50)}...");
        return _buildContent(context, freeAiModel, provider);
      },
    );
  }

  Widget _buildContent(
      BuildContext context, FreeAiModel model, FreeAiProvider provider) {
    // Re-initialize media if extractedText is null for text
    if (model.fileType == "text" && model.extractedText == null) {
      log("extractedText is null for ${model.name}, re-initializing media");
      provider.initializeMedia(model);
    }

    // Helper method to display extractedText
    Widget _buildExtractedText(String text) {
      log("Displaying extractedText: ${text.substring(0, 50)}...");
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        padding: EdgeInsets.all(10.r),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp),
          ),
        ),
      );
    }

    // Helper method to handle failure cases with extractedText fallback
    Widget _buildFallbackContent(String fileType, String fileName,
        {String? errorMessage, VoidCallback? onRetry}) {
      log("Checking fallback for $fileType: extractedText=${model.extractedText?.substring(0, 50)}..., errorMessage=$errorMessage");
      if (model.extractedText != null && model.extractedText!.isNotEmpty) {
        log("Falling back to extractedText for $fileType");
        return _buildExtractedText(model.extractedText!);
      }
      log("Showing UnsupportedContentWidget for $fileType: no extractedText available");
      return UnsupportedContentWidget(
        fileType: fileType,
        fileName: fileName,
        errorMessage: errorMessage,
        onRetry: onRetry,
      );
    }

    switch (model.fileType) {
      case "youtube":
      case "mp4" when _isYouTubeUrl(model.url):
        if (provider.youtubeController == null ||
            !provider.isYoutubeInitialized ||
            provider.youtubeError != null) {
          return _buildFallbackContent(
            "YouTube",
            model.name,
            errorMessage:
                provider.youtubeError ?? "Failed to initialize YouTube player",
            onRetry: () => provider.initializeMedia(model),
          );
        }
        return YoutubePlayer(
          controller: provider.youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: goldenShades[0],
          progressColors: ProgressBarColors(
            playedColor: goldenShades[0],
            handleColor: goldenShades[1],
          ),
        );
      case "mp4":
        if (provider.videoController == null ||
            !provider.isVideoInitialized ||
            provider.videoError != null) {
          return _buildFallbackContent(
            model.url.contains('tiktok.com') ? "TikTok" : "Video",
            model.name,
            errorMessage:
                provider.videoError ?? "Failed to initialize video player",
            onRetry: () => provider.initializeMedia(model),
          );
        }
        return Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: provider.videoController!.value.aspectRatio,
                child: VideoPlayer(provider.videoController!),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: provider.isPlayingVideo
                      ? provider.pauseVideo
                      : provider.playVideo,
                  icon: Icon(
                    provider.isPlayingVideo ? Icons.pause : Icons.play_arrow,
                    size: 30.sp,
                    color: ThemeProvider().isDarkMode
                        ? redShades[1]
                        : Colors.black,
                  ),
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    provider.videoController!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: goldenShades[0],
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case "text":
        log("Text case: extractedText=${model.extractedText?.substring(0, 50)}...");
        if (model.extractedText == null || model.extractedText!.isEmpty) {
          return _buildFallbackContent(
            "text",
            model.name,
            errorMessage: "No text content available",
            onRetry: () {
              log("Retrying media initialization for ${model.name}");
              provider.initializeMedia(model);
            },
          );
        }
        return _buildExtractedText(model.extractedText!);
      case "txt":
        log("Text file case: textContent=${provider.textContent?.substring(0, 50)}..., extractedText=${model.extractedText?.substring(0, 50)}...");
        if (provider.textContent == null ||
            provider.textContent!.startsWith("Error") ||
            provider.textContent!.startsWith("Failed")) {
          return _buildFallbackContent(
            "Text File",
            model.name,
            errorMessage:
                provider.textContent ?? "Failed to load text file content",
            onRetry: () => provider.initializeMedia(model),
          );
        }
        // Prefer extractedText for consistency, fall back to textContent
        return _buildExtractedText(model.extractedText?.isNotEmpty == true
            ? model.extractedText!
            : provider.textContent!);
      case "pdf":
        log("PDF Viewer: isPdfExpanded=$isPdfExpanded, pdfFilePath=$pdfFilePath, pdfError=$pdfError");
        if (pdfError != null || pdfFilePath == null) {
          return _buildFallbackContent(
            model.fileType,
            model.name,
            errorMessage: pdfError ?? "Failed to load PDF",
            onRetry: () => provider.initializeMedia(model),
          );
        }
        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isPdfExpanded
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: ReusablePdfViewer(
                sourceType: PdfSourceType.file,
                automaticallyImplyLeading: false,
                showNavigationActions: false,
                showTitle: false,
                filePath: pdfFilePath!,
              ),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  log("Toggling PDF expansion: isPdfExpanded=$isPdfExpanded");
                  onPdfToggle();
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isPdfExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 25.sp,
                    color: ThemeProvider().isDarkMode
                        ? redShades[1]
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      case "m4a":
      case "wav":
      case "mp3":
        if (provider.audioError != null) {
          return _buildFallbackContent(
            model.fileType,
            model.name,
            errorMessage: provider.audioError,
            onRetry: () => provider.initializeMedia(model),
          );
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: provider.isPlayingAudio
                      ? provider.pauseAudio
                      : () => provider.playAudio(model.url),
                  icon: Icon(
                    provider.isPlayingAudio ? Icons.pause : Icons.play_arrow,
                    size: 30.sp,
                    color: ThemeProvider().isDarkMode
                        ? redShades[1]
                        : Colors.black,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  provider.currentPosition != null
                      ? "${provider.currentPosition!.inMinutes}:${(provider.currentPosition!.inSeconds % 60).toString().padLeft(2, '0')}"
                      : "0:00",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  " / ${provider.audioDuration != null ? "${provider.audioDuration!.inMinutes}:${(provider.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')}" : "0:00"}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            Slider(
              value: provider.currentPosition?.inSeconds.toDouble() ?? 0,
              max: provider.audioDuration?.inSeconds.toDouble() ?? 1,
              onChanged: (value) async {
                await provider.seekAudio(Duration(seconds: value.toInt()));
              },
              activeColor: goldenShades[0],
              inactiveColor: Colors.grey,
            ),
          ],
        );
      default:
        return _buildFallbackContent(
          model.fileType,
          model.name,
          errorMessage: "Unsupported file type",
        );
    }
  }
}

// UnsupportedContentWidget remains unchanged
class UnsupportedContentWidget extends StatelessWidget {
  const UnsupportedContentWidget({
    super.key,
    required this.fileType,
    required this.fileName,
    this.errorMessage,
    this.onRetry,
  });

  final String fileType;
  final String fileName;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3, // Fixed max height
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          log("UnsupportedContentWidget: maxHeight=${constraints.maxHeight}, maxWidth=${constraints.maxWidth}");
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 40.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Preview Unavailable",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    errorMessage != null
                        ? "Unable to display $fileType content: $fileName\n$errorMessage"
                        : "Preview not available for $fileType content: $fileName",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14.sp),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Use tabs below to chat, view summaries, and more!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          DefaultTabController.of(context)?.animateTo(0);
                        },
                        icon: Icon(Icons.chat_bubble, size: 16.sp),
                        label: const Text("Ask"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldenShades[0],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          textStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        icon: Icon(Icons.description, size: 16.sp),
                        label: const Text("Summary"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          textStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  if (onRetry != null) ...[
                    SizedBox(height: 8.h),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: Icon(Icons.refresh, size: 16.sp),
                      label: const Text("Retry"),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        textStyle: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
