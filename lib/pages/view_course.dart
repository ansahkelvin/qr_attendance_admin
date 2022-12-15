import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/model/courses.dart';
import 'package:qr_code/pages/create_attendance.dart';
import 'package:qr_code/pages/view_attendance.dart';
import 'package:qr_code/provider/firebase_provider.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key, required this.course});
  final Course course;

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  late Future course;
  @override
  void initState() {
    course = Provider.of<FirebaseProvider>(context, listen: false)
        .viewClass(widget.course.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Sessions"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateAttendance(course: widget.course),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: FutureBuilder(
            future: course,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return provider.classes.isEmpty
                    ? const Center(
                        child: Text("No classes are available"),
                      )
                    : ListView.builder(
                        itemCount: provider.classes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewAttendance(
                                model: provider.classes[index],
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(provider.classes[index].roomNumber),
                            subtitle: Text(provider.classes[index].date),
                          ),
                        ),
                      );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
