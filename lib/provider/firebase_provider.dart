import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/model/attendance.dart';
import 'package:qr_code/model/classes.dart';
import 'package:qr_code/model/courses.dart';

class FirebaseProvider with ChangeNotifier {
  final firebase = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  get firebaseUser => firebase.authStateChanges();
  List<Course> allCourses = [];
  List<ClassModel> classes = [];
  List<Attendance> attendance = [];

  Course course = Course(title: "", code: "", lecturer: "", uid: "");
  ClassModel classModel = ClassModel(
    roomNumber: "",
    key: "",
    date: "",
    time: "",
    courseId: "",
    courseTitle: "",
    docId: "",
  );

  Future<void> signIn(String email, String password) async {
    await firebase.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createCourse(String title, String code, String lecturer) async {
    await firestore.collection("courses").add({
      "courseTitle": title,
      "courseCode": code,
      "lecturer": lecturer,
      "uid": code,
    });
    notifyListeners();
  }

  Future<Course> viewCourse() async {
    final snapshot = await firestore.collection("courses").get();
    final data = snapshot.docs;
    var newList = data
        .map((data) => Course(
              title: data.data()["courseTitle"],
              code: data.data()["courseCode"],
              lecturer: data.data()["lecturer"],
              uid: data.data()["uid"],
            ))
        .toList();
    allCourses = newList;
    notifyListeners();

    return course;
  }

  Future<Course> viewAttendance(String id) async {
    final snapshot = await firestore.collection("class/$id/attendance").get();
    final data = snapshot.docs;
    var newList = data
        .map((data) => Attendance(
              name: data.data()["name"],
              indexNo: data.data()["index"],
              time: data.data()["time"],
              docId: data.data()["docId"],
            ))
        .toList();
    attendance = newList;
    notifyListeners();

    return course;
  }

  Future<void> createClass(String roomNumber, String secretKey, String date,
      String time, String courseId, String courseTitle) async {
    await firestore.collection("class").add({
      "roomNumber": roomNumber,
      "secretKey": secretKey,
      "courseId": courseId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "date": date,
      "time": time,
      "courseTitle": courseTitle,
    });
    notifyListeners();
  }

  Future<ClassModel> viewClass(String courseId) async {
    final snapshot = await firestore
        .collection("class")
        .where("courseId", isEqualTo: courseId)
        .get();
    final data = snapshot.docs;
    var newList = data
        .map((data) => ClassModel(
              roomNumber: data.data()["roomNumber"],
              key: data.data()["secretKey"],
              date: data.data()["date"],
              time: data.data()["time"],
              courseId: data.data()["courseId"],
              courseTitle: data.data()["courseTitle"],
              docId: data.id,
            ))
        .toList();
    classes = newList;
    notifyListeners();
    return classModel;
    //
  }
}
