import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/model/courses.dart';
import 'package:qr_code/pages/view_course.dart';
import 'package:qr_code/provider/firebase_provider.dart';

class ViewClass extends StatefulWidget {
  const ViewClass({super.key});

  @override
  State<ViewClass> createState() => _ViewClassState();
}

class _ViewClassState extends State<ViewClass> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Courses"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
        child: FutureBuilder<Course>(
            future: provider.viewCourse(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.allCourses.length,
                        itemBuilder: (context, index) {
                          final course = provider.allCourses[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateClass(course: course),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                              ),
                              height: 100,
                              width: double.infinity,
                              child: ListTile(
                                title: Text(
                                  course.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                ),
                                subtitle: Text(
                                  course.code,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                );
              } else {
                const Center(
                  child: Text("No data available"),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
