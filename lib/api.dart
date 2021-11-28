import 'package:dio/dio.dart';
import 'Models/course.dart';

const String localhost = "http://localhost:1200/";

class CourseApi {
  final _dio = Dio(BaseOptions(baseUrl: localhost));

  Future<List> getAllCourses() async {
    final response = await _dio.get('/getAllCourses');

    return response.data['courses'];
  }

  Future<List> getAllStudents() async {
    final response = await _dio.get('/getAllStudents');

    return response.data['students'];
  }

  Future<List> editStudentById(String id, String fname) async {
    final response = await _dio
        .post('editStudentById', data: {'studentID': id, 'fname': fname});
    return response.data;
  }

  Future<List> deleteCourse(String courseID) async {
    final response =
        await _dio.post('/deleteCourseById', data: {'courseID': courseID});
    return response.data;
  }
}
