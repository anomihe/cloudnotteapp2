import 'dart:convert';
import 'dart:developer';

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/live_kit_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/data/service/chat_service.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/call_action_buttons.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/call_settings_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/live_chat_screen.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/widgets/no_video.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

enum Menu { screenshare, recording }

class LiveClassScreen extends StatefulWidget {
  static const String routeName = "/live_class";

  final String? callId;
  final String? username;
  final String? userId;
  final String? peerId;
  final Room? room;
  final EventsListener<RoomEvent>? listener;

  const LiveClassScreen({
    super.key,
    required this.callId,
    required this.username,
    required this.peerId,
    this.room,
    this.listener,
    required this.userId,
  });
  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}
class _LiveClassScreenState extends State<LiveClassScreen> {
  EventsListener<RoomEvent> get _listener => widget.listener!;
  bool get fastConnection => widget.room!.engine.fastConnectOptions != null;
  List<Participant> participants = [];
  List<Participant> teachers = [];
  Track? screenShareTrack;
  bool isScreenSharing = false;
  bool isTeacher = false;
  bool isRecording = false;
  bool isHandRaised = false; // ✅ Added hand raise state
  Set<String> raisedHands = {}; // ✅ Track who has raised hands
  double value = 0.62;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool visibleAction = true;
  final horizontalPadding = 5.0.w;
  final double boxWidth = 120.w;
  final double boxHeight = 140.h;

  @override
  void initState() {
    super.initState();
    widget.room!.addListener(_onRoomDidUpdate);
    _setUpListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatService>(context, listen: false).initialize(
        callId: widget.callId ?? "",
        username: widget.username ?? "",
        userId: widget.userId ?? "",
      );
    });
  }

  void _toggleVisibleAction() {
    if (mounted) {
      setState(() {
        visibleAction = !visibleAction;
      });
    }
  }

  // ✅ Hand raise functionality
  void _toggleHandRaise() {
    setState(() {
      isHandRaised = !isHandRaised;
    });
    
    // Send hand raise status via data channel
    final data = {
      'type': 'handRaise',
      'participantId': widget.room!.localParticipant?.identity ?? '',
      'isRaised': isHandRaised,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    widget.room!.localParticipant?.publishData(
      utf8.encode(json.encode(data)),
      reliable: true,
    );
  }

  // ✅ Handle received hand raise data
  void _handleHandRaiseData(Map<String, dynamic> data) {
    if (data['type'] == 'handRaise') {
      setState(() {
        if (data['isRaised'] == true) {
          raisedHands.add(data['participantId']);
        } else {
          raisedHands.remove(data['participantId']);
        }
      });
    }
  }

  void _sortParticipants() {
    List<Participant> participants = [];
    participants.addAll(widget.room!.remoteParticipants.values);
    
    // Enhanced sorting with hand raise priority
    participants.sort((a, b) {
      // Hand raised participants first (for teachers to see)
      bool aHandRaised = raisedHands.contains(a.identity);
      bool bHandRaised = raisedHands.contains(b.identity);
      
      if (aHandRaised != bHandRaised) {
        return aHandRaised ? -1 : 1;
      }
      
      // loudest speaker first
      if (a.isSpeaking && b.isSpeaking) {
        if (a.audioLevel > b.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.hasVideo != b.hasVideo) {
        return a.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.joinedAt.millisecondsSinceEpoch - b.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipant = widget.room!.localParticipant;
    if (localParticipant != null) {
      if (participants.length > 1) {
        participants.insert(1, localParticipant);
      } else {
        participants.add(localParticipant);
      }
    }
    
    List<Participant> teachers = [];
    for (final p in participants) {
      if (p.metadata != "student") {
        teachers.add(p);
        setState(() {
          isTeacher = true;
        });
      }
    }
    
    participants.removeWhere((p) => p.metadata != "student");
    setState(() {
      this.teachers = teachers;
      this.participants = participants;
      value = participants.isNotEmpty ? 0.55 : 0.80;
    });
  }

  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        log('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback(
          (timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
    })
    ..on<ParticipantEvent>((event) {

      log('Participant event ${event.toString()}');
      // sort participants on many track events as noted in documentation linked above

      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      setState(() {
        isRecording = event.activeRecording;
      });
    })
    ..on<RoomAttemptReconnectEvent>((event) {
      log('Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
    })
    ..on<LocalTrackSubscribedEvent>((event) {
      log('Local track subscribed: ${event.trackSid}');
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<TrackPublishedEvent>((event) {
      log("TRACK PUBLISHED: ${event.participant.identity}");
      _sortParticipants();
    })
    ..on<TrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<ParticipantNameUpdatedEvent>((event) {
      log('Participant name updated: ${event.participant.identity}, name => ${event.name}');
    })
    ..on<ParticipantMetadataUpdatedEvent>((event) {
      log('Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}');
    })
    ..on<RoomMetadataChangedEvent>((event) {
      log('Room metadata changed: ${event.metadata}');
    })
    ..on<DataReceivedEvent>((event) {
      // ✅ Handle hand raise data
      try {
        String decoded = utf8.decode(event.data);
        Map<String, dynamic> data = json.decode(decoded);
        _handleHandRaiseData(data);
      } catch (err) {
        print('Failed to decode data: $err');
      }
    });

  @override
  void dispose() {
    super.dispose();
    (() async {
      log("DISPOSE");
      await widget.room!.disconnect();
      widget.room!.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room!.dispose();
    })();
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final liveKitController = Provider.of<LiveKitController>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14.0.w,
            vertical: 10.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: isTeacher
                      ? [
                          if (isTeacher && teachers.isNotEmpty) ...[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: Container(
                                height: 150.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(
                                    color: blueShades[1],
                                    width: 4.w,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    _buildVideoOrScreenShare(teachers.first,
                                        onClick: () {
                                      _toggleVisibleAction();
                                    }),
                                    Positioned(
                                      top: 15.h,
                                      right: 15.w,
                                      child:
                                          liveKitController.isRecording == true
                                              ? Center(
                                                  child: SvgPicture.asset(
                                                    'assets/icons/rec_icon.svg',
                                                    fit: BoxFit.none,
                                                  ),
                                                )
                                              : const Center(),
                                    ),
                                    // ✅ Hand raise notification for teachers
                                    if (raisedHands.isNotEmpty && isTeacher) ...[
                                      Positioned(
                                        top: 15.h,
                                        left: 15.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.pan_tool,
                                                color: Colors.white,
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '${raisedHands.length}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    Positioned(
                                      bottom: 15.h,
                                      left: 15.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15.w,
                                          vertical: 7.h,
                                        ),
                                        height: 33.h,
                                        decoration: BoxDecoration(
                                          color: redShades[3],
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                        ),
                                        child: Text(
                                          teachers.isNotEmpty
                                              ? teachers.first.name
                                              : "Teacher",
                                          style: setTextTheme(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15.h,
                                      right: 15.w,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              liveKitController.switchCamera();
                                            },
                                            child: Container(
                                              width: 35.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: redShades[3],
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100.r,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .flip_camera_ios_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Container(
                                            width: 35.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: redShades[3],
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                100.r,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                teachers.first.isMuted
                                                    ? Icons.mic_off_outlined
                                                    : Icons
                                                        .keyboard_voice_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (userProvider.singleSpace?.role
                                            ?.toLowerCase() ==
                                        "teacher") ...[
                                      Positioned(
                                        top: 10.h,
                                        right: 15.w,
                                        child: CallButton(
                                          onTap: () {
                                            context.push(
                                              CallSettingsScreen.routeName,
                                              extra: widget.callId,
                                            );
                                          },
                                          svgIcon:
                                              'assets/icons/options_icon.svg',
                                          boxColor: blueShades[14],
                                          svgColor: whiteShades[0],
                                          width: 35,
                                          height: 35,
                                        ),
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (participants.isNotEmpty) ...[
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.776,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      participants.length > 2 ? 2 : 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: participants.length,
                                itemBuilder: (context, index) {
                                  final participant = participants[index];
                                  final hasRaisedHand = raisedHands.contains(participant.identity);
                                  
                                  return Container(
                                    width: 159.w,
                                    height: 135.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: hasRaisedHand ? Colors.orange : Colors.grey,
                                        width: hasRaisedHand ? 3.w : 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Stack(
                                      children: [
                                        participant.isCameraEnabled()
                                            ? _buildVideoOrScreenShare(
                                                participant, onClick: () {
                                                _toggleVisibleAction();
                                              })
                                            : const NoVideoWidget(),
                                        // ✅ Hand raise indicator
                                        if (hasRaisedHand) ...[
                                          Positioned(
                                            top: 10.h,
                                            right: 10.w,
                                            child: Container(
                                              padding: EdgeInsets.all(6.r),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.pan_tool,
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                        Positioned(
                                          bottom: 10.h,
                                          left: 10.w,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 3.h,
                                            ),
                                            height: 26.h,
                                            decoration: BoxDecoration(
                                              color: redShades[3],
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                            ),
                                            child: Text(
                                              participant.name,
                                              style: setTextTheme(
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7.h,
                                          right: 10.w,
                                          child: Row(
                                            children: [
                                              if (participant == widget.room!.localParticipant) ...[
                                                GestureDetector(
                                                  onTap: () {
                                                    liveKitController
                                                        .switchCamera();
                                                  },
                                                  child: Container(
                                                    width: 35.w,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                      color: redShades[3],
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        100.r,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .flip_camera_ios_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                              ],
                                              Container(
                                                width: 35.w,
                                                height: 30.h,
                                                decoration: BoxDecoration(
                                                  color: redShades[3],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.r),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    participant.isMuted
                                                        ? Icons.mic_off_outlined
                                                        : Icons
                                                            .keyboard_voice_outlined,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        ]
                      : [
                          if (participants.isNotEmpty) ...[
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.776,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      participants.length > 2 ? 2 : 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 1,
                                ),
                                itemCount: participants.length,
                                itemBuilder: (context, index) {
                                  final participant = participants[index];
                                  final hasRaisedHand = raisedHands.contains(participant.identity);
                                  
                                  return Container(
                                    width: 100.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.r),
                                      border: Border.all(
                                        color: hasRaisedHand ? Colors.orange : Colors.grey,
                                        width: hasRaisedHand ? 3.w : 1.w,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        participant.isCameraEnabled()
                                            ? _buildVideoOrScreenShare(
                                                participant, onClick: () {
                                                _toggleVisibleAction();
                                              })
                                            : const NoVideoWidget(),
                                        // ✅ Hand raise indicator
                                        if (hasRaisedHand) ...[
                                          Positioned(
                                            top: 10.h,
                                            right: 10.w,
                                            child: Container(
                                              padding: EdgeInsets.all(6.r),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.pan_tool,
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                        Positioned(
                                          bottom: 10.h,
                                          left: 10.w,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 3.h,
                                            ),
                                            height: 26.h,
                                            decoration: BoxDecoration(
                                              color: redShades[3],
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                            ),
                                            child: Text(
                                              participant.name,
                                              style: setTextTheme(
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7.h,
                                          right: 10.w,
                                          child: Row(
                                            children: [
                                              if (participant == widget.room!.localParticipant) ...[
                                                GestureDetector(
                                                  onTap: () {
                                                    liveKitController
                                                        .switchCamera();
                                                  },
                                                  child: Container(
                                                    width: 35.w,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                      color: redShades[3],
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        100.r,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .flip_camera_ios_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                              ],
                                              Container(
                                                width: 35.w,
                                                height: 30.h,
                                                decoration: BoxDecoration(
                                                  color: redShades[3],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.r),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    participant.isMuted
                                                        ? Icons.mic_off_outlined
                                                        : Icons
                                                            .keyboard_voice_outlined,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        ],
                ),
              ),
              SizedBox(height: 10.h),
              
              // ✅ Enhanced Action Buttons with Hand Raise
              if (visibleAction)

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: blueShades[15],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Mic Toggle
                          ToggleColorCallButton(
                            isPressed: liveKitController.isMicEnabled,
                            onTap: () {
                              liveKitController.toggleMic();
                              setState(() {});
                            },
                            svgIcon: Icons.keyboard_voice_outlined,
                            svgIcon1: Icons.mic_off_outlined,
                            boxColor: blueShades[3],
                          ),
                          SizedBox(width: 10.w),
                          
                          // Camera Toggle
                          ToggleColorCallButton(
                            isPressed: liveKitController.isCameraEnabled,
                            onTap: () {
                              liveKitController.toggleCamera();
                              setState(() {});
                            },
                            svgIcon: Icons.videocam_outlined,
                            svgIcon1: Icons.videocam_off_outlined,
                            boxColor: blueShades[3],
                          ),
                          SizedBox(width: 10.w),
                          
                          // ✅ Hand Raise Button (Only for students)
                          if (userProvider.user?.type != "teacher") ...[
                            GestureDetector(
                              onTap: _toggleHandRaise,
                              child: Container(
                                width: 48.w,
                                height: 43.h,
                                decoration: BoxDecoration(
                                  color: isHandRaised 
                                      ? Colors.orange 
                                      : blueShades[3],
                                  borderRadius: BorderRadius.circular(100.r),
                                  border: isHandRaised 
                                      ? Border.all(color: Colors.white, width: 2) 
                                      : null,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.pan_tool,
                                    color: isHandRaised 
                                        ? Colors.white 
                                        : blueShades[2],
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          
                          // Chat Button
                          CallButton(
                            onTap: () {
                              log("CALLID FOR CHAT ${widget.callId}");
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                isDismissible: true,
                                useSafeArea: true,
                                builder: (context) {
                                  return LiveClassChat(
                                    callId: widget.callId,
                                  );
                                },
                              );
                            },
                            svgIcon: 'assets/icons/message_icon.svg',
                            boxColor: blueShades[3],
                          ),
                          SizedBox(width: 10.w),
                          
                          // Screen Share (Teachers only)
                          if (userProvider.user?.type != "student") ...[
                            CallButton(
                              onTap: () {
                                if (liveKitController.isScreenSharing) {
                                  liveKitController.stopScreenShare();
                                  return;
                                }
                                liveKitController.startScreenShare();
                              },
                              svgIcon: 'assets/icons/screen_share.svg',
                              boxColor: liveKitController.isScreenSharing 
                                  ? Colors.green 
                                  : blueShades[3],
                            ),
                            SizedBox(width: 10.w),
                          ],
                          
                          // End Call Button
                          CallButton(
                            onTap: () {
                              liveKitController.disconnect();
                              context.pushReplacement(
                                StudentLandingScreen.routeName,
                                extra: {
                                  "id": context.read<UserProvider>().user?.id ?? "",
                                  "provider": userProvider,
                                },
                              );
                            },
                            width: 60.w,
                            svgIcon: 'assets/icons/call_icon_flat.svg',
                            svgColor: whiteShades[0],
                            boxColor: redShades[1],
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildVideoOrScreenShare(Participant participant, {void Function()? onClick}) {
  print("Building video for participant: ${participant.identity}");
  
  // Get camera track
  final cameraTrackPublication = participant.videoTrackPublications
      .where((pub) => pub.source == TrackSource.camera)
      .isNotEmpty
      ? participant.videoTrackPublications.firstWhere(
          (pub) => pub.source == TrackSource.camera,
        )
      : null;

  final cameraTrack = cameraTrackPublication != null &&
          !cameraTrackPublication.muted &&
          cameraTrackPublication.subscribed
      ? cameraTrackPublication.track
      : null;

  // Get screen share track
  final screenShareTrackPublication = participant.videoTrackPublications
      .where((pub) => pub.source == TrackSource.screenShareVideo)
      .isNotEmpty
      ? participant.videoTrackPublications.firstWhere(
          (pub) => pub.source == TrackSource.screenShareVideo,
        )
      : null;

  final screenShareTrack = screenShareTrackPublication != null &&
          !screenShareTrackPublication.muted &&
          screenShareTrackPublication.subscribed
      ? screenShareTrackPublication.track
      : null;

  // Priority: Screen share > Camera
  final activeTrack = screenShareTrack ?? cameraTrack;

  // Update state if needed (uncomment and modify as per your state management)
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   setState(() {
  //     if (screenShareTrack != null) {
  //       this.screenShareTrack = screenShareTrack;
  //       isScreenSharing = true;
  //     } else {
  //       isScreenSharing = false;
  //     }
  //   });
  // });

  return GestureDetector(
    onDoubleTap: onClick,
    child: Material(
      color: Colors.transparent,
      child: activeTrack != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: VideoTrackRenderer(
                activeTrack as VideoTrack,
                fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                // renderMode: VideoRenderMode.platformView, // Uncomment if needed
              ),
            )
          : const NoVideoWidget(),
    ),
  );
}
}

Widget _classMatesContainer() {
  return Container(
    width: 45.w,
    height: 41.h,
    decoration: BoxDecoration(
      color: whiteShades[0],
      borderRadius: BorderRadius.circular(100.r),
      border: Border.all(color: blueShades[8], width: 2.w),
      image: const DecorationImage(
          image: AssetImage('assets/app/mock_person_image.jpg'),
          fit: BoxFit.cover),
    ),
  );
}

Widget callButtons(void Function() ontap, String svgIcon,
    {Color? boxColor, Color? svgColor, double? width, double? height}) {
  return Container(
    width: width ?? 48.w,
    height: height ?? 43.h,
    decoration: BoxDecoration(
      color: boxColor ?? blueShades[1],
      borderRadius: BorderRadius.circular(100.r),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100.r),
        onTap: ontap,
        splashColor: Colors.grey.withOpacity(0.3),
        child: Center(
          child: SvgPicture.asset(
            svgIcon,
            colorFilter:
                ColorFilter.mode(svgColor ?? blueShades[2], BlendMode.srcIn),
            fit: BoxFit.none,
          ),
        ),
      ),
    ),
  );
        
        
        }
// class _LiveClassScreenState extends State<LiveClassScreen> {
//   EventsListener<RoomEvent> get _listener => widget.listener!;
//   bool get fastConnection => widget.room!.engine.fastConnectOptions != null;
//   List<Participant> participants = [];
//   List<Participant> teachers = [];
//   Track? screenShareTrack;
//   bool isScreenSharing = false;
//   bool isTeacher = false;
//   bool isRecording = false;
//   double value = 0.62;
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   bool visibleAction = true;
//   final horizontalPadding = 5.0.w;
//   final double boxWidth = 120.w; // Width of the draggable box
//   final double boxHeight = 140.h; // Height of the draggable bo

//   @override
//   void initState() {
//     super.initState();
//     widget.room!.addListener(_onRoomDidUpdate);
//     _setUpListeners();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ChatService>(context, listen: false).initialize(
//         callId: widget.callId ?? "",
//         username: widget.username ?? "",
//         userId: widget.userId ?? "",
//       );
//     });
//   }

//   void _toggleVisibleAction() {
//     if (mounted) {
//       setState(() {
//         visibleAction = !visibleAction;
//       });
//     }
//   }

//   void _sortParticipants() {
//     List<Participant> participants = [];
//     participants.addAll(widget.room!.remoteParticipants.values);
//     // sort speakers for the grid
//     participants.sort((a, b) {
//       // loudest speaker first
//       if (a.isSpeaking && b.isSpeaking) {
//         if (a.audioLevel > b.audioLevel) {
//           return -1;
//         } else {
//           return 1;
//         }
//       }

//       // last spoken at
//       final aSpokeAt = a.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
//       final bSpokeAt = b.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

//       if (aSpokeAt != bSpokeAt) {
//         return aSpokeAt > bSpokeAt ? -1 : 1;
//       }

//       // video on
//       if (a.hasVideo != b.hasVideo) {
//         return a.hasVideo ? -1 : 1;
//       }

//       // joinedAt
//       return a.joinedAt.millisecondsSinceEpoch -
//           b.joinedAt.millisecondsSinceEpoch;
//     });

//     final localParticipant = widget.room!.localParticipant;
//     if (localParticipant != null) {
//       if (participants.length > 1) {
//         participants.insert(1, localParticipant);
//       } else {
//         participants.add(localParticipant);
//       }
//     }
//     List<Participant> teachers = [];

//     for (final p in participants) {
//       if (p.metadata != "student") {
//         teachers.add(p);
//         setState(() {
//           isTeacher = true;
//         });
//       }
//     }
//     participants.removeWhere((p) => p.metadata != "student");
//     setState(() {
//       this.teachers = teachers;
//       this.participants = participants;
//       value = participants.isNotEmpty ? 0.55 : 0.80;
//     });
//   }

//   void _setUpListeners() => _listener
//     ..on<RoomDisconnectedEvent>((event) async {
//       if (event.reason != null) {
//         print('Room disconnected: reason => ${event.reason}');
//       }
//       WidgetsBindingCompatible.instance?.addPostFrameCallback(
//           (timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
//       // WidgetsBindingCompatible.instance
//       //     ?.addPostFrameCallback((timeStamp) => context.pop());
//     })
//     ..on<ParticipantEvent>((event) {
//       print('Participant event ${event.toString()}');
//       // sort participants on many track events as noted in documentation linked above
//       _sortParticipants();
//       // _onRoomDidUpdate();
//     })
//     ..on<RoomRecordingStatusChanged>((event) {
//       // context.showRecordingStatusChangedDialog(event.activeRecording);
//     })
//     ..on<RoomAttemptReconnectEvent>((event) {
//       print(
//           'Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
//           '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
//     })
//     ..on<LocalTrackSubscribedEvent>((event) {
//       print('Local track subscribed: ${event.trackSid}');
//     })
//     ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
//     ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
//     ..on<TrackSubscribedEvent>((_) => _sortParticipants())
//     ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
//     ..on<TrackPublishedEvent>((event) {
//       print("TRACK PUBLISHED: ${event.participant.identity}");
//       _sortParticipants();
//     })
//     ..on<TrackUnpublishedEvent>((_) => _sortParticipants())
//     // ..on<TrackE2EEStateEvent>()
//     ..on<ParticipantNameUpdatedEvent>((event) {
//       print(
//           'Participant name updated: ${event.participant.identity}, name => ${event.name}');
//     })
//     ..on<ParticipantMetadataUpdatedEvent>((event) {
//       print(
//           'Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}');
//     })
//     ..on<RoomMetadataChangedEvent>((event) {
//       print('Room metadata changed: ${event.metadata}');
//     })
//     ..on<DataReceivedEvent>((event) {
//       // String decoded = 'Failed to decode';
//       // try {
//       //   decoded = utf8.decode(event.data);
//       // } catch (err) {
//       //   print('Failed to decode: $err');
//       // }
//       // context.showDataReceivedDialog(decoded);
//     });

//   @override
//   void dispose() {
//     (() async {
//       log("DISPOSE");
//       await widget.room!.disconnect();
//       widget.room!.removeListener(_onRoomDidUpdate);
//       await _listener.dispose();
//       await widget.room!.dispose();
//     })();
//     super.dispose();
//   }

//   void _onRoomDidUpdate() {
//     _sortParticipants();
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   setState(() {});
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final liveKitController = Provider.of<LiveKitController>(context);
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 14.0.w,
//             vertical: 10.h,
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _currentPage = index;
//                     });
//                   },
//                   children: isTeacher
//                       ? [
//                           if (isTeacher && teachers.isNotEmpty) ...[
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.80,
//                               child: Container(
//                                 height: 150.h,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30.r),
//                                   border: Border.all(
//                                     color: blueShades[1],
//                                     width: 4.w,
//                                   ),
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     _buildVideoOrScreenShare(teachers.first,
//                                         onClick: () {
//                                       _toggleVisibleAction();
//                                     }),
//                                     Positioned(
//                                       top: 15.h,
//                                       right: 15.w,
//                                       child:
//                                           liveKitController.isRecording == true
//                                               ? Center(
//                                                   child: SvgPicture.asset(
//                                                     'assets/icons/rec_icon.svg',
//                                                     fit: BoxFit.none,
//                                                   ),
//                                                 )
//                                               : const Center(),
//                                     ),
//                                     Positioned(
//                                       bottom: 15.h,
//                                       left: 15.w,
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 15.w,
//                                           vertical: 7.h,
//                                         ),
//                                         height: 33.h,
//                                         decoration: BoxDecoration(
//                                           color: redShades[3],
//                                           borderRadius:
//                                               BorderRadius.circular(100.r),
//                                         ),
//                                         child: Text(
//                                           teachers.isNotEmpty
//                                               ? teachers.first.name
//                                               : "Teacher",
//                                           style: setTextTheme(
//                                             fontSize: 15.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 15.h,
//                                       right: 15.w,
//                                       child: Row(
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               liveKitController.switchCamera();
//                                             },
//                                             child: Container(
//                                               width: 35.w,
//                                               height: 30.h,
//                                               decoration: BoxDecoration(
//                                                 color: redShades[3],
//                                                 border: Border.all(
//                                                     color: Colors.grey),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                   100.r,
//                                                 ),
//                                               ),
//                                               child: Center(
//                                                 child: Icon(
//                                                   Icons
//                                                       .flip_camera_ios_outlined,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 5.w,
//                                           ),
//                                           Container(
//                                             width: 35.w,
//                                             height: 30.h,
//                                             decoration: BoxDecoration(
//                                               color: redShades[3],
//                                               border: Border.all(
//                                                   color: Colors.grey),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                 100.r,
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Icon(
//                                                 teachers.first.isMuted
//                                                     ? Icons.mic_off_outlined
//                                                     : Icons
//                                                         .keyboard_voice_outlined,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (userProvider.singleSpace?.role
//                                             ?.toLowerCase() ==
//                                         "teacher") ...[
//                                       Positioned(
//                                         top: 10.h,
//                                         right: 15.w,
//                                         child: CallButton(
//                                           onTap: () {
//                                             context.push(
//                                               CallSettingsScreen.routeName,
//                                               extra: widget.callId,
//                                             );
//                                           },
//                                           svgIcon:
//                                               'assets/icons/options_icon.svg',
//                                           boxColor: blueShades[14],
//                                           svgColor: whiteShades[0],
//                                           width: 35,
//                                           height: 35,
//                                         ),
//                                       )
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                           if (participants.isNotEmpty) ...[
//                             SizedBox(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.776,
//                               child: GridView.builder(
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount:
//                                       participants.length > 2 ? 2 : 1,
//                                   crossAxisSpacing: 8,
//                                   mainAxisSpacing: 4,
//                                 ),
//                                 itemCount: participants.length,
//                                 itemBuilder: (context, index) {
//                                   final participant = participants[index];
//                                   return Container(
//                                     width: 159.w,
//                                     height: 135.h,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(25.r),
//                                       // image: const DecorationImage(
//                                       //   image: AssetImage('assets/app/student_image.png'),
//                                       //   fit: BoxFit.cover,
//                                       // ),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         participant.isCameraEnabled()
//                                             ? _buildVideoOrScreenShare(
//                                                 participant, onClick: () {
//                                                 _toggleVisibleAction();
//                                               })
//                                             : const NoVideoWidget(),
//                                         Positioned(
//                                           bottom: 10.h,
//                                           left: 10.w,
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 15.w,
//                                               vertical: 3.h,
//                                             ),
//                                             height: 26.h,
//                                             decoration: BoxDecoration(
//                                               color: redShades[3],
//                                               borderRadius:
//                                                   BorderRadius.circular(100.r),
//                                             ),
//                                             child: Text(
//                                               participant.name,
//                                               style: setTextTheme(
//                                                 fontSize: 16.sp,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           // me box
//                                           bottom: 7.h,
//                                           right: 10.w,
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   liveKitController
//                                                       .switchCamera();
//                                                 },
//                                                 child: Container(
//                                                   width: 35.w,
//                                                   height: 30.h,
//                                                   decoration: BoxDecoration(
//                                                     color: redShades[3],
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                       100.r,
//                                                     ),
//                                                   ),
//                                                   child: Center(
//                                                     child: Icon(
//                                                       Icons
//                                                           .flip_camera_ios_outlined,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                               Container(
//                                                 width: 35.w,
//                                                 height: 30.h,
//                                                 decoration: BoxDecoration(
//                                                   color: redShades[3],
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           100.r),
//                                                 ),
//                                                 child: Center(
//                                                   child: Icon(
//                                                     participant.isMuted
//                                                         ? Icons.mic_off_outlined
//                                                         : Icons
//                                                             .keyboard_voice_outlined,
//                                                     color: Colors.black,
//                                                   ),
//                                                   // child: SvgPicture.asset(
//                                                   //   participant.isMuted
//                                                   //       ? "assets/icons/voice_record_icon_muted.svg"
//                                                   //       : 'assets/icons/voice_record_icon.svg',
//                                                   //   colorFilter: ColorFilter.mode(
//                                                   //     blueShades[2],
//                                                   //     BlendMode.srcIn,
//                                                   //   ),
//                                                   //   fit: BoxFit.none,
//                                                   // ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ]
//                         ]
//                       : [
//                           if (participants.isNotEmpty) ...[
//                             SizedBox(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.776,
//                               child: GridView.builder(
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount:
//                                       participants.length > 2 ? 2 : 1,
//                                   crossAxisSpacing: 8,
//                                   mainAxisSpacing: 1,
//                                 ),
//                                 itemCount: participants.length,
//                                 itemBuilder: (context, index) {
//                                   final participant = participants[index];
//                                   return Container(
//                                     width: 100.w,
//                                     height: 60.h,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(25.r),
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         participant.isCameraEnabled()
//                                             ? _buildVideoOrScreenShare(
//                                                 participant, onClick: () {
//                                                 _toggleVisibleAction();
//                                               })
//                                             : const NoVideoWidget(),
//                                         Positioned(
//                                           bottom: 10.h,
//                                           left: 10.w,
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 15.w,
//                                               vertical: 3.h,
//                                             ),
//                                             height: 26.h,
//                                             decoration: BoxDecoration(
//                                               color: redShades[3],
//                                               borderRadius:
//                                                   BorderRadius.circular(100.r),
//                                             ),
//                                             child: Text(
//                                               participant.name,
//                                               style: setTextTheme(
//                                                 fontSize: 16.sp,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           // me box
//                                           bottom: 7.h,
//                                           right: 10.w,
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   liveKitController
//                                                       .switchCamera();
//                                                 },
//                                                 child: Container(
//                                                   width: 35.w,
//                                                   height: 30.h,
//                                                   decoration: BoxDecoration(
//                                                     color: redShades[3],
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                       100.r,
//                                                     ),
//                                                   ),
//                                                   child: Center(
//                                                     child: Icon(
//                                                       Icons
//                                                           .flip_camera_ios_outlined,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                               Container(
//                                                 width: 35.w,
//                                                 height: 30.h,
//                                                 decoration: BoxDecoration(
//                                                   color: redShades[3],
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           100.r),
//                                                 ),
//                                                 child: Center(
//                                                   child: Icon(
//                                                     participant.isMuted
//                                                         ? Icons.mic_off_outlined
//                                                         : Icons
//                                                             .keyboard_voice_outlined,
//                                                     color: Colors.black,
//                                                   ),
//                                                   // child: SvgPicture.asset(
//                                                   //   participant.isMuted
//                                                   //       ? "assets/icons/voice_record_icon_muted.svg"
//                                                   //       : 'assets/icons/voice_record_icon.svg',
//                                                   //   colorFilter: ColorFilter.mode(
//                                                   //     blueShades[2],
//                                                   //     BlendMode.srcIn,
//                                                   //   ),
//                                                   //   fit: BoxFit.none,
//                                                   // ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ]
//                         ],
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               // Replace your current action buttons section with this:

// SizedBox(height: 10.h),
// if (visibleAction)
//   Align(  // ✅ Use Align instead of Positioned
//     alignment: Alignment.bottomCenter,
//     child: Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: horizontalPadding,
//       ),
//       padding: EdgeInsets.all(10.r),
//       decoration: BoxDecoration(
//         color: blueShades[15],
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
//         children: [
//           ToggleColorCallButton(
//             // voice call muted icon
//             isPressed: liveKitController.isMicEnabled,
//             onTap: () {
//               // call to be muted logic
//               liveKitController.toggleMic();
//               setState(() {});
//             },
//             svgIcon: Icons.keyboard_voice_outlined,
//             svgIcon1: Icons.mic_off_outlined,
//             boxColor: blueShades[3],
//             // svgColor: whiteShades[0],
//           ),
//           SizedBox(width: 10.w),
//           ToggleColorCallButton(
//             // toggle video icon
//             isPressed: liveKitController.isCameraEnabled,
//             onTap: () {
//               // video to be paused logic
//               liveKitController.toggleCamera();
//               setState(() {});
//             },
//             svgIcon: Icons.videocam_outlined,
//             svgIcon1: Icons.videocam_off_outlined,
//             boxColor: blueShades[3],
//           ),
//           SizedBox(width: 10.w),
//           CallButton(
//             onTap: () {
//               // show live chat screen but dont leave the screen
//               log("CALLID FOR CHAT ${widget.callId}");
//               showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 isDismissible: true,
//                 useSafeArea: true,
//                 builder: (context) {
//                   return LiveClassChat(
//                     callId: widget.callId,
//                   );
//                 },
//               );
//             },
//             svgIcon: 'assets/icons/message_icon.svg',
//             boxColor: blueShades[3],
//           ),
//           SizedBox(width: 10.w),
//           if (userProvider.user?.type != "student") ...[
//             CallButton(
//               onTap: () {
//                 if (liveKitController.isScreenSharing) {
//                   liveKitController.stopScreenShare();
//                   return;
//                 }
//                 liveKitController.startScreenShare();
//               },
//               svgIcon: 'assets/icons/screen_share.svg',
//               boxColor: blueShades[3],
//             ),
//             SizedBox(width: 10.w),
//           ],
//           CallButton(
//             // end call button
//             onTap: () {
//               liveKitController.disconnect();
//               context.pushReplacement(
//                 StudentLandingScreen.routeName,
//                 extra: {
//                   "id": context.read<UserProvider>().user?.id ?? "",
//                   "provider": userProvider,
//                 },
//               );
//             },
//             width: screenSize.width * 0.15, // ✅ Reduced width to prevent overflow
//             svgIcon: 'assets/icons/call_icon_flat.svg',
//             svgColor: whiteShades[0],
//             boxColor: redShades[1],
//           ),
//         ],
//       ),
//     ),
//   ),
//               // if (visibleAction)
//               //   Positioned(
//               //     left: (screenSize.width / 10) - horizontalPadding * 3,
//               //     bottom: 4.h,
//               //     child: Container(
//               //       padding: EdgeInsets.all(10.r),
//               //       decoration: BoxDecoration(
//               //         color: blueShades[15],
//               //         borderRadius: BorderRadius.circular(20.r),
//               //       ),
//               //       child: Row(
//               //         children: [
//               //           ToggleColorCallButton(
//               //             // voice call muted icon
//               //             isPressed: liveKitController.isMicEnabled,
//               //             onTap: () {
//               //               // call to be muted logic
//               //               liveKitController.toggleMic();
//               //               setState(() {});
//               //             },
//               //             svgIcon: Icons.keyboard_voice_outlined,
//               //             svgIcon1: Icons.mic_off_outlined,
//               //             boxColor: blueShades[3],
//               //             // svgColor: whiteShades[0],
//               //           ),
//               //           SizedBox(
//               //             width: 10.w,
//               //           ),
//               //           ToggleColorCallButton(
//               //             // toggle video icon
//               //             isPressed: liveKitController.isCameraEnabled,
//               //             onTap: () {
//               //               // video to be paused logic
//               //               liveKitController.toggleCamera();
//               //               setState(() {});
//               //             },
//               //             svgIcon: Icons.videocam_outlined,
//               //             svgIcon1: Icons.videocam_off_outlined,
//               //             boxColor: blueShades[3],
//               //           ),
//               //           SizedBox(
//               //             width: 10.w,
//               //           ),
//               //           CallButton(
//               //             onTap: () {
//               //               // show live chat screen but dont leave the screen
//               //               log("CALLID FOR CHAT ${widget.callId}");
//               //               showModalBottomSheet(
//               //                 isScrollControlled: true,
//               //                 context: context,
//               //                 isDismissible: true,
//               //                 useSafeArea: true,
//               //                 builder: (context) {
//               //                   return LiveClassChat(
//               //                     callId: widget.callId,
//               //                   );
//               //                 },
//               //               );
//               //             },
//               //             svgIcon: 'assets/icons/message_icon.svg',
//               //             boxColor: blueShades[3],
//               //           ),
//               //           SizedBox(
//               //             width: 10.w,
//               //           ),
//               //           if (userProvider.user?.type != "student") ...[
//               //             CallButton(
//               //               onTap: () {
//               //                 if (liveKitController.isScreenSharing) {
//               //                   liveKitController.stopScreenShare();
//               //                   return;
//               //                 }
//               //                 liveKitController.startScreenShare();
//               //               },
//               //               svgIcon: 'assets/icons/screen_share.svg',
//               //               boxColor: blueShades[3],
//               //             ),
//               //             SizedBox(
//               //               width: 10.w,
//               //             ),
//               //           ],
//               //           const Spacer(),
//               //           CallButton(
//               //             // end call button
//               //             onTap: () {
//               //               liveKitController.disconnect();
//               //               context.pushReplacement(
//               //                 StudentLandingScreen.routeName,
//               //                 extra: {
//               //                   "id":
//               //                       context.read<UserProvider>().user?.id ?? "",
//               //                   "provider": userProvider,
//               //                 },
//               //               );
//               //             },
//               //             width: screenSize.width * 0.2,
//               //             svgIcon: 'assets/icons/call_icon_flat.svg',
//               //             svgColor: whiteShades[0],
//               //             boxColor: redShades[1],
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoOrScreenShare(Participant participant,
//       {void Function()? onClick}) {
//     // Retrieve camera track
//     // final cameraTrackPublication =
//     //     participant.videoTrackPublications.firstWhere(
//     //   (pub) => pub.source == TrackSource.camera,
//     // );
//     final cameraTrackPublication = participant.videoTrackPublications
//             .where((pub) => pub.source == TrackSource.camera)
//             .isNotEmpty
//         ? participant.videoTrackPublications.firstWhere(
//             (pub) => pub.source == TrackSource.camera,
//           )
//         : null;

//     final cameraTrack =
//         cameraTrackPublication != null && !cameraTrackPublication.muted
//             ? cameraTrackPublication.track
//             : null;

//     // Retrieve screen share track
//     final screenShareTrackPublication = participant.videoTrackPublications
//             .where((pub) => pub.source == TrackSource.screenShareVideo)
//             .isNotEmpty
//         ? participant.videoTrackPublications.firstWhere(
//             (pub) => pub.source == TrackSource.screenShareVideo,
//           )
//         : null;

//     final screenShareTrack = screenShareTrackPublication != null &&
//             !screenShareTrackPublication.muted
//         ? screenShareTrackPublication.track
//         : null;

//     // Priority: Screen share > Camera
//     // final activeTrack = cameraTrack;
//     final activeTrack = screenShareTrack ?? cameraTrack;
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   setState(() {
//     //     teachers.insert(0, participant);
//     //     this.screenShareTrack = screenShareTrack;
//     //     isScreenSharing = screenShareTrack != null ? true : false;
//     //   });
//     // });

//     (() async {});

//     return GestureDetector(
//       onDoubleTap: onClick,
//       child: Material(
//         color: Colors.transparent,
//         child: activeTrack != null
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(25.r),
//                 child: VideoTrackRenderer(
//                   activeTrack as VideoTrack,
//                   fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                   // renderMode: VideoRenderMode.platformView,
//                 ),
//               )
//             : const NoVideoWidget(),
//       ),
//     );
//   }
// }

// Widget _classMatesContainer() {
//   return Container(
//     width: 45.w,
//     height: 41.h,
//     decoration: BoxDecoration(
//       color: whiteShades[0],
//       borderRadius: BorderRadius.circular(100.r),
//       border: Border.all(color: blueShades[8], width: 2.w),
//       image: const DecorationImage(
//           image: AssetImage('assets/app/mock_person_image.jpg'),
//           fit: BoxFit.cover),
//     ),
//   );
// }

// Widget callButtons(void Function() ontap, String svgIcon,
//     {Color? boxColor, Color? svgColor, double? width, double? height}) {
//   return Container(
//     width: width ?? 48.w,
//     height: height ?? 43.h,
//     decoration: BoxDecoration(
//       color: boxColor ?? blueShades[1],
//       borderRadius: BorderRadius.circular(100.r),
//     ),
//     child: Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(100.r),
//         onTap: ontap,
//         splashColor: Colors.grey.withOpacity(0.3),
//         child: Center(
//           child: SvgPicture.asset(
//             svgIcon,
//             colorFilter:
//                 ColorFilter.mode(svgColor ?? blueShades[2], BlendMode.srcIn),
//             fit: BoxFit.none,
//           ),
//         ),
//       ),
//     ),
//   );
// }

// class ToggleColorCallButton extends StatefulWidget {
//   final void Function() onTap;
//   final bool isPressed;
//   final String svgIcon;
//   final Color? boxColor;
//   final double? width;
//   final double? height;

//   const ToggleColorCallButton({
//     super.key,
//     required this.onTap,
//     required this.svgIcon,
//     this.boxColor,
//     this.width,
//     this.height,
//     required this.isPressed,
//   });

//   @override
//   _ToggleColorCallButtonState createState() => _ToggleColorCallButtonState();
// }

// class _ToggleColorCallButtonState extends State<ToggleColorCallButton> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         widget.onTap();
//       },
//       borderRadius: BorderRadius.circular(100.r),
//       child: Container(
//         width: widget.width ?? 48.w,
//         height: widget.height ?? 43.h,
//         decoration: BoxDecoration(
//           color: widget.isPressed
//               ? (widget.boxColor ?? blueShades[1])
//               : blueShades[1],
//           borderRadius: BorderRadius.circular(100.r),
//         ),
//         child: SvgPicture.asset(
//           widget.svgIcon,
//           colorFilter: ColorFilter.mode(
//             widget.isPressed ? blueShades[2] : whiteShades[0],
//             BlendMode.srcIn,
//           ),
//           fit: BoxFit.none,
//         ),
//       ),
//     );
//   }
// }
// class LiveClassScreenBK extends StatelessWidget {
//   const LiveClassScreenBK({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Column(
//             children: [
              // if (isTeacher && teachers.isNotEmpty) ...[
              //   SizedBox(
              //     height: MediaQuery.of(context).size.height * value,
              //     child: Container(
              //       height: 150.h,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(30.r),
              //         border: Border.all(
              //           color: blueShades[1],
              //           width: 4.w,
              //         ),
              //       ),
              //       child: Stack(
              //         children: [
              //           _buildVideoOrScreenShare(teachers.first),
              //           Positioned(
              //             top: 15.h,
              //             right: 15.w,
              //             child: liveKitController.isRecording == true
              //                 ? Center(
              //                     child: SvgPicture.asset(
              //                       'assets/icons/rec_icon.svg',
              //                       fit: BoxFit.none,
              //                     ),
              //                   )
              //                 : const Center(),
              //           ),
              //           Positioned(
              //             bottom: 15.h,
              //             left: 15.w,
              //             child: Container(
              //               padding: EdgeInsets.symmetric(
              //                 horizontal: 15.w,
              //                 vertical: 7.h,
              //               ),
              //               height: 33.h,
              //               decoration: BoxDecoration(
              //                 color: redShades[3],
              //                 borderRadius: BorderRadius.circular(100.r),
              //               ),
              //               child: Text(
              //                 teachers.isNotEmpty
              //                     ? teachers.first.name
              //                     : "Teacher",
              //                 style: setTextTheme(
              //                   fontSize: 15.sp,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             bottom: 15.h,
              //             right: 15.w,
              //             child: Container(
              //               width: 35.w,
              //               height: 30.h,
              //               decoration: BoxDecoration(
              //                 color: redShades[3],
              //                 border: Border.all(color: Colors.grey),
              //                 borderRadius: BorderRadius.circular(
              //                   100.r,
              //                 ),
              //               ),
              //               child: Center(
              //                 child: Icon(
              //                   teachers.first.isMuted
              //                       ? Icons.mic_off_outlined
              //                       : Icons.keyboard_voice_outlined,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             top: 10.h,
              //             right: 15.w,
              //             child: CallButton(
              //               onTap: () {},
              //               svgIcon: 'assets/icons/options_icon.svg',
              //               boxColor: blueShades[14],
              //               svgColor: whiteShades[0],
              //               width: 35,
              //               height: 35,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
//               SizedBox(height: 10.h),
              // if (participants.isNotEmpty) ...[
              //   SizedBox(
              //     height: MediaQuery.of(context).size.height * 0.40,
              //     child: GridView.builder(
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: participants.length > 2 ? 2 : 1,
              //         crossAxisSpacing: 8,
              //         mainAxisSpacing: 1,
              //       ),
              //       itemCount: participants.length,
              //       itemBuilder: (context, index) {
              //         final participant = participants[index];
              //         return Container(
              //           width: 100.w,
              //           height: 60.h,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(25.r),
              //             // image: const DecorationImage(
              //             //   image: AssetImage('assets/app/student_image.png'),
              //             //   fit: BoxFit.cover,
              //             // ),
              //           ),
              //           child: Stack(
              //             children: [
              //               // participant.isCameraEnabled()
              //               //     ? _buildVideoOrScreenShare(participant)
              //               //     : const NoVideoWidget(),
              //               Positioned(
              //                 bottom: 10.h,
              //                 left: 10.w,
              //                 child: Container(
              //                   padding: EdgeInsets.symmetric(
              //                     horizontal: 15.w,
              //                     vertical: 3.h,
              //                   ),
              //                   height: 26.h,
              //                   decoration: BoxDecoration(
              //                     color: redShades[3],
              //                     borderRadius: BorderRadius.circular(100.r),
              //                   ),
              //                   child: Text(
              //                     participant.name,
              //                     style: setTextTheme(
              //                       fontSize: 16.sp,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Positioned(
              //                 // me box
              //                 bottom: 7.h,
              //                 right: 10.w,
              //                 child: Container(
              //                   width: 35.w,
              //                   height: 30.h,
              //                   decoration: BoxDecoration(
              //                     color: redShades[3],
              //                     borderRadius: BorderRadius.circular(100.r),
              //                   ),
              //                   child: Center(
              //                     child: Icon(
              //                       participant.isMuted
              //                           ? Icons.mic_off_outlined
              //                           : Icons.keyboard_voice_outlined,
              //                       color: Colors.black,
              //                     ),
              //                     // child: SvgPicture.asset(
              //                     //   participant.isMuted
              //                     //       ? "assets/icons/voice_record_icon_muted.svg"
              //                     //       : 'assets/icons/voice_record_icon.svg',
              //                     //   colorFilter: ColorFilter.mode(
              //                     //     blueShades[2],
              //                     //     BlendMode.srcIn,
              //                     //   ),
              //                     //   fit: BoxFit.none,
              //                     // ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ]
//             ],
//           ),
          // Container(
          //   padding: EdgeInsets.all(10.r),
          //   decoration: BoxDecoration(
          //     color: blueShades[15],
          //     borderRadius: BorderRadius.circular(20.r),
          //   ),
          //   child: Row(
          //     children: [
          //       ToggleColorCallButton(
          //         // voice call muted icon
          //         isPressed: liveKitController.isMicEnabled,
          //         onTap: () {
          //           // call to be muted logic
          //           liveKitController.toggleMic();
          //           setState(() {});
          //         },
          //         svgIcon: Icons.keyboard_voice_outlined,
          //         svgIcon1: Icons.mic_off_outlined,
          //         boxColor: blueShades[3],
          //         // svgColor: whiteShades[0],
          //       ),
          //       SizedBox(
          //         width: 10.w,
          //       ),
          //       ToggleColorCallButton(
          //         // toggle video icon
          //         isPressed: liveKitController.isCameraEnabled,
          //         onTap: () {
          //           // video to be paused logic
          //           liveKitController.toggleCamera();
          //           setState(() {});
          //         },
          //         svgIcon: Icons.videocam_outlined,
          //         svgIcon1: Icons.videocam_off_outlined,
          //         boxColor: blueShades[3],
          //       ),
          //       SizedBox(
          //         width: 10.w,
          //       ),
          //       CallButton(
          //         onTap: () {
          //           // show live chat screen but dont leave the screen
          //           log("CALLID FOR CHAT ${widget.callId}");
          //           showModalBottomSheet(
          //             isScrollControlled: true,
          //             context: context,
          //             isDismissible: true,
          //             useSafeArea: true,
          //             builder: (context) {
          //               return LiveClassChat(
          //                 callId: widget.callId,
          //               );
          //             },
          //           );
          //         },
          //         svgIcon: 'assets/icons/message_icon.svg',
          //         boxColor: blueShades[3],
          //       ),
          //       SizedBox(
          //         width: 10.w,
          //       ),
          //       if (userProvider.user?.type != "student") ...[
          //         CallButton(
          //           onTap: () {
          //             if (liveKitController.isScreenSharing) {
          //               liveKitController.stopScreenShare();
          //               return;
          //             }
          //             liveKitController.startScreenShare();
          //           },
          //           svgIcon: 'assets/icons/screen_share.svg',
          //           boxColor: blueShades[3],
          //         ),
          //         SizedBox(
          //           width: 10.w,
          //         ),
          //       ],
          //       const Spacer(),
          //       CallButton(
          //         // end call button
          //         onTap: () {
          //           liveKitController.disconnect();
          //           context.pushReplacement(
          //             StudentLandingScreen.routeName,
          //             extra: {
          //               "id": context.read<UserProvider>().user?.id ?? "",
          //               "provider": userProvider,
          //             },
          //           );
          //         },
          //         width: screenSize.width * 0.2,
          //         svgIcon: 'assets/icons/call_icon_flat.svg',
          //         svgColor: whiteShades[0],
          //         boxColor: redShades[1],
          //       ),
          //     ],
          //   ),
          // ),
//         ],
//       ),
//     );
//   }
// }
