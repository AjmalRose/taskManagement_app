import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_management_app/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> box = Hive.box<Task>('tasks');

  List<Task> get all => box.values.toList();
  List<Task> get pending => all.where((e) => !e.isCompleted).toList();
  List<Task> get completed => all.where((e) => e.isCompleted).toList();

  void add(Task task) {
    box.add(task);
    notifyListeners();
  }

  void update(Task task) {
    task.save();
    notifyListeners();
  }

  void delete(Task task) {
    task.delete();
    notifyListeners();
  }
}
