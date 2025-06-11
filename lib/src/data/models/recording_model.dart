class CreateRecordingInput {
  final String lessonNoteId;
  final String recordUrl;
  final String timeRecorded;
  final String timetableId;

  CreateRecordingInput({
    required this.lessonNoteId,
    required this.recordUrl,
    required this.timeRecorded,
    required this.timetableId,
  });

  Map<String, dynamic> toJson() {
    return {
      "lessonNoteId": lessonNoteId,
      "recordUrl": recordUrl,
      "timeRecorded": timeRecorded,
      "timetableId": timetableId,
    };
  }
}
