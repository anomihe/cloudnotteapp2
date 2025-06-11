// This model handle the question and answer section

class QuestionModel {
  const QuestionModel(
    this.question,
    this.options,
  );
  final String question;
  final List<String> options;

  List<String> getShuffledOption() {
    final shuffledList = List.of(options);
    shuffledList.shuffle();
    return shuffledList;
  }
}
