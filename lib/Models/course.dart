class Course {
  final String courseID;
  final String courseName;
  final String courseInstructor;
  final String courseCredits;
  final String dateEntered;

  Course._(this.courseID, this.courseName, this.courseInstructor,
      this.courseCredits, this.dateEntered);

  factory Course.fromJson(Map json) {
    final courseID = json['courseID'];
    final courseName = json['courseName'];
    final courseInstructor = json['courseInstructor'];
    final courseCredits = json['courseCredits'];
    final dateEntered = json['dateEntered'];

    return Course._(
        courseID, courseName, courseInstructor, courseCredits, dateEntered);
  }
}
