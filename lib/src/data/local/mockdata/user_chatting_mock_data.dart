import 'package:cloudnottapp2/src/data/models/user_chatting_model.dart';

final List<UserChattingModel> dummyChatting = [
  UserChattingModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    dateTime: DateTime.now().subtract(
      Duration(minutes: 15),
    ),
    isUserMessage: true,
  ),
  UserChattingModel(
    text: 'You calculate the earth orbit by 2',
    dateTime: DateTime.now().subtract(
      Duration(hours: 6),
    ),
    isUserMessage: false,
  ),
  UserChattingModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    dateTime: DateTime.now().subtract(
      Duration(minutes: 30),
    ),
    isUserMessage: true,
  ),
  UserChattingModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    dateTime: DateTime.now().subtract(
      Duration(minutes: 40),
    ),
    isUserMessage: true,
  ),
  UserChattingModel(
    text: 'You calculate the earth orbit by 2',
    dateTime: DateTime.now().subtract(
      Duration(minutes: 43),
    ),
    isUserMessage: false,
  ),
  UserChattingModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    dateTime: DateTime.now().subtract(
      Duration(minutes: 43),
    ),
    isUserMessage: true,
  )
];
