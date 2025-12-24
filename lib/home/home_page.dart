import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/task/add_task.dart';
import '../core/menu.dart';
import '../task/task_list.dart';
import '../task/task_service.dart';
import '../user/auth.dart';
import 'settings.dart';
import '../core/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskService _taskService;
  late final ScrollController _calendarController;

  bool _isDarkTheme = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(Auth());
    _calendarController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const itemWidth = 76; // kart genişliği + spacing
      _calendarController.jumpTo(itemWidth * 7);
    });

    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool('darkTheme') ?? false;

    setState(() => _isDarkTheme = savedTheme);
    isDarkTheme.value = savedTheme;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime> _generateDays() {
    final today = DateTime.now();
    return List.generate(
      15,
          (i) => DateTime(today.year, today.month, today.day + (i - 7)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _generateDays();
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => MenuPanel.open(context),
        ),
        title: const Text('Taskify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAKVİM BAR
          SizedBox(
            height: 110,
            child: ListView.separated(
              controller: _calendarController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = _isSameDay(day, _selectedDate);
                final isToday = _isSameDay(day, today);
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = day);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 64,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: theme.colorScheme.primary
                              .withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isSameDay(day, today)
                                  ? 'Bugün'
                                  : DateFormat('MMMM', 'tr_TR').format(day),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white70
                                    : theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),

                        // TODAY INDICATOR
                        if (isToday && !isSelected)
                          Positioned(
                            bottom: 8,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // SEÇİLEN GÜNÜN TASKLARI
          Expanded(
            child: TaskListPage(
              taskStream: _taskService.getTasksByDate(_selectedDate),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
