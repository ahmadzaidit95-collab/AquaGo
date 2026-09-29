import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final t = AppLocalizations.of(context)!;
    final currentCode = appState.locale?.languageCode;

    final languages = [
      {'code': null, 'name': t.systemDefault, 'sub': t.useDeviceLanguage, 'flag': '🌐'},
      {'code': 'en', 'name': 'English', 'sub': 'English', 'flag': '🇺🇸'},
      {'code': 'ar', 'name': 'العربية', 'sub': 'Arabic', 'flag': '🇪🇬'},
      {'code': 'fr', 'name': 'Français', 'sub': 'French', 'flag': '🇫🇷'},
      {'code': 'es', 'name': 'Español', 'sub': 'Spanish', 'flag': '🇪🇸'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(t.language,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 26)),
            const SizedBox(height: 4),
            Text(t.chooseLanguage, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.trackLight.withOpacity(0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.useDeviceLanguage,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...languages.map((lang) {
              final code = lang['code'] as String?;
              final isSelected = code == currentCode;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: ListTile(
                  leading: Text(lang['flag'] as String, style: const TextStyle(fontSize: 22)),
                  title: Text(lang['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lang['sub'] as String),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.circle_outlined, color: AppColors.textSecondary),
                  onTap: () => appState.setLanguage(code),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
