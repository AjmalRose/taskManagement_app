import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/provider/taskProvider.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  DateTime date = DateTime.now();

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
            TextField(
              controller: title,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: desc,
              decoration: InputDecoration(labelText: "Description"),
            ),
            ElevatedButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (d != null) setState(() => date = d);
              },
              child: Text("Pick Date"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.add(
                  Task(
                    title: title.text,
                    description: desc.text,
                    dueDate: date,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
