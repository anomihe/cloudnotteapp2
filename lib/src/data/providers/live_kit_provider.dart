import 'dart:developer';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitController extends ChangeNotifier {
  Room? _room;
  bool _isConnected = false;
  bool _isMinimized = false;
  bool _isMicEnabled = true;
  bool _isCameraEnabled = true;
  bool _isFrontCamera = true;
  bool _isScreenSharing = false;
  bool _isJoining = false;
  bool _isError = false;
  bool _isRecording = false;
  String _errorMessage = "";
  late EventsListener<RoomEvent> _listener;

  bool get isConnected => _isConnected;
  bool get isMinimized => _isMinimized;
  bool get isMicEnabled => _isMicEnabled;
  bool get isCameraEnabled => _isCameraEnabled;
  bool get isFrontCamera => _isFrontCamera;
  bool get isJoining => _isJoining;
  bool get isRecording => _isRecording;
  bool get isError => _isError;
  bool get isScreenSharing => _isScreenSharing;
  String? get errorMessage => _errorMessage;
  Room? get room => _room;
  EventsListener<RoomEvent> get listener => _listener;
  final String _defaultCallId = "368e345782";
  String get defaultCallId => _defaultCallId;

  setIsMinimized(bool value) {
    _isMinimized = value;
    notifyListeners();
  }

  Future<String?> getConnectionToken({
    required String username,
    required String email,
    required String fullName,
    required String userId,
    required String role,
    required String meetId,
  }) async {
    _isJoining = true;
    _isError = false;
    notifyListeners();
    try {
      log("CALL_IDENTITY: ${meetId}");
      final dio = dioClient();
      final response = await dio.post("/liveClass/joinCall", data: {
        "username": username,
        "callId": meetId,
        "userId": userId,
        "fullName": fullName,
        // "email": email,
        "role": role,
      });
      final data = response.data;
      log("DATA ${data.toString()}");
      return data['token'] as String?;
    } catch (e) {
      log("TOKEN ERROR: $e");
      _isJoining = false;
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> connectToRoom(String token) async {
    try {
      _isJoining = true;
      _isConnected = false;
      notifyListeners();
      _room = Room(
        roomOptions: RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultCameraCaptureOptions: const CameraCaptureOptions(
            deviceId: '',
            cameraPosition: CameraPosition.front,
            params: VideoParametersPresets.h720_169,
          ),
          defaultAudioCaptureOptions: const AudioCaptureOptions(
            deviceId: '',
            noiseSuppression: true,
            echoCancellation: true,
            autoGainControl: true,
            highPassFilter: true,
            typingNoiseDetection: true,
          ),
          defaultVideoPublishOptions: VideoPublishOptions(
            videoEncoding: VideoParametersPresets.h720_169.encoding,
            videoSimulcastLayers: [
              VideoParametersPresets.h180_169,
              VideoParametersPresets.h360_169,
            ],
          ),
          defaultAudioPublishOptions: const AudioPublishOptions(
            dtx: true,
          ),
        ),
      );
      _listener = _room!.createListener();
      await _room!.prepareConnection(
        "wss://cloudnottapp2-xbiutpjq.livekit.cloud",
        token,
      );
      await _room!.connect(
        "wss://cloudnottapp2-xbiutpjq.livekit.cloud",
        token,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
          rtcConfiguration: RTCConfiguration(
            iceServers: [
              RTCIceServer(urls: ['stun:stun.l.google.com:19302']),
            ],
          ),
        ),
      );
      await _room!.localParticipant?.setCameraEnabled(_isCameraEnabled,
          cameraCaptureOptions: CameraCaptureOptions(
            cameraPosition: CameraPosition.front,
          ));
      await _room!.localParticipant?.setMicrophoneEnabled(_isMicEnabled);
      _isConnected = true;
      _isJoining = false;
      notifyListeners();
    } catch (e) {
      _isJoining = false;
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
      log('Error connecting to room: $e');
    }
  }

  void toggleMic() {
    if (_room != null) {
      if (_room!.localParticipant != null) {
        _isMicEnabled = !_isMicEnabled;
        _room!.localParticipant!.setMicrophoneEnabled(_isMicEnabled);
        notifyListeners();
      }
    }
  }

  void toggleCamera() {
    if (_room != null) {
      if (_room!.localParticipant != null) {
        _isCameraEnabled = !_isCameraEnabled;
        // _room!.localParticipant!
        //     .setSourceEnabled(TrackSource.camera, _isCameraEnabled);
        _room!.localParticipant!.setCameraEnabled(_isCameraEnabled,
            cameraCaptureOptions:
                CameraCaptureOptions(cameraPosition: CameraPosition.front));
        notifyListeners();
      }
    }
  }

  void switchCamera() async {
    _isFrontCamera = !_isFrontCamera;
    notifyListeners();
    try {
      final videoTrack =
          _room!.localParticipant!.videoTrackPublications.firstOrNull?.track;
      if (videoTrack is LocalVideoTrack) {
        await videoTrack.setCameraPosition(
          _isFrontCamera ? CameraPosition.front : CameraPosition.back,
        );
      }
    } catch (error) {
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
      print('Error switching camera: $error');
    }
  }

  Future<void> startScreenShare() async {
    if (_room != null) {
      if (_room!.localParticipant != null) {
        try {
          FlutterBackground.enableBackgroundExecution();
          bool hasCapturePermission = await Helper.requestCapturePermission();
          if (!hasCapturePermission) {
            return;
          }
          // await requestBackgroundPermission();
          final screenShareTrack = await LocalVideoTrack.createScreenShareTrack(
            const ScreenShareCaptureOptions(
                useiOSBroadcastExtension: true, captureScreenAudio: true),
          );
          // await _room.localParticipant!.setScreenShareEnabled(true);
          await _room!.localParticipant?.publishVideoTrack(
            screenShareTrack,
          );
          _isScreenSharing = true;
          notifyListeners();
        } catch (e) {
          log('Error starting screen share: $e');
        }
      }
    }
  }

  Future<void> stopScreenShare() async {
    if (_room != null) {
      if (_room!.localParticipant != null && _isScreenSharing) {
        try {
          _isScreenSharing = false;
          await _room!.localParticipant!.setScreenShareEnabled(false);
          notifyListeners();
        } catch (e) {
          print('Error stopping screen share: $e');
        }
      }
    }
  }

  Future<void> startRecording(String callId) async {
    // Call backend API to start recording
    log("START_RECORDING");

    _isError = false;
    _isRecording = false;
    notifyListeners();
    try {
      final dio = dioClient();
      final response = await dio.get(
        "/liveClass/startRecording/$callId",
      );
      final data = response.data;
      log("DATA ${data.toString()}");
      if (response.statusCode == 200) {
        _isRecording = true;
        notifyListeners();
      }
      log("START_RECORDING_DATA: ${data.toString()}");
      return data;
    } on DioException catch (e) {
      log("ERROR: ${e.response?.data.toString()}");
      _isError = true;
      _errorMessage = "Error Starting Call Recording";
      notifyListeners();
    } catch (e) {
      log("ERROR: ${e.toString()}");
      _isError = true;
      _errorMessage = "Error Starting Call Recording";
      notifyListeners();
    }
  }

  Future<void> stopRecording(String callId) async {
    // Call backend API to stop recording
    log("STOP_RECORDING");
    _isError = false;
    notifyListeners();
    try {
      final dio = dioClient();
      final response = await dio.get(
        "/liveClass/stopRecording/$callId",
      );
      final data = response.data;
      log("DATA ${data.toString()}");
      if (response.statusCode == 200) {
        _isRecording = false;
        notifyListeners();
      }
      notifyListeners();
      log("STOP_RECORDING_DATA: ${data.toString()}");
      return data;
    } catch (e) {
      log("ERROR: $e");
      _isError = true;
      _errorMessage = "Error Stopping Call Recording";
      notifyListeners();
    }
  }

  requestBackgroundPermission([bool isRetry = false]) async {
    // Required for android screenshare.
    try {
      bool hasPermissions = await FlutterBackground.hasPermissions;
      if (!isRetry) {
        const androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: 'Screen Sharing',
          notificationText: 'Call App is sharing the screen.',
          notificationImportance: AndroidNotificationImportance.normal,
          notificationIcon:
              AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
        );
        hasPermissions =
            await FlutterBackground.initialize(androidConfig: androidConfig);
      }
      if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.enableBackgroundExecution();
      }
    } catch (e) {
      if (!isRetry) {
        return await Future<void>.delayed(const Duration(seconds: 1),
            () => requestBackgroundPermission(true));
      }
      print('could not publish video: $e');
    }
  }

  Participant? get activeSpeaker {
    return _room!.activeSpeakers.isNotEmpty
        ? _room!.activeSpeakers.first
        : null;
  }

  List<Participant> get participants {
    return [..._room!.remoteParticipants.values, _room!.localParticipant!];
  }

  VideoTrack? getVideoTrack(Participant participant) {
    // Check for an active screen share track
    final screenShareTrack = participant.videoTrackPublications.firstWhere(
      (track) => track.track?.source == TrackSource.screenShareVideo,
    );

    // Check for an active camera video track
    final cameraTrack = participant.videoTrackPublications.firstWhere(
      (track) => track.track?.source == TrackSource.camera,
    );

    // Return screen share if available, else camera
    return screenShareTrack.track as VideoTrack? ??
        cameraTrack.track as VideoTrack?;
  }

  void _onRoomEvent() {
    notifyListeners();
  }

  void disconnect() async {
    if (_room != null) {
      await _room!.disconnect();
      _room!.removeListener(_onRoomEvent);
      _room = null;
      _isConnected = false;
      notifyListeners();
    }
  }
}
