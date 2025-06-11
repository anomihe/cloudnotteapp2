// String assessmentQuery = r"""
// query GetAssessments($input: AssessmentQuery!) {
//     getAssessments(input: $input) {
//       assessmentId
//       name
//       terms {
//         termId
//         name
//         alias
//       }
//       components {
//         percentage
//         subAssessment {
//           name
//           subAssessmentId
//         }
//       }
//       classes {
//         id
//         name
//       }
//       type
//     }
//   }
// """;
String assessmentQuery = r"""  query GetAssessments($input: AssessmentQuery!) {
    getAssessments(input: $input) {
      ... on BasicAssessment {
        assessmentId
        name
        terms {
          termId
          name
          alias
        }
        classes {
          id
          name
        }
        config {
          showCognitiveKeys
          showPrincipalComment
          showFormTeacherComment
          showSubjectTeachers
          showResumptionDate
          showAttendance
          showClassPosition
          showSubjectPosition
          showFormTeacherSignature
          showClassStudentsCount
          showSubjectTeachersName
          showClassTeachersCount
        }
        type
        components {
          percentage
          subAssessment {
            name
            subAssessmentId
          }
        }
      }
      ... on EarlyGradeAssessment {
        assessmentId
        name
        terms {
          termId
          name
          alias
        }
        classes {
          id
          name
        }
        config {
          showCognitiveKeys
          showPrincipalComment
          showFormTeacherComment
          showResumptionDate
          showAttendance
          showSubjectTeachersName
        }
        type
      }
    }
  }""";

String getManySubjectReport = r"""
query GetManySubjectReport($spaceId: ID!, $input: ManySubjectReportInput!) {
  getManySubjectReport(spaceId: $spaceId, input: $input) {
    scores {
      subAssessmentId
      score
      percentage
    }
    userId
    firstName
    lastName
    username
    profileImageUrl
    total
    subject {
      id
      name
      teacher {
        id
        firstName
        lastName
      }
    }
  }
}
""";

String enterScoreMutation = r"""
mutation UpdateManySubjectReport($spaceId: ID!, $input: UpdateManySubjectReportInput!) {
  updateManySubjectReport(spaceId: $spaceId, input: $input)
}

""";

//:TODO add into the model bool for enablejoinspace and enablescoreentry
String getSpaceQuery = r"""
query GetSpace($alias: String!, $isAdmin: Boolean!) {
  getSpace(alias: $alias) {
    id
    name
    description
    phoneNumber
    email
    logo
    categories
    curriculums
    type
    currency
    createdAt
    isPaid
    currentSpaceSessionId
    currentSpaceTermId
    locationInfo {
      country
      state
      city
      address
      longitude
      latitude
    }
    createdBy @include(if: $isAdmin) {
      firstName
      lastName
      id
    }
    alias
    classCount @include(if: $isAdmin)
    studentCount @include(if: $isAdmin)
    subjectCount @include(if: $isAdmin)
    teacherCount @include(if: $isAdmin)
    femaleTeacherPercentage @include(if: $isAdmin)
    femaleTeacherCount @include(if: $isAdmin)
    femaleStudentPercentage @include(if: $isAdmin)
    femaleStudentCount @include(if: $isAdmin)
    maleStudentCount @include(if: $isAdmin)
    maleStudentPercentage @include(if: $isAdmin)
    maleTeacherCount @include(if: $isAdmin)
    maleTeacherPercentage @include(if: $isAdmin)
    totalNumberSpaceParents @include(if: $isAdmin)
    spaceSessions {
      alias
      id
      session
    }
    currentSpaceSession {
      alias
      id
      session
    }
    currentSpaceTerm {
      alias
      id
      name
    }
    spaceTerms {
      alias
      id
      name
    }
    reportSheetType
    socials {
      name
      url
    }
    websiteUrl
    schoolFeesMax
    isBoarding
    facilities
    languages
    contactPersonCount
    foundingYear
    colour
    genders
    stamp
    accountingPinIsSet
    reportSheetType
    enableJoinSpace
    enableScoreEntry
  }
}

""";

String getStudentQuery = r"""
query GetStudents($classId: ID!, $spaceId: ID!, $pagination: CursorPagination!) {
  getClass(classId: $classId, spaceId: $spaceId) {
    students(pagination: $pagination) {
      id
      firstName
      lastName
      middleName
      parents {
        id
      }
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
        isEmailVerified
        createdAt
        updatedAt
      }
      role
      createdAt
      updatedAt
    }
    studentCount
  }
}

""";

String getResultQuery = r"""
 query GetResult($input: GetResultInput!) {
    getResult(input: $input) {
      ... on BasicResult {
        resultId
        class {
          id
          name
          classGroup {
            id
            name
          }
          studentCount
        }
        totalScore
        bestSubject {
          id
          name
        }
        leastSubject {
          id
          name
        }
        averageScore
        formTeacherComment
        principalComment
        position
        positionOutOf
        subjectGrades
        subjects {
          id
          name
        }
        overallGrading
        subjectsPosition
        session {
          session
          sessionId
        }
        term {
          termId
          name
        }
        spaceId
        userId
        metadata
        cognitiveKeyRatings {
          cognitiveKey {
            cognitiveKeyId
            domain
            name
          }
          rating
        }
        student {
          memberId
          firstName
          lastName
          middleName
          profilePicture
          user {
            id
            firstName
            lastName
            username
            profileImageUrl
          }
        }
        scores {
          subject {
            id
            name
          }
          subjectScores {
            score
            subAssessment {
              name
              subAssessmentId
            }
          }
        }
        publishedAt
        withheldAt
        withholdReason
        type # basic | early_grade
      }
      ... on EarlyGradeResult {
        resultId
        assessmentId
        class {
          id
          name
          classGroup {
            id
            name
          }
          studentCount
        }
        formTeacherComment
        principalComment
        subjects {
          id
          name
        }
        session {
          session
          sessionId
        }
        term {
          termId
          name
        }
        userId
        metadata
        student {
          memberId
          firstName
          lastName
          middleName
          profilePicture
          user {
            id
            firstName
            lastName
            username
            profileImageUrl
          }
        }
        cognitiveKeyRatings {
          cognitiveKey {
            cognitiveKeyId
            domain
            name
          }
          rating
        }
        publishedAt
        withheldAt
        withholdReason
        type # basic | early_grade
        keysToRating {
          id
          name
          remark
          classes {
            id
            name
          }
        }
        ratings {
          subject {
            id
            name
          }
          ratingKey {
            id
            name
            remark
          }
          subAssessment {
            name
            subAssessmentId
          }
        }
      }
    }
  }

""";

String publishResultQuery = r"""

mutation PublishResults($spaceId: ID!, $input: PublishResultsInput!) {
  publishResults(spaceId: $spaceId, input: $input)
}
""";

String setResumptionDateMutation = r"""
mutation UpdateSpaceTermDate($input: SpaceTermDateInput!, $spaceId: ID!) {
  updateSpaceTermDate(input: $input, spaceId: $spaceId)
}
""";

String getClassBroadSheetQuery = r"""
query ClassBroadsheet($spaceId: ID!, $input: GetClassBroadsheet!) {
    getClassBroadsheet(spaceId: $spaceId, input: $input) {
      results {
        ... on BasicResult {
          resultId
          class {
            id
            name
            classGroup {
              id
              name
            }
            studentCount
          }
          totalScore
          bestSubject {
            id
            name
          }
          leastSubject {
            id
            name
          }
          averageScore
          formTeacherComment
          principalComment
          position
          positionOutOf
          subjectGrades
          subjects {
            id
            name
          }
          overallGrading
          subjectsPosition
          session {
            session
            sessionId
          }
          term {
            termId
            name
          }
          spaceId
          userId
          metadata
          cognitiveKeyRatings {
            cognitiveKey {
              cognitiveKeyId
              domain
              name
            }
            rating
          }
          student {
            memberId
            firstName
            lastName
            middleName
            profilePicture
            user {
              id
              firstName
              lastName
              username
              profileImageUrl
            }
          }
          scores {
            subject {
              id
              name
            }
            subjectScores {
              score
              subAssessment {
                name
                subAssessmentId
              }
            }
          }
          publishedAt
          withheldAt
          withholdReason
          type # basic | early_grade
        }
        ... on EarlyGradeResult {
          resultId
          assessmentId
          class {
            id
            name
            classGroup {
              id
              name
            }
            studentCount
          }
          formTeacherComment
          principalComment
          subjects {
            id
            name
          }
          session {
            session
            sessionId
          }
          term {
            termId
            name
          }
          userId
          metadata
          student {
            memberId
            firstName
            lastName
            middleName
            profilePicture
            user {
              id
              firstName
              lastName
              username
              profileImageUrl
            }
          }
          cognitiveKeyRatings {
            cognitiveKey {
              cognitiveKeyId
              domain
              name
            }
            rating
          }
          publishedAt
          withheldAt
          withholdReason
          type # basic | early_grade
          keysToRating {
            id
            name
            remark
            classes {
              id
              name
            }
          }
          ratings {
            subject {
              id
              name
            }
            ratingKey {
              id
              name
              remark
            }
            subAssessment {
              name
              subAssessmentId
            }
          }
        }
      }
      class {
        id
        name
        studentCount
        classGroup {
          id
          name
        }
      }
      session {
        session
        alias
      }
      term {
        name
        termId
      }
    }
  }
""";

String getNumberOfDaysOpen = r"""
query GetSpaceTermDate($spaceId: ID!, $sessionId: ID!, $termId: ID!) {
  getSpaceTermDate(spaceId: $spaceId, sessionId: $sessionId, termId: $termId) {
    daysOpen
    nextTermBeginsOn
    currentTermClosesOn
    boardingResumesOn
  }
}
""";

String updateAttendanceMatatdataMutatation = r"""
mutation UpdateResultsMetadata($spaceId: ID!, $input: [UpdateResultMetadata!]!) {
  updateResultsMetadata(spaceId: $spaceId, input:$input)
}
""";

String classFormQuery = r"""
query GetClass($classId: ID!, $spaceId: ID!) {
  getClass(classId: $classId, spaceId: $spaceId) {
    formTeacher {
      id
      firstName
      lastName
 
      createdAt
      updatedAt
      user {
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
      isEmailVerified
      defaultSpace
      passwordExist
        firstName
        lastName
      }
      status
      staffType
      staffStatus
      staffNumber
      spaceWallet {
        id
        createdAt
        balance
      }
      retirementDate
      role
      salaryGradeLevel
      schoolHouse
      middleName
      archivedAt
      archived
      admissionNumber
      class {
        studentCount
        spaceId
        name
      }
      additionalRole
    }
    name
    spaceId
    studentCount
  }
}
""";

String addFormTeacherMutation = r"""
mutation AddResultFormTeacherComment($spaceId: ID!, $resultId: ID!, $comment: comment_String_NotNull_minLength_3!) {
  addResultFormTeacherComment(spaceId: $spaceId, resultId: $resultId, comment: $comment)
}
""";

String addPrincipalMutation =
    r"""mutation AddResultPrincipalComment($spaceId: ID!, $resultId: ID!, $comment: comment_String_NotNull_minLength_3!) {
  addResultPrincipalComment(spaceId: $spaceId, resultId: $resultId, comment: $comment)
}""";

// String updateCognitiveDomainMutation = r"""
// mutation UpdateCognitiveKey($input: UpdateCognitiveKeyInput!) {
//   updateCognitiveKey(input: $input)
// }
// """;
String updateCognitiveDomainMutation = r"""
mutation RateCognitiveKeys($input: RateCognitiveKeys!) {
  rateCognitiveKeys(input: $input)
}
""";

String getSchoolStartQuery = r"""
query GetSpaceTermDate($spaceId: ID!, $sessionId: ID!, $termId: ID!) {
  getSpaceTermDate(spaceId: $spaceId, sessionId: $sessionId, termId: $termId) {
    boardingResumesOn
    daysOpen
    nextTermBeginsOn
    currentTermClosesOn
  }
}""";

String basicAssesmentQuery = r"""
 query GetAssessment($spaceId: ID!, $assessmentId: ID!) {
    getAssessment(spaceId: $spaceId, assessmentId: $assessmentId) {
      ... on BasicAssessment {
        assessmentId
        name
        terms {
          termId
          name
          alias
        }
        classes {
          id
          name
        }
        config {
          showCognitiveKeys
          showPrincipalComment
          showFormTeacherComment
          showSubjectTeachers
          showResumptionDate
          showAttendance
          showClassPosition
          showSubjectPosition
          showFormTeacherSignature
          showClassStudentsCount
          showSubjectTeachersName
          showClassTeachersCount
        }
        type
        components {
          percentage
          subAssessment {
            name
            subAssessmentId
          }
        }
        createdAt
        updatedAt
      }
      ... on EarlyGradeAssessment {
        assessmentId
        name
        terms {
          termId
          name
          alias
        }
        classes {
          id
          name
        }
        config {
          showCognitiveKeys
          showPrincipalComment
          showFormTeacherComment
          showResumptionDate
          showAttendance
          showSubjectTeachersName
        }
        createdAt
        updatedAt
        type
      }
    }
  }
""";

String gradingSystemQuery = r"""
query GetGradingSystems($spaceId: String!, $assessmentId: String!) {
  getGradingSystems(spaceId: $spaceId, assessmentId: $assessmentId) {
    gradingSystemId
   
   
    from
    to
    remark
    grade
    color
    principalComment
    formTeacherComment
  }
}
""";

//added these four code for the future
const getSubAssessmentsQuery = r"""
  query GetSubAssessments($spaceId: ID!) {
    getSubAssessments(spaceId: $spaceId) {
      subAssessmentId
      name
      # spaceId
      # createdAt
      # updatedAt
    }
  }
""";

const withholdResultsMutation = r"""
  mutation WithholdResults($spaceId: ID!, $input: WithholdResultsInput!) {
    withholdResults(spaceId: $spaceId, input: $input)
  }
""";

const getWithheldResultsQuery = r"""
  query GetWithheldResults($spaceId: ID!, $input: GetWithheldResults!) {
    getWithheldResults(spaceId: $spaceId, input: $input) {
      resultId
      subjects
      session {
        sessionId
        session
      }
      term {
        name
        termId
      }
      withholdReason
      withheldAt
      publishedAt
      student {
        memberId
        firstName
        lastName
        middleName
        profilePicture
        user {
          firstName
          lastName
          username
          profileImageUrl
        }
      }
      class {
        id
        name
        classGroup {
          id
          name
        }
      }
    }
  }
""";

const releaseResultsMutation = r"""
  mutation ReleaseResults($spaceId: ID!, $input: ReleaseWithheldResults!) {
    releaseResults(spaceId: $spaceId, input: $input)
  }
""";

const getCongitiveQuery = r"""
query GetClassCognitiveKeys($spaceId: ID!, $classId: ID!) {
  getClassCognitiveKeys(spaceId: $spaceId, classId: $classId) {
    cognitiveKeyId
    name
    domain
    spaceId
    createdAt
    updatedAt
  }
}
""";
