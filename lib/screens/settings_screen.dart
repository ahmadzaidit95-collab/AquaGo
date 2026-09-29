import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final t = AppLocalizations.of(context)!;

    final languageNames = {
      'en': 'English',
      'ar': 'العربية',
      'fr': 'Français',
      'es': 'Español',
    };

    final languageLabel = appState.locale == null
        ? t.systemDefault
        : (languageNames[appState.locale!.languageCode] ??
            appState.locale!.languageCode);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // =========================
            // HEADER
            // =========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.settingsTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        t.customizeExperience,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Water Mascot
                SizedBox(
                  width: 95,
                  height: 85,
                  child: Image.asset(
                    'assets/images/AAA.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // DAILY GOAL
            // =========================
            _SettingCard(
              icon: Icons.track_changes,
              title: t.dailyGoal,
              value: '${appState.dailyGoal} ml',
              child: Slider(
                value: appState.dailyGoal.toDouble(),
                min: 500,
                max: 5000,
                divisions: 45,
                activeColor: AppColors.primary,
                onChanged: (v) =>
                    appState.updateDailyGoal(v.round()),
              ),
            ),

            // =========================
            // GLASS SIZE
            // =========================
            _SettingCard(
              icon: Icons.local_drink,
              title: t.glassSize,
              value: '${appState.glassSize} ml',
              child: Slider(
                value: appState.glassSize.toDouble(),
                min: 50,
                max: 500,
                divisions: 45,
                activeColor: AppColors.primary,
                onChanged: (v) =>
                    appState.updateGlassSize(v.round()),
              ),
            ),

            // =========================
            // LANGUAGE
            // =========================
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.language,
                  color: AppColors.primary,
                ),
                title: Text(t.language),
                subtitle: Text(t.chooseLanguage),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languageLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LanguageScreen(),
                  ),
                ),
              ),
            ),

            // =========================
            // DARK MODE
            // =========================
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                value: appState.isDarkMode,
                onChanged: (_) => appState.toggleTheme(),
                title: Text(t.darkMode),
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// SETTING CARD
// =====================================================

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget child;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          child,
        ],
      ),
    );
  }
}