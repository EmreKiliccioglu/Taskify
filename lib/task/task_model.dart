import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

class Task {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final int reminderMinutes;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.reminderMinutes,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['dueDate'] as Timestamp;

    final tzDueDate = tz.TZDateTime.from(timestamp.toDate(), tz.getLocation('Europe/Istanbul'));

    return Task(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: tzDueDate,
      isCompleted: data['isCompleted'] ?? false,
      reminderMinutes: data['reminderMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toUtc(),
      'isCompleted': isCompleted,
      'reminderMinutes': reminderMinutes,
    };
  }
}
