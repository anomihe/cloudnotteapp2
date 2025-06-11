class GraphQLQueries {
  // Mutation to submit a URL
  static const String submitURL = r'''
    mutation SubmitURL($input: SubmitURLInput!) {
      submitURL(input: $input) {
        id
        url
        status
        fileType
        username
        createdAt
        updatedAt
        title
      }
    }
  ''';

  // Mutation to submit text
  static const String submitText = r'''
    mutation SubmitText($text: String!, $username: String!) {
      submitText(text: $text, username: $username) {
        id
        url
        status
        fileType
        createdAt
        updatedAt
        title
        username
      }
    }
  ''';

  // Mutation to delete a session
  static const String deleteSession = r'''
    mutation DeleteSession($id: ID!, $username: String!) {
      deleteSession(id: $id, username: $username)
    }
  ''';

  // Query to add or update a note for a session (as per backend's insistence)
  static const String addNoteToSession = r'''
    query AddNoteToSession($sessionId: ID!, $note: String!) {
      addNoteToSession(sessionId: $sessionId, note: $note) {
        id
        content
        createdAt
        updatedAt
      }
    }
  ''';

  // Query to get a single session with all tab data
  static const String getSession = r'''
    query GetSession($id: ID!) {
      getSession(id: $id) {
        id
        url
        status
        fileType
        createdAt
        updatedAt
        title
        username
        processedData {
          id
          extractedText
        }
        chats {
          id
          question
          content
          createdAt
        }
        note {
          id
          content
          createdAt
          updatedAt
        }
        transcript {
          startTime
          pageNumber
          content
        }
        chapters {
          title
          summary
          startTime
          pageNumber
        }
        summary {
          content
        }
        questions {
          content
          hint
        }
        quiz {
          id
          questions {
            id
            content
            options {
              id
              content
              isCorrect
            }
            hint
            explanation
          }
          createdAt
        }
      }
    }
  ''';

  // Query to get all user sessions (basic data)
  static const String getSessions = r'''
    query GetSessions($username: String!) {
      getSessions(username: $username) {
        id
        url
        status
        fileType
        createdAt
        updatedAt
        title
        username
        chats {
          id
          question
          content
          createdAt
        }
      }
    }
  ''';

  // Query to get explore topics (basic data)
  static const String getExploreTopics = r'''
    query GetExploreTopics {
      getExploreTopics {
        id
        url
        status
        fileType
        createdAt
        updatedAt
        title
        chats {
          id
          question
          content
          createdAt
        }
      }
    }
  ''';

  // Query to chat with a session
  static const String chat = r'''
    query Chat($sessionId: ID!, $question: String!) {
      chat(sessionId: $sessionId, question: $question) {
        id
        question
        content
        createdAt
      }
    }
  ''';

  // Mutation to regenerate chapters
  static const String regenerateChapters = r'''
    mutation RegenerateChapters($sessionId: ID!) {
      regenerateChapters(sessionId: $sessionId) {
        title
        summary
        startTime
        pageNumber
      }
    }
  ''';

  // Mutation to regenerate summary
  static const String regenerateSummary = r'''
    mutation RegenerateSummary($sessionId: ID!) {
      regenerateSummary(sessionId: $sessionId) {
        content
      }
    }
  ''';

  // Mutation to regenerate questions
  static const String regenerateQuestions = r'''
    mutation RegenerateQuestions($sessionId: ID!) {
      regenerateQuestions(sessionId: $sessionId) {
        content
        hint
      }
    }
  ''';

  // Mutation to regenerate quiz
  static const String regenerateQuiz = r'''
    mutation RegenerateQuiz($sessionId: String!) {
      regenerateQuiz(sessionId: $sessionId) {
        id
        questions {
          id
          content
          options {
            id
            content
            isCorrect
          }
          hint
          explanation
        }
        createdAt
      }
    }
  ''';
}
