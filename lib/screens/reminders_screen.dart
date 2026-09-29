import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../data/repositories/water_repository.dart';
import '../l10n/app_localizations.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final t = AppLocalizations.of(context)!;
    final s = appState.reminderSettings;

    void update(ReminderSettings newSettings) {
      appState.updateReminderSettings(newSettings);
    }

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
                        t.remindersTitle,
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
                        t.staySubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
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
            // WATER REMINDERS
            // =========================
            _Card(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: s.enabled,
                activeColor: AppColors.primary,
                onChanged: (v) => update(
                  _copy(
                    s,
                    enabled: v,
                  ),
                ),
                title: Text(
                  t.waterReminders,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(t.getNotified),
                secondary: const Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // REMINDER INTERVAL
            // =========================
            Text(
              t.reminderInterval,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              t.howOften,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 60, 120, 180].map((mins) {
                final selected = s.intervalMinutes == mins;

                final label = mins < 60
                    ? '$mins m'
                    : '${mins ~/ 60} h';

                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                  ),
                  onSelected: (_) {
                    update(
                      _copy(
                        s,
                        intervalMinutes: mins,
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // =========================
            // ACTIVE TIME
            // =========================
            Text(
              t.activeTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              t.setTimeRange,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _TimePickerTile(
                    icon: Icons.wb_sunny,
                    label: t.startTime,
                    hour: s.startHour,
                    minute: s.startMinute,
                    onPick: (h, m) {
                      update(
                        _copy(
                          s,
                          startHour: h,
                          startMinute: m,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _TimePickerTile(
                    icon: Icons.nightlight_round,
                    label: t.endTime,
                    hour: s.endHour,
                    minute: s.endMinute,
                    onPick: (h, m) {
                      update(
                        _copy(
                          s,
                          endHour: h,
                          endMinute: m,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // NOTIFICATION SETTINGS
            // =========================
            Text(
              t.notificationSettings,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _Card(
              child: Column(
                children: [
                  // Sound
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: s.soundEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      update(
                        _copy(
                          s,
                          soundEnabled: v,
                        ),
                      );
                    },
                    title: Text(t.sound),
                    subtitle: Text(t.playSoundDesc),
                    secondary: const Icon(
                      Icons.volume_up,
                      color: AppColors.primary,
                    ),
                  ),

                  const Divider(height: 1),

                  // Vibration
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: s.vibrationEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      update(
                        _copy(
                          s,
                          vibrationEnabled: v,
                        ),
                      );
                    },
                    title: Text(t.vibration),
                    subtitle: Text(t.vibrationDesc),
                    secondary: const Icon(
                      Icons.vibration,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // TEST REMINDER
            // =========================
            _Card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  t.testReminder,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(t.sendTestDesc),
                onTap: () => appState.sendTestReminder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // COPY REMINDER SETTINGS
  // =========================
  ReminderSettings _copy(
    ReminderSettings s, {
    bool? enabled,
    int? intervalMinutes,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return ReminderSettings(
      enabled: enabled ?? s.enabled,
      intervalMinutes:
          intervalMinutes ?? s.intervalMinutes,
      startHour: startHour ?? s.startHour,
      startMinute: startMinute ?? s.startMinute,
      endHour: endHour ?? s.endHour,
      endMinute: endMinute ?? s.endMinute,
      soundEnabled:
          soundEnabled ?? s.soundEnabled,
      vibrationEnabled:
          vibrationEnabled ?? s.vibrationEnabled,
    );
  }
}

// =====================================================
// CARD WIDGET
// =====================================================

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// =====================================================
// TIME PICKER TILE
// =====================================================

class _TimePickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int hour;
  final int minute;
  final void Function(int hour, int minute) onPick;

  const _TimePickerTile({
    required this.icon,
    required this.label,
    required this.hour,
    required this.minute,
    required this.onPick,
  });

  String _format(int h, int m) {
    final period = h >= 12 ? 'PM' : 'AM';

    final h12 = h % 12 == 0
        ? 12
        : h % 12;

    return '$h12:${m.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: hour,
            minute: minute,
          ),
        );

        if (picked != null) {
          onPick(
            picked.hour,
            picked.minute,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),

                const SizedBox(width: 6),

                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              _format(hour, minute),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}