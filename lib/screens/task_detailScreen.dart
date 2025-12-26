import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/provider/taskProvider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController =
        TextEditingController(text: widget.task.description ?? "");
  }

  void _saveTextChanges() {
    final provider = context.read<TaskProvider>();

    widget.task.title = _titleController.text.trim();
    widget.task.description = _descController.text.trim();

    provider.update(widget.task);

    _isEditing = false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task updated")),
    );
  }

  void _deleteTask() {
    final provider = context.read<TaskProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.delete(widget.task);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveTextChanges();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descController,
              enabled: _isEditing,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Consumer<TaskProvider>(
              builder: (context, provider, _) => SwitchListTile(
                title: Text("Completed"),
                value: widget.task.isCompleted,
                onChanged: (value) {
                  widget.task.isCompleted = value;
                  provider.update(widget.task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
