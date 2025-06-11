const String user = r"""
 query GetUser {
  getUser {
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
}

""";
const String getUserByUSernameQuery = r"""
  query GetUserByUsername($username: String!) {
    getUserByUsername(username: $username) {
      firstName
      lastName
      type
      username
      email
      profileImageUrl
      phoneNumber
      createdAt
      updatedAt
    }
}
 """;
const String userSpacesQuery = r"""
query GetUserSpaces {
  getUserSpaces {
    id
    name
    description
    phoneNumber
    email
    logo
    currentSpaceSessionId
    currentSpaceTermId
    createdById
    categories
    curriculums
    type
    currency
    createdAt
    isPaid
    alias
    studentCount
    teacherCount
    classCount
    subjectCount
    spaceTerms {
      id
      name
      alias
      spaceId
    }
    spaceSessions {
      id
      session
      alias
      spaceId
    }
  }
}
""";

const String spaceUserQuery = r"""
query GetSpaceUser($alias: String!, $userId: String!) {
  getSpaceUser(alias: $alias, userId: $userId) {
    ... on StudentResponse {
      __typename
      additionalRole
      admissionNumber
      firstName
      lastName
      middleName
      profilePicture
      qualification
      retirementDate
      salaryGradeLevel
      schoolHouse
      staffNumber
      staffStatus
      staffType
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
      parents {
        id
        title
        firstName
        lastName
        pictureUrl
        phoneNumber
        email
        occupation
        address
        relationshipToStudent
        eligibleToReceiveMessage
      }
      spaceWallet {
        id
        balance
        pinIsSet
      }
      role
      memberId
      class {
        classGroup {
          id
          name
        }
        classGroupId
        id
        name
      }
      status
      dedicatedAccountBank
      dedicatedAccountName
      dedicatedAccountNumber
      dedicatedAccountProviderId
      dedicatedAccountReference
    }
    ... on TeacherResponse {
      __typename
      additionalRole
      admissionNumber
      firstName
      lastName
      middleName
      profilePicture
      qualification
      retirementDate
      salaryGradeLevel
      schoolHouse
      staffNumber
      staffStatus
      staffType
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
      memberId
      assignedClass {
        id
        name
        classGroup {
          id
          name
        }
      }
      subjects {
        id
        subjectId
        subject {
          id
          name
        }
        classId
        class {
          id
          name
          classGroup {
            id
            name
          }
        }
        teacherId
      }
      status
    }
    ... on AdminResponse {
      __typename
      additionalRole
      admissionNumber
      firstName
      lastName
      middleName
      profilePicture
      qualification
      retirementDate
      salaryGradeLevel
      schoolHouse
      staffNumber
      staffStatus
      staffType
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
      memberId
      assignedClass {
        id
        name
        classGroup {
          id
          name
        }
      }
      subjects {
        id
        subjectId
        subject {
          id
          name
        }
        classId
        class {
          id
          name
          classGroup {
            id
            name
          }
        }
        teacherId
      }
      status
    }
  }
}
""";

const String studentTimeTableQuery = r"""
query GetClassTimeTable($classId: ID!, $spaceId: ID!,) {
  getClassTimeTable(classId: $classId, spaceId: $spaceId,) {
    id
    activity
    class {
      classGroup {
        classes {
          description
          formTeacher {
           firstName
           lastName
           profilePicture
          createdAt
          }
        }
      }
    }
    updatedAt
    classId
    createdAt
    dayOfWeek {
      createdAt
      enabled
      id
      name
      spaceId
      updatedAt
    }
    dayOfWeekId
    liveClassroom
    location
    subject {
      description
      id
      name
      spaceId
      teacherId
      teacher {
        lastName
        id
        firstName
        profilePicture
      }
    }
    timeSlotId
    subjectId
    timeSlot {
      updatedAt
      id
      createdAt
      spaceId
      time
    }
    classRecordings {
      id,
      recordUrl
    }
  }
}
""";
const String teacherTimeTableQuery = r"""
query GetTeacherTimeTable($spaceId: ID!, $teacherId: ID) {
  getTeacherTimeTable(spaceId: $spaceId, teacherId: $teacherId) {
    id
    class {
      id
      name
      classGroup {
        id
        name
      }
    }
    dayOfWeekId
    dayOfWeek {
      id
      name
    }
    timeSlotId
    timeSlot {
      id
      time
    }
    subjectId
    subject {
      id
      name
      teacher {
        id
        firstName
        lastName
        user {
          firstName
          lastName
        }
      }
    }
    classRecordings {
      id
      timetableId
      recordUrl
      lessonNote {
        id
        topic
        topicCover
        taught
      }
      createdAt
    }
    activity
    location
    liveClassroom
    createdAt
    updatedAt
  }
}
""";

const String saveRecordingQuery = r"""
  mutation SaveClassRecording($input: SaveClassRecording!, $spaceId: ID!) {
    saveClassRecording(input: $input, spaceId: $spaceId)
  }
""";

String justSpace = r"""
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
    features
    contactPersonCount
    foundingYear
    colour
    genders
    stamp
    accountingPinIsSet
    reportSheetType
    spaceAttendaceConfigIsSet
    smsUnitBalance
  }
}""";

const String getClassesQuery = r"""
  query GetClasses($classGroupId: ID!, $spaceId: ID!) {
    getClasses(classGroupId: $classGroupId, spaceId: $spaceId) {
      id,
      name,
      spaceId,
      studentCount,
      subjectCount,
      classGroupId,
    }
  }
 """;

const String getClassGroupQuery = r"""
  query GetClassGroups($spaceId: ID!) {
    getClassGroups(spaceId: $spaceId) {
      id 
      name
      classes {
        id
        name
        spaceId
        studentCount
        subjectCount
        classGroupId
      }
    }
  }
""";

const String spaceInviteQuery =
    r"""query GetUserSpaceInvitations($input: UserSpaceInvitationFilterInput!) {
  getUserSpaceInvitations(input: $input) {
    data {
      id
      type
      status
      metadata
      inviteeId
      inviterId
      spaceId
      classId
      space {
        id
        name
        description
        phoneNumber
        email
        logo
        type
        currency
        createdAt
        isPaid
        alias
      }
      class {
        id
        name
        description
        classGroup {
          id
          name
          description
        }
      }
    }
    meta {
      pageSize
      nextCursor
      hasMore
    }
  }
}""";

const String spaceInviteAcceptMutation =
    r"""mutation AcceptSpaceInvite($input: AcceptSpaceInviteInput!) {
  acceptSpaceInvite(input: $input)
}""";

const String spaceInviteRejectMutation =
    r"""mutation DeclineSpaceInvite($input: DeclineSpaceInviteInput!) {
  declineSpaceInvite(input: $input)
}""";

const String spaceInviteLinkMutation = r"""
  mutation ResponseToSpaceLinkRequest($input: ResponseToSpaceLinkRequestInput!) {
  responseToSpaceLinkRequest(input: $input)
}
""";

const String spaceInviteLinkQuery = r"""query GetPendingSpaceLinkRequests {
  getPendingSpaceLinkRequests {
    id
    spaceId
    requesterId
    requestedUserId
    status
    createdAt
    updatedAt
    requester {
      id
      email
      firstName
      lastName
      profileImageUrl
    }
  }
}""";

const String spaceInviteLinkAcceptMutation = r"""
 mutation SendLinkAccountRequest($input: LinkSpaceRequestInput!) {
  sendLinkAccountRequest(input: $input)
}
""";
