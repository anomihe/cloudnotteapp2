String getCoursesQuery =
   r"""
   query GetCourses($spaceId: ID!) {
  getCourses(spaceId: $spaceId) {
    id
    title
    description
    clicks
    thumbnail
    introVideo
    price
    published
    hasExams
    averageRating
    duration
    totalLessons
    difficultyLevel
    requirements
    whatYouWillLearn
    deleted
    lessonFlow
    completionType
    timeLimitType
    timeLimitDays
    timeLimitEndDate
    applyToNewStudents
    spaceId
    createdById
    paymentItemId
    instructorsIds
    examGroupId
    classesIds
    createdAt
    updatedAt
  }
}
  """;
