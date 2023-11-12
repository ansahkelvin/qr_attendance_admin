import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/model/classes.dart';
import 'package:qr_code/provider/firebase_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key, required this.model});
  final ClassModel model;

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  late Future attendance;
  @override
  void initState() {
    final provider = Provider.of<FirebaseProvider>(context, listen: false)
        .viewAttendance(widget.model.docId);
    attendance = provider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseProvider>(context);
    provider.viewAttendance(widget.model.docId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QrImageView(
                  data: widget.model.key,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Attendance List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: attendance,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return provider.attendance.isEmpty
                          ? const Center(
                              child: Text("No one present"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.attendance.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(provider.attendance[index].name),
                                subtitle:
                                    Text(provider.attendance[index].indexNo),
                                trailing: Text(provider.attendance[index].time),
                              ),
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
