import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/task/speech_parser.dart';
import 'package:taskify/task/task_model.dart';
import 'package:taskify/task/task_service.dart';
import 'package:timezone/timezone.dart' as tz;
import '../user/auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'notification_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isListening = false;
  late stt.SpeechToText _speech;
  String _spokenText = '';
  DateTime? _date;
  TimeOfDay? _time;
  int _reminderMinutes = 0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _time = t);
  }

  /*void _mockSpeechInput() {
    const mockText =
        "bugün öğleden sonra kritik bir iş var"
    ;

    final parsed = parseSpokenTask(mockText);

    setState(() {
      _spokenText = mockText;
      _descController.text = parsed.description;
      _titleController.text = parsed.title;
      _date = parsed.date;
      _time = parsed.time;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mock ses analizi çalıştı'),
        duration: Duration(seconds: 2),
      ),
    );
  }*/

  Future<void> _toggleListening() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            final parsed = parseSpokenTask(_spokenText);

            setState(() {
              _isListening = false;

              _descController.text = parsed.description;
              _titleController.text = parsed.title;
              _date = parsed.date;
              _time = parsed.time;
            });

            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(AppLocalizations.of(context)!.voiceAnalysisCompleted),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);

        await _speech.listen(
          localeId: 'tr_TR',
          onResult: (result) {
            setState(() {
              _spokenText = result.recognizedWords;
              _descController.text = _spokenText;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskify'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TASK NAME
                      _Section(
                        title: AppLocalizations.of(context)!.taskName,
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.enterTitle,
                            prefixIcon: Icon(Icons.edit),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                        ),
                      ),

                      // DETAILS
                      _Section(
                        title: AppLocalizations.of(context)!.details,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description field
                            Expanded(
                              child: TextField(
                                controller: _descController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.enterTaskDetails,
                                  prefixIcon: Icon(Icons.notes),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Mic button
                            IconButton(
                              iconSize: 28,
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening ? Colors.red : Colors.grey,
                              ),
                              onPressed: _toggleListening,
                              //onPressed: _mockSpeechInput,
                            ),
                          ],
                        ),
                      ),

                      // DATE & TIME
                      _Section(
                        title: AppLocalizations.of(context)!.schedule,
                        child: Row(
                          children: [
                            _InfoButton(
                              icon: Icons.calendar_today,
                              label: _date == null
                                  ? AppLocalizations.of(context)!.selectDate
                                  : '${_date!.day}.${_date!.month}.${_date!.year}',
                              onTap: _pickDate,
                            ),
                            const SizedBox(width: 12),
                            _InfoButton(
                              icon: Icons.access_time,
                              label: _time == null
                                  ? AppLocalizations.of(context)!.selectTime
                                  : _time!.format(context),
                              onTap: _pickTime,
                            ),
                          ],
                        ),
                      ),

                      // REMINDER SELECTION
                      _Section(
                        title: AppLocalizations.of(context)!.reminder,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            _ReminderButton(
                              label: AppLocalizations.of(context)!.reminderAtTime,
                              selected: _reminderMinutes == 0,
                              onTap: () => setState(() => _reminderMinutes = 0),
                            ),
                            _ReminderButton(
                              label: AppLocalizations.of(context)!.reminder5MinBefore,
                              selected: _reminderMinutes == 5,
                              onTap: () => setState(() => _reminderMinutes = 5),
                            ),
                            _ReminderButton(
                              label: AppLocalizations.of(context)!.reminder15MinBefore,
                              selected: _reminderMinutes == 15,
                              onTap: () => setState(() => _reminderMinutes = 15),
                            ),
                            _ReminderButton(
                              label: AppLocalizations.of(context)!.reminder30MinBefore,
                              selected: _reminderMinutes == 30,
                              onTap: () => setState(() => _reminderMinutes = 30),
                            ),
                            _ReminderButton(
                              label: AppLocalizations.of(context)!.reminder1HourBefore,
                              selected: _reminderMinutes == 60,
                              onTap: () => setState(() => _reminderMinutes = 60),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // CREATE BUTTON
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_titleController.text.trim().isEmpty ||
                                  _date == null ||
                                  _time == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.fillRequiredFields)),
                                );
                                return;
                              }

                              final auth = Auth();
                              final user = auth.currentUser;

                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.userNotAuthenticated)),
                                );
                                return;
                              }

                              final dueDate = tz.TZDateTime(
                                tz.local, // tz.local = Europe/Istanbul
                                _date!.year,
                                _date!.month,
                                _date!.day,
                                _time!.hour,
                                _time!.minute,
                              );

                              final task = Task(
                                id: '',
                                userId: user.uid,
                                title: _titleController.text.trim(),
                                description: _descController.text.trim(),
                                dueDate: dueDate,
                                isCompleted: false,
                                reminderMinutes: _reminderMinutes,
                              );

                              await TaskService(Auth()).createTask(task);
                              final tzScheduledTime = dueDate.subtract(Duration(minutes: _reminderMinutes));

                              print("TZ Scheduled notification: $tzScheduledTime");
                              print("Current time: ${DateTime.now()}");

                              await NotificationService.scheduleTaskNotification(
                                id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
                                title: 'Task Reminder',
                                body: task.title,
                                scheduledTime: tzScheduledTime,
                              );

                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              AppLocalizations.of(context)!.createTask,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// SECTION WRAPPER
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// DATE / TIME BUTTON
class _InfoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InfoButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// PRIORITY BUTTON
class _PriorityButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// REMINDER BUTTON
class _ReminderButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReminderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary.withOpacity(0.15),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected
            ? theme.colorScheme.primary
            : theme.textTheme.bodyMedium?.color,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
