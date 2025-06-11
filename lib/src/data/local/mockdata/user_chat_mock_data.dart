import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';

final List<UserChatModel> dummyChatDisplay = [
  UserChatModel(
      title: 'Compass international school',
      image: 'assets/app/profile_image.png',
      text: 'Oh i know how to solve the problem and ..',
      dateTime: DateTime.now().subtract(Duration(minutes: 15)),
      notificationCount: 2,
      isVerified: true,
      isOnline: true,
      isGroupChat: false),
  UserChatModel(
      title: 'JSS 1 Group Chat',
      image: 'assets/app/profile_image.png',
      text: 'Oh i know how to solve the problem and ..',
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      notificationCount: 0,
      isVerified: false,
      isOnline: false,
      isGroupChat: true),
  UserChatModel(
      title: 'Nmesoma Anomehi',
      image: 'assets/app/profile_image.png',
      text: 'Oh i know how to solve the problem and ..',
      dateTime: DateTime.now().subtract(Duration(hours: 6)),
      notificationCount: 2,
      isVerified: false,
      isOnline: false,
      isGroupChat: false),
  UserChatModel(
      title: 'Tengeh Mary',
      image: 'assets/app/profile_image.png',
      text: 'Oh i know how to solve the problem and ..',
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      notificationCount: 2,
      isVerified: true,
      isOnline: true,
      isGroupChat: false),
];

final aiChatDisplay = UserChatModel(
    title: 'cloudnottapp2 AI',
    image: 'assets/app/cloudnottapp2_logo_two.png',
    text: 'Ask me anything',
    dateTime: DateTime.now().subtract(Duration(minutes: 15)),
    notificationCount: 2,
    isVerified: true,
    isOnline: true,
    isGroupChat: false);
