import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/firebase_provider.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final titleController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;

  Future<void> addtoCourse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebaseProvider>(context, listen: false).createCourse(
          titleController.text, codeController.text, nameController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Course added sucessfully"),
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
        title: const Text("Create a course"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Course Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: "Course Code",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Lecturer Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: addtoCourse,
                child: Text(isLoading ? "Adding to course" : "Create course"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
