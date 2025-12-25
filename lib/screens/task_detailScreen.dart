import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/provider/taskProvider.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(task.title, style: TextStyle(fontSize: 22)),
            Text(task.description),
            Switch(
              value: task.isCompleted,
              onChanged: (v) {
                task.isCompleted = v;
                provider.update(task);
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Delete?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.delete(task);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
