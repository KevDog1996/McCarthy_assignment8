// ignore_for_file: unused_import, file_names

import 'package:testassignment8/Models/course.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'api.dart';

class EditStudent extends StatefulWidget {
  final String id, fname, lname, studentID, dateEntered;
  final CourseApi api = CourseApi();

  EditStudent(
      this.id, this.fname, this.lname, this.studentID, this.dateEntered);

  @override
  _EditStudentState createState() =>
      _EditStudentState(id, fname, lname, studentID, dateEntered);
}

class _EditStudentState extends State<EditStudent> {
  bool dbLoaded = false;
  final String id, fname, lname, studentID, dateEntered;
  _EditStudentState(
      this.id, this.fname, this.lname, this.studentID, this.dateEntered);

  void _changeStudentName(id, fname) {
    setState(() {
      widget.api.editStudentById(id, fname);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fname,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter a new name for " + widget.fname,
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  ElevatedButton(
                      onPressed: () => {
                            _changeStudentName(
                                widget.studentID, nameController.text),
                          },
                      child: Text("Change Name")),
                ],
              ),
            )
          ],
        ),
      ),
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
