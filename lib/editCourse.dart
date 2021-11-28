// ignore_for_file: file_names, no_logic_in_create_state, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:testassignment8/editStudent.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'editStudent.dart';

class EditCourse extends StatefulWidget {
  final String id,
      courseID,
      courseName,
      courseInstructor,
      courseCredits,
      dateEntered;
  final CourseApi api = CourseApi();

  EditCourse(this.id, this.courseID, this.courseName, this.courseInstructor,
      this.courseCredits, this.dateEntered);

  @override
  _EditCourseState createState() => _EditCourseState(
      id, courseID, courseName, courseInstructor, courseCredits, dateEntered);
}

class _EditCourseState extends State<EditCourse> {
  List students = [];
  bool dbLoaded = false;

  void initState() {
    super.initState();
    widget.api.getAllStudents().then((data) {
      setState(() {
        students = data;
        dbLoaded = true;
      });
    });
  }

  void _deleteCourse(courseID) {
    setState(() {
      widget.api.deleteCourse(courseID);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  final String id,
      courseID,
      courseName,
      courseInstructor,
      courseCredits,
      dateEntered;
  _EditCourseState(this.id, this.courseID, this.courseName,
      this.courseInstructor, this.courseCredits, this.dateEntered);

  //void _changeStudent()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Text("Delete Course: " + widget.courseName),
      ),
      body: Center(
          child: dbLoaded
              ? Column(
                  children: [
                    TextButton(
                        onPressed: () => {_deleteCourse(courseID)},
                        child: Text("Delete Course")),
                    Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15.0),
                          children: [
                            ...students
                                .map<Widget>(
                                  (student) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: TextButton(
                                      onPressed: () => {
                                        Navigator.pop(context),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditStudent(
                                                      student['_id'],
                                                      student['fname'],
                                                      student['lname'],
                                                      student['studentID'],
                                                      student['dateEntered'],
                                                    ))),
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.green[200],
                                            radius: 30,
                                            child: Text(
                                              (student['studentID']),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          title: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.green[200]),
                                            child: Text(
                                              (student['fname'] +
                                                  "\n" +
                                                  student['lname'] +
                                                  "\n"),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                                .toList(),
                          ]),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Database loading",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    CircularProgressIndicator()
                  ],
                )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              }),
    );
  }
}
