import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/menu.dart';
import 'settings.dart';
import '../l10n/app_localizations.dart';
import '../core/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedTheme = prefs.getBool('darkTheme') ?? false;
    setState(() => _isDarkTheme = savedTheme);
    isDarkTheme.value = savedTheme;
  }

  Future<void> _updateTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _isDarkTheme = value);
    isDarkTheme.value = value;
    await prefs.setBool('darkTheme', value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabLabelColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            MenuPanel.open(context);
          },
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 48,
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicatorPadding: EdgeInsets.zero,
                labelColor: tabLabelColor,
                unselectedLabelColor:
                theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.all),
                  Tab(text: AppLocalizations.of(context)!.active),
                  Tab(text: AppLocalizations.of(context)!.completed),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('All tasks')),
          Center(child: Text('Active tasks')),
          Center(child: Text('Completed tasks')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
