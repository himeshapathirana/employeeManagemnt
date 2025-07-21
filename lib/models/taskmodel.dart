// lib/models/task.dart
import 'dart:convert';

enum TaskPriority { Low, Medium, High }

enum TaskStatus { NotStarted, InProgress, Done, ToDo, Completed, Pending }

class Task {
  String id;
  String name;
  DateTime dueDate;
  TaskPriority priority;
  TaskStatus status;

  Task({
    required this.id,
    required this.name,
    required this.dueDate,
    this.priority = TaskPriority.Medium,
    this.status = TaskStatus.NotStarted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: TaskPriority.values[map['priority']],
      status: TaskStatus.values[map['status']],
    );
  }

  static String encode(List<Task> tasks) => json.encode(
    tasks.map<Map<String, dynamic>>((task) => task.toMap()).toList(),
  );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromMap(item))
          .toList();
}
