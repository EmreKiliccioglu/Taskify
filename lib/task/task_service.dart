import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskify/task/task_model.dart';
import '../user/auth.dart';

class TaskService {
  final Auth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskService(this._auth);

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  CollectionReference get _taskRef {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks');
  }

  Future<void> createTask(Task task) async {
    await _taskRef.add({
      ...task.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Task>> getAllTasks() {
    return _taskRef
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Task>> getActiveTasks() {
    return _taskRef
        .where('isCompleted', isEqualTo: false)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Task>> getCompletedTasks() {
    return _taskRef
        .where('isCompleted', isEqualTo: true)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
    );
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required bool isCompleted,
  }) async {
    await _taskRef.doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> updateTask(Task task) async {
    await _taskRef.doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String taskId) async {
    await _taskRef.doc(taskId).delete();
  }

  Stream<List<Task>> getTasksByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _taskRef
        .where(
      'dueDate',
      isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
    )
        .where(
      'dueDate',
      isLessThan: Timestamp.fromDate(endOfDay),
    )
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
    );
  }
}
