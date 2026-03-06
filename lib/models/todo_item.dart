import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesetupapp/database_service/firestore_keys.dart';

class TodoItem {
  final String id;
  final String taskName;
  final String taskDescription;
  final String part;
  final bool isDone;

  const TodoItem({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.part,
    required this.isDone,
  });

  factory TodoItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TodoItem(
      id: doc.id,
      taskName: data[FirestoreKeys.taskName] as String? ?? '',
      taskDescription: data[FirestoreKeys.taskDescription] as String? ?? '',
      part: data[FirestoreKeys.part] as String? ?? '',
      isDone: data[FirestoreKeys.done] as bool? ?? false,
    );
  }
}
