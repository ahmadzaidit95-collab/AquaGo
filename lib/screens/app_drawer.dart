import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onSelect;

  const AppDrawer({super.key, required this.currentIndex, required this.onSelect});

  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.moazmakki.drinkwater';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final items = [
      (Icons.home, t.home),
      (Icons.bar_chart, t.history),
      (Icons.notifications, t.reminders),
      (Icons.settings, t.settings),
    ];

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Image.asset('assets/images/AAA.png', height: 56, fit: BoxFit.contain),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.appTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...List.generate(items.length, (i) {
              final selected = currentIndex == i;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.12) : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(items[i].$1, color: selected ? AppColors.primary : null),
                  title: Text(
                    items[i].$2,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected ? AppColors.primary : null,
                    ),
                  ),
                  onTap: () => onSelect(i),
                ),
              );
            }),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(t.shareApp),
              onTap: () {
                Navigator.pop(context);
                Share.share(t.shareText);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(t.rateApp),
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse(_playStoreUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.about),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: t.appTitle,
                  applicationVersion: '1.0.0',
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
