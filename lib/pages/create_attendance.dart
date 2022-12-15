import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/model/courses.dart';

import '../provider/firebase_provider.dart';

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({super.key, required this.course});
  final Course course;

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  final roomController = TextEditingController();
  final keyController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  bool isLoading = false;

  Future<void> addAttendance() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebaseProvider>(context, listen: false).createClass(
        roomController.text,
        keyController.text,
        dateController.text,
        timeController.text,
        widget.course.uid,
        widget.course.title,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Class added sucessfully"),
        ),
      );
      setState(() {
        isLoading = false;
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a class"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: roomController,
              decoration: const InputDecoration(
                  labelText: "Room number", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: keyController,
              decoration: const InputDecoration(
                  labelText: "Secret Key", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                  labelText: "Date", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: timeController,
              decoration: const InputDecoration(
                  labelText: "Time", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(MediaQuery.of(context).size.width, 50)),
              onPressed: addAttendance,
              child: Text(isLoading ? "creating class" : "Create a Class"),
            ),
          ],
        ),
      )),
    );
  }
}
