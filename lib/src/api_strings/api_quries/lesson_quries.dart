// String teacherLessonQuery =
//     r"""query GetLessonNote($input: GetLessonNotes!, $spaceId: ID!) {
//   getLessonNotes(input: $input, spaceId: $spaceId) {
//     id
//     week
//     date
//     topic
//     ageGroup
//     topicCover
//     status
//     updatedAt
//     duration
//     createdAt
//   }
// }""";
String teacherLessonQuery =
    r"""query GetLessonNote($input: GetLessonNotes!, $spaceId: ID!) {
  getLessonNotes(input: $input, spaceId: $spaceId) {
    id
    week
    date
    topic
    ageGroup
    topicCover
    status
    updatedAt
    duration
    createdAt
    classGroup {
      classes {
        subjectDetails {
          teacher {
           
            lastName
            id
            firstName
            
            user {
            profileImageUrl
            lastName
            id
            firstName
            email
              address
              city
              type
              username
              country
              defaultSpace
            }
          }
          id
        }
      }
      id
    }
  }
}""";

String getClassGroupQueries =
    r"""query GetClassGroups($spaceId: ID!, $includeSubjectDetails: Boolean!, $includeFormTeacher: Boolean!, $includeClassFields: Boolean!, $includeClasses: Boolean!, $includeTeacherFields: Boolean!) {
  getClassGroups(spaceId: $spaceId) {
    id
    name
    description
    spaceId
    classes @include(if: $includeClasses) {
      name
      id
      studentCount @include(if: $includeClassFields)
      subjectCount @include(if: $includeClassFields)
      formTeacher @include(if: $includeFormTeacher) {
        id
        firstName @include(if: $includeTeacherFields)
        lastName @include(if: $includeTeacherFields)
        middleName @include(if: $includeTeacherFields)
        profilePicture @include(if: $includeTeacherFields)
        user {
          id
          firstName @include(if: $includeTeacherFields)
          lastName @include(if: $includeTeacherFields)
          username @include(if: $includeTeacherFields)
          phoneNumber @include(if: $includeTeacherFields)
          email @include(if: $includeTeacherFields)
          profileImageUrl @include(if: $includeTeacherFields)
          gender @include(if: $includeTeacherFields)
        }
      }
      subjectDetails @include(if: $includeSubjectDetails) {
        id
        name
        teacher {
          id
          firstName @include(if: $includeTeacherFields)
          lastName @include(if: $includeTeacherFields)
          middleName @include(if: $includeTeacherFields)
          profilePicture @include(if: $includeTeacherFields)
          user {
            id
            firstName @include(if: $includeTeacherFields)
            lastName @include(if: $includeTeacherFields)
            username @include(if: $includeTeacherFields)
            phoneNumber @include(if: $includeTeacherFields)
            email @include(if: $includeTeacherFields)
            profileImageUrl @include(if: $includeTeacherFields)
            gender @include(if: $includeTeacherFields)
          }
        }
      }
    }
  }
}""";

String createLessonNoteMutation = r"""
mutation CreateLessonNote($input: CreateLessonNote!) {
  createLessonNote(input: $input)
}
""";

String updateLessonNoteMainMutation =
    r""" mutation UpdateLessonNote($input: UpdateLessonNote!, $spaceId: ID!){
  updateLessonNote(input: $input, spaceId: $spaceId)
}""";

String getLessonQuery =
    r"""query GetLessonNote($lessonNoteId: ID!, $spaceId: ID!) {
  getLessonNote(lessonNoteId: $lessonNoteId, spaceId: $spaceId) {
    id
    topic
    topicCover
    week
    date
    duration
    ageGroup
    status
    classGroupId
    classGroup {
      name
      id
      classes {
        id
        name
      }
    }
    subjectId
    subject {
      id
      name
    }
    termId
    term {
      id
      name
    }
    classNote {
      id
      noteId
      content
      createdAt
      updatedAt
    }
    lessonNotePlan {
      lessonNotePlan
    }
    createdAt
    updatedAt
  }
}""";

String createClassNoteMutation =
    r""" mutation CreateClassNote($input: LessonNoteContentInput!, $spaceId: ID!) {
  createClassNote(input: $input, spaceId: $spaceId)
}""";
String updateClassNoteMutation =
    r""" mutation UpdateClassNote($input: UpdateLessonNoteContentInput!, $spaceId: ID!) {
  updateClassNote(input: $input, spaceId: $spaceId)
}""";

String createLessonPlanMutation = r"""
mutation CreateLessonNotePlan($input: CreateLessonNotePlan!, $spaceId: ID!) {
  createLessonNotePlan(input: $input, spaceId: $spaceId) {
    id
    lessonNoteId
    lessonNotePlan
    createdAt
    updatedAt
  }
}
""";

String updateLessonPlanMutation =
    r"""mutation UpdateLessonNotePlan($input: UpdateLessonNotePlan!, $spaceId: ID!) {
  updateLessonNotePlan(input: $input, spaceId: $spaceId) {
    id
    lessonNoteId
    lessonNotePlan
    createdAt
    updatedAt
  }
}""";

String getLessonNotePlanQuery =
    r"""query GetLessonNotePlan($lessonNoteId: ID!, $spaceId: ID!) {
  getLessonNote(lessonNoteId: $lessonNoteId, spaceId: $spaceId) {
    lessonNotePlan {
      id
      lessonNoteId
      lessonNotePlan
      createdAt
      updatedAt
    }
  }
}""";
