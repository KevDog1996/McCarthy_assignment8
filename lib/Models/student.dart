class Student {
  final String id;
  final String fname;
  final String lname;
  final String studentID;
  final String dateEntered;

  Student._(this.id, this.fname, this.lname, this.studentID, this.dateEntered);

  factory Student.fromJson(Map json) {
    final id = json['_id'];
    final fname = json['fname'];
    final lname = json['lname'];
    final studentID = json['studentID'];
    final dateEntered = json['dateEntered'];

    return Student._(id, fname, lname, studentID, dateEntered);
  }
}
