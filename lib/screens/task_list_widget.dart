import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/provider/taskProvider.dart';
import 'package:task_management_app/screens/task_detailScreen.dart';
import 'package:task_management_app/models/task_model.dart';

class TaskList extends StatefulWidget {
  final int type;
  const TaskList({super.key, required this.type});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    final allTasks = widget.type == 0
        ? provider.all
        : widget.type == 1
        ? provider.pending
        : provider.completed;

    final tasks = allTasks
        .where(
          (t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search tasks",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),

        Expanded(
          child: tasks.isEmpty
              ? Center(child: Text("No tasks found"))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    final Task t = tasks[i];
                    return Dismissible(
                      key: Key(t.key.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        bool confirm = false;
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            title: Text("Delete Task"),
                            content: Text(
                              "Are you sure you want to delete this task?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  confirm = false;
                                },
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  confirm = true;
                                  Navigator.pop(context);
                                },
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        );
                        return confirm;
                      },
                      onDismissed: (_) {
                        provider.delete(t);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Task deleted")));
                      },
                      child: ListTile(
                        title: Text(t.title),
                        subtitle: Text(DateFormat.yMMMd().format(t.dueDate)),
                        trailing: Icon(
                          Icons.circle,
                          color: t.isCompleted ? Colors.green : Colors.orange,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: t),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
