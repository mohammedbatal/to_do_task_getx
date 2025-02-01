import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime dueDate;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
  });
}
