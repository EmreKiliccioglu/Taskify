import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskify/task/task_model.dart';
import 'package:taskify/task/task_service.dart';
import '../user/auth.dart';

class TaskListPage extends StatelessWidget {
  final Stream<List<Task>> taskStream;
  final _taskService = TaskService(Auth());


  TaskListPage({
    super.key,
    required this.taskStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: taskStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('❌ Firestore Stream Error: ${snapshot.error}');
          return const SizedBox.shrink();
        }
        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return const Center(child: Text('Bugün için bir görev eklenmedi!'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = tasks[index];
            final theme = Theme.of(context);
            return Slidable(
              key: ValueKey(task.id),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.25,
                children: [
                  CustomSlidableAction(
                    onPressed: (_) async {
                      final confirm = await _confirmDelete(context);
                      if (confirm == true) {
                        await _taskService.deleteTask(task.id);
                      }
                    },
                    backgroundColor: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.delete,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.25),
                    width: 1,
                  ),
                  color: theme.cardColor,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 70,
                                child: Center(
                                  child: Text(
                                    DateFormat('HH:mm').format(task.dueDate.toLocal()),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    if (task.description.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style:
                                        const TextStyle(fontSize: 14),
                                      ),
                                    ],

                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        Text(
                                          DateFormat('dd MMM yyyy').format(task.dueDate.toLocal()),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.notifications_active_outlined,
                                          size: 14,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.reminderMinutes == 0
                                              ? 'At time'
                                              : '${task.reminderMinutes} dk önce',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) async {
                                  final confirm =
                                  await _confirmStatusChange(
                                      context, value ?? false);
                                  if (confirm == true) {
                                    await _taskService.updateTaskStatus(
                                      taskId: task.id,
                                      isCompleted: value ?? false,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _confirmStatusChange(BuildContext context, bool willComplete) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            willComplete
                ? 'Görev tamamlandı mı?'
                : 'Görev tekrar aktif olsun mu?',
          ),
          content: Text(
            willComplete
                ? 'Bu görevi tamamlandı olarak işaretlemek istiyor musunuz?'
                : 'Bu görevi tekrar aktif hale getirmek istiyor musunuz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  // SİLME ONAYI
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Görev silinsin mi?'),
          content: const Text(
            'Bu görevi kalıcı olarak silmek istiyor musunuz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
