const String examHomeWork = r"""
query GetStudentActiveExams($input: GetStudentExamsInput!, ){
  getStudentActiveExams(input: $input) {
    data {
      id
      name
      startDate
      endDate
      duration
      totalMark
      pin
      hasPin
      instruction
      enabled
      isOffline
      showScoreOnSubmission
      showCorrections
      scoreNotification
      strictMode
      showCalculator
      shuffleCBTQuestions
      subjectId
      examGroupId
      questionIds
      classIds
      examSessionIds
      ineligibleStudentIds
      createdById
      questionCount
      createdBy {
        id
       
        role
        # user {
        #   id
        #   firstName
        #   lastName
        #   username
        #   phoneNumber
        #   email
        #   profileImageUrl
        #   gender
        #   dateOfBirth
        #   country
        #   state
        #   city
        #   address
        #   type
        # }
        space {
          id
          name
          description
          alias
          logo
        }
      }
    
      subject {
        id
        name
        description
        spaceId
        teacherId
        teacher {
          id
          user {
            email
          firstName
          lastName
          profileImageUrl
          }
        }
      }
      totalTheoryMark
      examGroup {
        id
        name
        description
        category
        groupEnabled
        sessionId
        termId
        classIds
        examIds
        spaceId
        createdById
        createdAt
        updatedAt
        examCount
      }
    }
  }
}

""";

const String singleExamWork = r"""
query GetStudentActiveExam($input: GetStudentExamInput!,){
  getStudentActiveExam(input: $input) {
    id
    name
    startDate
    endDate
    duration
    totalMark
    totalTheoryMark
    pin
    hasPin
    instruction
    enabled
    isOffline
    showScoreOnSubmission
    showCorrections
    scoreNotification
    strictMode
    showCalculator
    shuffleCBTQuestions
    subject {
      id
      name
      description
      spaceId
      teacherId
      teacher {
        id
        user {
            email
        firstName
        lastName
        profileImageUrl
        }
      }
    }
    subjectId
    examGroup {
      id
      name
      description
      category
      groupEnabled
      sessionId
    
      classIds
      exams {
        id
        name
        startDate
        endDate
        duration
        totalMark
        totalTheoryMark
        pin
        hasPin
        instruction
        enabled
        isOffline
        showScoreOnSubmission
        showCorrections
        scoreNotification
        strictMode
        showCalculator
        shuffleCBTQuestions
      
        examGroupId
        
        questionIds
        
        classIds
       
        examSessionIds
        
        ineligibleStudentIds
       
        createdById
        questionCount
      }
      examIds
      spaceId
   
      createdById
     
      createdAt
      updatedAt
      examCount
      createdBy {
        id
  
        role
        user {
          id
          firstName
          lastName
          username
          phoneNumber
          email
          profileImageUrl
          gender
          dateOfBirth
          country
          state
          city
          address
          type
        }
        space {
          id
          name
          description
          alias
          logo
        }
      }
    }
    examGroupId

    questionIds
 
    classIds
  
    examSessionIds
 
    ineligibleStudentIds
 
    createdById
    questionCount
    questions {
      id
      question
      questionImage
      type
      explanation
      classGroupId
      subjectId
      lessonNoteId
      sessionId
      session
   
      questionTagId
      questionSectionId
      createdAt
      updatedAt
      examId
      mark
      options {
        label
        image
        correct
      }
    }
  }
}
 
""";

const String examSession =
    r""" mutation CreateExamSession($input: CreateExamSessionInput!) {
   createExamSession(input: $input) {
      id
      examId
      studentId
      exam {
        questions {
          lessonNote {
            id
            topic
          }
          questionSection {
            id
            instruction
            name
          }
          id
          question
          options {
            image
            label
          }
          questionImage
          explanation
          type
        }
        showCalculator
        showCorrections
        showScoreOnSubmission
        shuffleCBTQuestions
        startDate
        strictMode
        subject {
          id
          name
        }
        endDate
        duration
        instruction
        totalMark
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      answers {
        answer
        questionId
        resources
        
      }
      totalScore
    }
  }

""";

const String updateSessionQuery =
    r"""mutation UpdateExamSession($input: UpdateExamSessionInput!) {
  updateExamSession(input: $input) {
       id
      examId
      studentId
      exam {
        questions {
          lessonNote {
            id
            topic
          }
          questionSection {
            id
            instruction
            name
          }
          id
          question
          options {
            image
            label
          }
          questionImage
          explanation
          type
        }
        showCalculator
        showCorrections
        showScoreOnSubmission
        shuffleCBTQuestions
        startDate
        strictMode
        subject {
          id
          name
        }
        endDate
        duration
        instruction
        totalMark
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      answers {
        answer
        questionId
        resources
        score
      }
      totalScore
    }
  }
  
""";

const String getExamSessionsQuery = r"""
 query GetExamSessions($input: GetExamSessions!) {
  getExamSessions(input: $input) {
    data {
      id
      studentId
      student {
        id
        role
        lastName
        firstName
        middleName
        user {
          firstName
          lastName
          username
        }
      }
      examId
      exam {
        isOffline
        totalMark
        totalTheoryMark
        questionCount
        name
        duration
        id
        examGroup {
          id
        }
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      totalScore
      createdAt
      updatedAt
    }
    meta {
      hasMore
      nextCursor
      pageSize
    }
  }
}
""";

const String getExamsQuery = r""" query GetExams($input: GetExamsInput!) {
    getExams(input: $input) {
      data {
        id
        instruction
        subject {
          id
          name
        }
        examGroup {
          category
        }
        examSessionIds
        startDate
        endDate
        isOffline
        classes {
          subjectDetails {
            id
            name
            teacher {
              id
            }
          }
          classGroup {
            id
            name
          }
        }
        shuffleCBTQuestions
        showCalculator
        questionCount
        totalMark
        totalTheoryMark
        duration
        ineligibleStudentIds
        examSessions {
          id
          timeStarted
          totalScore
          timeLeft
          lastSavedAt
        }
        questions {
          id
        }
        pin
        enabled
        showScoreOnSubmission
        strictMode
        showCorrections
        scoreNotification
        name
        questionCount
      }
      meta {
        pageSize
        nextCursor
        hasMore
      }
    }
  }""";

String examGroupQuery = r"""query GetExamGroups($input: ExamGroupFilterInput!) {
  getExamGroups(input: $input) {
      data {
        category
        classes {
          id
          name
          subjectDetails {
            id
            name
            teacher {
              id
            }
          }
          classGroup {
            id
            name
          }
        }
        term {
          id
          name
        }
        session {
          id
          session
        }
        name
        id
        groupEnabled
        description
        sessionId
        termId
        updatedAt
        examIds
        examCount
      }
      meta {
        pageSize
        nextCursor
        hasMore
      }
    }
}""";

String examTeacherGroupQuery = r"""
query GetExamGroups($input: ExamGroupFilterInput!) {
  getExamGroups(input: $input) {
    data {
      id
      name
      session {
        id
        session
        alias
        spaceId
      }
      category
      classes {
        classGroupId
        classGroup {
          id
          name
        }
        description
        name
        subjectDetails {
          id
          description
          name
          spaceId
        }
      }
      sessionId
      termId
      term {
        id
        name
        alias
        spaceId
      }
      examIds
      groupEnabled
      examCount
    }
  }
}
""";
// String filterExamQuery = r"""
//  query GetExamNames($input: GetExamsInput!) {
//     getExams(input: $input) {
//       data {
//         id
//         name
//       }
//     }
//   }
// """;

String filterExamQuery = r"""
 query GetExamSessions($input: GetExamSessions!) {
    getExamSessions(input: $input) {
      data {
        id
        studentId
        student {
          id
      
          role
          user {
            firstName
            lastName
            username
          }
        }
        examId
        exam {
          isOffline
          totalMark
          totalTheoryMark
          questionCount
          name
          duration
          id
          examGroup {
            id
          }
        }
        timeStarted
        timeLeft
        expectedEndTime
        lastSavedAt
        status
        totalScore
        createdAt
        updatedAt
      }
      meta {
        hasMore
        nextCursor
        pageSize
      }
    }
  }
""";
const String markTheoryMutation =
    r""" mutation MarkTheoryExamSession($input: MarkTheoryExamSession!) {
    markTheoryExamSession(input: $input) {
      id
      studentId
      examId
      exam {
        id
        examGroupId
        questions {
          lessonNote {
            id
            topic
          }
          questionSection {
            id
            instruction
            name
          }
          id
          question
          options {
            correct
            image
            label
          }
          questionImage
          explanation
          type
          mark
        }
        showCalculator
        showCorrections
        showScoreOnSubmission
        startDate
        strictMode
        subject {
          id
          name
        }
        endDate
        duration
        instruction
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      answers {
        answer
        questionId
        resources
        score
      }
      totalScore
    }
  }""";

const String deleteExamMutation =
    r"""  mutation DeleteExamSession($input: DeleteExamSessionInput!) {
    deleteExamSession(input: $input) {
      id
    }
  }""";

const String studentCorrectionQuery =
    r"""query Corrections($input: GetStudentExamSession!) {
  getStudentExamSession(input: $input) {
    corrections {
      lessonNoteId
      topic
      questionId
      question
      chosenAnswer
      correctAnswer
      isCorrect
      score
    }
    examSession {
      id
      timeLeft
      timeStarted
      totalScore
      studentId
      student {
        id
        role
        user {
          firstName
          gender
          email
          lastName
          id
          profileImageUrl
          username
        }
      }
      examId
      exam {
        id
        examGroupId
        questions {
          lessonNote {
            id
            topic
          }
          questionSection {
            id
            instruction
            name
          }
          id
          question
          options {
            correct
            image
            label
          }
          questionImage
          explanation
          type
          mark
        }
        showCalculator
        showCorrections
        showScoreOnSubmission
        startDate
        strictMode
        subject {
          id
          name
        }
        endDate
        duration
        instruction
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      answers {
        answer
        questionId
        resources
        score
      }
      totalScore
    }
  }
}""";

String markeTheory = r"""
mutation MarkTheoryExam($input: MarkTheoryExamSession!){
  markTheoryExamSession(input: $input) {
      id
      timeLeft
      timeStarted
      totalScore
      studentId
      student {
        id
        role
        user {
          firstName
          gender
          email
          lastName
          id
          profileImageUrl
          username
        }
      }
      examId
      exam {
        id
        examGroupId
        questions {
          lessonNote {
            id
            topic
          }
          questionSection {
            id
            instruction
            name
          }
          id
          question
          options {
            correct
            image
            label
          }
          questionImage
          explanation
          type
          mark
        }
        showCalculator
        showCorrections
        showScoreOnSubmission
        startDate
        strictMode
        subject {
          id
          name
        }
        endDate
        duration
        instruction
      }
      timeStarted
      timeLeft
      expectedEndTime
      lastSavedAt
      status
      answers {
        answer
        questionId
        resources
      }
      totalScore
    }

  }

""";

// String getSubmissionQuery = r"""
// query GetStudentSubmissions($input: GetExamsInput!) {
//   getExams(input: $input) {
//     data {
//       examSessions {
//         id
//         timeStarted
//         timeLeft
//         expectedEndTime
//         lastSavedAt
//         totalScore
//       }
//       id
//       name
//       subject {
//         id
//         name
//       }
//       examGroup {
//         category
//       }
//       startDate
//       endDate
//       questionCount
//       totalMark
//       totalTheoryMark
//       duration
//       showCorrections
//       showScoreOnSubmission
//     }
//     meta {
//       pageSize
//       nextCursor
//       hasMore
//     }
//   }
// }
// """;
String getSubmissionQuery = r"""
query GetStudentSubmissions($input: GetExamsInput!) {
  getExams(input: $input) {
    data {
      examSessions {
        id
        timeStarted
        timeLeft
        expectedEndTime
        lastSavedAt
        totalScore
        studentId
      }
      id
      name
      subject {
        id
        name
      }
      examGroup {
        category
      }
      startDate
      endDate
      questionCount
      totalMark
      totalTheoryMark
      duration
      showCorrections
      showScoreOnSubmission
      examGroupId
      subjectId
    }
    meta {
      pageSize
      nextCursor
      hasMore
    }
  }
}
""";

String breakDownQuery = r"""query ExamLessonNoteBreakdown($input: GetStudentExamSession!) {
  getStudentExamSession(input: $input) {
    examLessonNoteBreakdown {
      lessonNoteId
      topic
      totalQuestionForTopic
      totalAnsweredForTopic
      percentageBreakdown
    }
    examSession {
      timeLeft
      timeStarted
      lastSavedAt
      totalScore
      expectedEndTime
      status
      exam {
        totalMark
      }
      student {
        id
        role
        lastName
        firstName
        middleName
        profilePicture
        class {
          id
          name
          classGroup {
            id
            name
          }
        }
        user {
          firstName
          gender
          email
          lastName
          id
          profileImageUrl
          username
        }
      }
    }
  }
}""";

String examSessionSummaryBreakdownQuery =r"""
query GetExamSessionsSummary($input: GetExamSessionsSummary!) {
  getExamSessionsSummary(input: $input) {
    examSessionBreakdown {
      averageDuration
      averageScore
      totalSessions
      highestSession {
        student {
          user {
            lastName
            firstName
            profileImageUrl
          }
          id
        }
        totalScore
        exam {
          examGroup {
            name
          }
        }
      }
      lowestSession {
         totalScore
        exam {
          examGroup {
            name
          }
        }
        student {
          id
           user {
            lastName
            firstName
            profileImageUrl
          }
          class {
            name
            classGroup {
              id
              name
            }
          }
        }
      }
    }
    examLessonNoteBreakdown {
      percentageBreakdown
      topic
      totalAnsweredForTopic
      totalQuestionForTopic
    }
  }
}
""";

String resetExamMutation = r"""  mutation ResetExamSession($input: UpdateExamSessionInput!) {
  resetExamSession(input: $input) {
    id
  }
}
  

""";