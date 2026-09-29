import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';
import 'app_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final screens = [
      HomeScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
      const HistoryScreen(),
      const RemindersScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(currentIndex: _currentIndex, onSelect: _goTo),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Theme.of(context).cardColor,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: t.history),
          BottomNavigationBarItem(icon: const Icon(Icons.notifications), label: t.reminders),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: t.settings),
        ],
      ),
    );
  }
}
