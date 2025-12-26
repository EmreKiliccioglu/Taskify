import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskify/task/task_model.dart';
import 'package:taskify/task/task_service.dart';
import '../core/global.dart';
import '../l10n/app_localizations.dart';
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
          return Center(child: Text(AppLocalizations.of(context)!.noTaskForToday));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                        children: [
                          Icon(
                            Icons.delete,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.delete,
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
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
                                    DateFormat('HH:mm',appLocale.value.languageCode).format(task.dueDate.toLocal()),
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
                                          DateFormat('dd MMM yyyy',appLocale.value.languageCode).format(task.dueDate.toLocal()),
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
                                              ? AppLocalizations.of(context)!.reminderAtTime
                                              : AppLocalizations.of(context)!.reminderMinutesBefore(
                                            task.reminderMinutes,
                                          ),
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
                ? AppLocalizations.of(context)!.taskCompletedQuestion
                : AppLocalizations.of(context)!.reactivateTaskQuestion,
          ),
          content: Text(
            willComplete
                ? AppLocalizations.of(context)!.markTaskCompletedConfirmation
                : AppLocalizations.of(context)!.reactivateTaskConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.confirm),
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
          title: Text(AppLocalizations.of(context)!.deleteTaskQuestion),
          content: Text(
            AppLocalizations.of(context)!.deleteTaskConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }
}
