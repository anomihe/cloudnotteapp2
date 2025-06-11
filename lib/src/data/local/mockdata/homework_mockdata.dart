import 'package:cloudnottapp2/src/data/models/homework_model.dart';

//the first option in the answer list is the correct one

final List<HomeworkModel> englishHomework = [
  HomeworkModel(
    subject: 'English Language',
    task: 'Answer the following questions on English.',
    date: DateTime.now(),
    duration: Duration(minutes: 2),
    questions: [
      HomeworkQuestion(
        question: 'Which word is a noun?',
        answer: ['Book', 'Run', 'Quickly', 'Beautiful'],
        questionNumber: 1,
        type: QuestionType.objective,
        explanation: 'A noun is a name of a person, place, or thing.',
      ),
      HomeworkQuestion(
        question: 'Which is a synonym for "happy"?',
        answer: ['Joyful', 'Angry', 'Sad', 'Worried'],
        questionNumber: 2,
        type: QuestionType.objective,
        explanation: 'A synonym for "happy" is "joyful".',
      ),
      HomeworkQuestion(
        question: 'What is the plural of "child"?',
        answer: ['Children', 'Childs', 'Childes', 'Child'],
        questionNumber: 3,
        type: QuestionType.objective,
        explanation: 'The correct plural of "child" is "children".',
      ),
      HomeworkQuestion(
        question: 'What is an antonym of "dark"?',
        answer: ['Bright', 'Dim', 'Shadow', 'Dusk'],
        questionNumber: 4,
        type: QuestionType.objective,
        explanation: 'An antonym of "dark" is "bright".',
      ),
      HomeworkQuestion(
        question: 'Which sentence is correct?',
        answer: [
          'She is singing',
          'She sings lovely',
          'She singing',
          'She are singing'
        ],
        questionNumber: 5,
        type: QuestionType.objective,
        explanation: 'The correct sentence is "She is singing".',
      ),
      HomeworkQuestion(
        question: 'What type of word is "quickly"?',
        answer: ['Adverb', 'Noun', 'Verb', 'Adjective'],
        questionNumber: 6,
        type: QuestionType.objective,
        explanation: '"Quickly" is an adverb describing how an action is done.',
      ),
      HomeworkQuestion(
        question: 'What is the past tense of "run"?',
        answer: ['Ran', 'Running', 'Run', 'Runned'],
        questionNumber: 7,
        type: QuestionType.objective,
        explanation: 'The past tense of "run" is "ran".',
      ),
      HomeworkQuestion(
        question: 'Which sentence uses "their" correctly?',
        answer: [
          'Their house is big.',
          'They’re going to the park.',
          'There is a cat.',
          'Their is the best option.'
        ],
        questionNumber: 8,
        type: QuestionType.objective,
        explanation: '"Their" shows possession, as in "Their house is big."',
      ),
      HomeworkQuestion(
        question: 'What does the prefix "un-" mean in "unhappy"?',
        answer: ['Not', 'Very', 'Again', 'Too'],
        questionNumber: 9,
        type: QuestionType.objective,
        explanation: 'The prefix "un-" means "not".',
      ),
      HomeworkQuestion(
        question: 'What is the comparative form of "good"?',
        answer: ['Better', 'Gooder', 'Best', 'More good'],
        type: QuestionType.objective,
        questionNumber: 10,
        explanation: 'The comparative form of "good" is "better".',
      ),
      HomeworkQuestion(
        question: 'Which of these is an interrogative sentence?',
        type: QuestionType.objective,
        answer: [
          'What time is it?',
          'She is walking.',
          'I like ice cream.',
          'The sky is blue.'
        ],
        questionNumber: 11,
        explanation: 'An interrogative sentence asks a question.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'What is a collective noun for "fish"?',
        answer: ['School', 'Pack', 'Flock', 'Group'],
        questionNumber: 12,
        explanation: 'A collective noun for "fish" is "school".',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Choose the correct possessive form: "This is ___ book."',
        answer: ['my', 'me', 'mine', 'I'],
        questionNumber: 13,
        explanation: 'The possessive form is "my".',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question:
            'What part of speech is "beautiful" in this sentence: "She is beautiful"?',
        answer: ['Adjective', 'Noun', 'Adverb', 'Verb'],
        questionNumber: 14,
        explanation: '"Beautiful" is an adjective describing "she".',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Which of the following is a compound word?',
        answer: ['Sunshine', 'Fast', 'Hope', 'Running'],
        questionNumber: 15,
        explanation: '"Sunshine" is a compound word.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'What is the superlative form of "happy"?',
        answer: ['Happiest', 'More happy', 'Happyest', 'Most happy'],
        questionNumber: 16,
        explanation: 'The superlative form of "happy" is "happiest".',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Which sentence is in the future tense?',
        answer: [
          'She will travel tomorrow.',
          'She travels every week.',
          'She traveled yesterday.',
          'She is traveling now.'
        ],
        questionNumber: 17,
        explanation: '"She will travel tomorrow" is in the future tense.',
      ),
      HomeworkQuestion(
        type: QuestionType.theory,
        question:
            'Choose the correct article: "I saw ___ elephant at the zoo."',
        answer: ['An'],
        questionNumber: 18,
        explanation:
            'The correct article is "an" because "elephant" starts with a vowel sound.',
      ),
      HomeworkQuestion(
        type: QuestionType.theory,
        question: 'What is the function of a conjunction?',
        answer: ['A conjunction joins words or clauses'],
        questionNumber: 19,
        explanation: 'A conjunction joins words or clauses.',
      ),
      HomeworkQuestion(
        type: QuestionType.theory,
        question: 'Identify the correct homophone: "I want to ___ a new book."',
        answer: ['buy'],
        questionNumber: 20,
        explanation: 'The correct homophone is "buy".',
      ),
    ],
    groupName: 'Homework group',
    mark: 50,
  ),
];

final List<HomeworkModel> biologyHomework = [
  HomeworkModel(
    subject: 'Biology',
    task: 'Answer the following questions on Biology.',
    date: DateTime.now(),
    duration: Duration(minutes: 30),
    questions: [
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'What is the powerhouse of the cell?',
        questionImage: 'assets/app/teacher_image.png',
        optionImages: [
          'assets/app/teacher_image.png',
          'assets/app/student_image.png',
          'assets/app/mock_person_image.jpg',
          'assets/app/cloudnottapp2_logo_one.png',
        ],
        answer: ['Mitochondria', 'Ribosome', 'Nucleus', 'Chloroplast'],
        questionNumber: 1,
        explanation:
            'The mitochondria are known as the powerhouse of the cell because they produce energy.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Which organ pumps blood?',
        questionImage: 'assets/app/image 3.png',
        optionImages: [
          'assets/app/teacher_image.png',
          'assets/app/student_image.png',
          'assets/app/mock_person_image.jpg',
          'assets/app/cloudnottapp2_logo_one.png',
        ],
        answer: ['Heart', 'Lungs', 'Kidneys', 'Liver'],
        questionNumber: 2,
        explanation:
            'The heart is responsible for pumping blood throughout the body.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'What is the largest bone?',
        questionImage: 'assets/app/question_image.png',
        optionImages: [
          'assets/app/teacher_image.png',
          'assets/app/student_image.png',
          'assets/app/mock_person_image.jpg',
          'assets/app/cloudnottapp2_logo_one.png',
        ],
        answer: ['Femur', 'Tibia', 'Fibula', 'Humerus'],
        questionNumber: 3,
        explanation:
            'The femur, or thigh bone, is the largest bone in the human body.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Which is the smallest bone?',
        answer: ['Stapes', 'Femur', 'Tibia', 'Ulna'],
        questionNumber: 4,
        explanation:
            'The stapes, located in the ear, is the smallest bone in the human body.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'What carries oxygen?',
        answer: ['Red cells', 'White cells', 'Platelets', 'Plasma'],
        questionNumber: 5,
        explanation:
            'Red blood cells carry oxygen using a protein called hemoglobin.',
      ),
      HomeworkQuestion(
        type: QuestionType.theory,
        question:
            "Write a 5000-word article about the effect of Amoeba on Noah's girlfriend Stella.",
        answer: ['Peaceful'],
        questionNumber: 6,
        explanation:
            'This is a hypothetical question intended to encourage creative writing.',
      ),
      HomeworkQuestion(
        type: QuestionType.objective,
        question: 'Which of these is a living organism?',
        answer: [
          'Felix',
          'Buscuit',
          'Gbott Anamatopia Bonjalize hdkdkd jdkkdjdjjd ijsnsjdjdhdh',
          'Plasma'
        ],
        questionNumber: 7,
        explanation:
            'Felix is the only option that represents a living organism.',
      ),
    ],
    groupName: '2nd Homework',
    mark: 10,
  ),
];

final List<HomeworkModel> dummyHomework = [
  ...englishHomework,
  ...biologyHomework,
];
