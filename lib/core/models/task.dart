import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';

class Task {
  final String id;
  final String title;
  final DateTime deadlineDateTime;
  final String description;
  final Category category;
  final String priority;
  final bool isDone;
  final bool onlyDate;
  final bool onlyTime;
  final bool useDateTime;
  final bool isShared;
  final Shared shared;

  Task(
      {this.id,
      this.title,
      this.deadlineDateTime,
      this.description,
      this.category,
      this.priority,
      this.isDone,
      this.onlyDate,
      this.onlyTime,
      this.useDateTime,
      this.shared,
      this.isShared});

  factory Task.fromMap(
      Map<String, dynamic> map, String id, Category category, Shared shared) {
    return Task(
      id: id ?? '',
      title: map['task_name'] ?? '',
      deadlineDateTime: map['deadlineDateTime'] ?? null,
      description: map['description'] ?? '',
      category: category ?? null,
      priority: map['priority'] ?? 'None',
      isDone: map['isDone'] ?? false,
      onlyDate: map['onlyDate'] ?? false,
      onlyTime: map['onlyTime'] ?? false,
      useDateTime: map['useDateTime'] ?? false,
      shared: shared ?? null,
      isShared: map['isShared'] ?? false,
    );
  }
}
