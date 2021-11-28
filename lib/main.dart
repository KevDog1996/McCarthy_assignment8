// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'api.dart';
import 'editCourse.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Assignment 8',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CourseApi api = CourseApi();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List courses = [];
  bool dbLoaded = false;

  void initState() {
    super.initState();
    widget.api.getAllCourses().then((data) {
      setState(() {
        courses = data;
        dbLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Text("Courses"),
      ),
      body: Center(
          child: dbLoaded
              ? Column(
                  children: [
                    Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15.0),
                          children: [
                            ...courses
                                .map<Widget>(
                                  (course) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: TextButton(
                                      onPressed: () => {
                                        Navigator.pop(context),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCourse(
                                                        course['_id'],
                                                        course['courseID'],
                                                        course['courseName'],
                                                        course[
                                                            'courseInstructor'],
                                                        course['courseCredits']
                                                            .toString(),
                                                        course[
                                                            'dateEntered']))),
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.green[200],
                                            child: Text(
                                              (course['courseID']),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          title: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.green[200]),
                                            child: Text(
                                              (course['courseName'] +
                                                  "\n" +
                                                  course['courseInstructor'] +
                                                  "\n" +
                                                  "Credits: " +
                                                  course['courseCredits']
                                                      .toString()),
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
    );
  }
}
