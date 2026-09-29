import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onMenuTap;
  const HomeScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final t = AppLocalizations.of(context)!;

    if (appState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final percent = (appState.todayTotal / appState.dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final circleSize = (constraints.maxWidth * 0.58).clamp(160.0, 240.0);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: onMenuTap,
                      ),
                      IconButton(
                        icon: Icon(appState.isDarkMode ? Icons.dark_mode : Icons.wb_sunny),
                        style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                        onPressed: () => appState.toggleTheme(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_greeting(t),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(t.stayHydrated, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/AAA.png',
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: circleSize,
                            height: circleSize,
                            child: CircularProgressIndicator(
                              value: percent,
                              strokeWidth: 14,
                              backgroundColor: AppColors.trackLight,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.water_drop, color: AppColors.primary, size: 28),
                              Text('${appState.todayTotal} ml',
                                  style: TextStyle(
                                      fontSize: circleSize * 0.12, fontWeight: FontWeight.bold)),
                              Text('${t.dailyGoal.split(' ').first} ${appState.dailyGoal} ml',
                                  style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${(percent * 100).round()}%',
                          style: const TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => appState.addGlass(),
                    icon: const Icon(Icons.local_drink),
                    label: Text(t.addGlass),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: _InfoCard(
                              icon: Icons.track_changes,
                              label: t.dailyGoal,
                              value: '${appState.dailyGoal} ml')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _InfoCard(
                              icon: Icons.local_drink_outlined,
                              label: t.glassSize,
                              value: '${appState.glassSize} ml')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _InfoCard(
                              icon: Icons.bar_chart,
                              label: t.todaysCount,
                              value: '${appState.todayCount} ${t.glasses}')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _InfoCard(
                              icon: Icons.access_time,
                              label: t.nextReminder,
                              value: 'in 1 hour')),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String _greeting(AppLocalizations t) {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return t.goodMorning;
  if (hour >= 12 && hour < 18) return t.goodAfternoon;
  return t.goodEvening;
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}


