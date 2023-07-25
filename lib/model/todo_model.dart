import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final bool isDone;
  @HiveField(4)
  final bool isArchived;

  TodoModel({
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
    required this.isArchived,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'isDone': isDone,
      'isArchived': isArchived,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      isDone: json['isDone'] as bool,
      isArchived: json['isArchived'] as bool,
    );
  }
}
