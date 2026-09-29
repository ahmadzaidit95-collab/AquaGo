import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WaterEntryDay {
  final DateTime date;
  final int totalMl;
  WaterEntryDay({required this.date, required this.totalMl});
}

class ReminderSettings {
  final bool enabled;
  final int intervalMinutes;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final bool soundEnabled;
  final bool vibrationEnabled;

  ReminderSettings({
    required this.enabled,
    required this.intervalMinutes,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });
}

class WaterRepository {
  static const _dailyGoalKey = 'daily_goal_ml';
  static const _glassSizeKey = 'glass_size_ml';
  static const _entriesKey = 'water_entries';
  static const _themeKey = 'is_dark_mode';
  static const _languageKey = 'language_code';

  static const _reminderEnabledKey = 'reminder_enabled';
  static const _reminderIntervalKey = 'reminder_interval_minutes';
  static const _reminderStartHourKey = 'reminder_start_hour';
  static const _reminderStartMinuteKey = 'reminder_start_minute';
  static const _reminderEndHourKey = 'reminder_end_hour';
  static const _reminderEndMinuteKey = 'reminder_end_minute';
  static const _reminderSoundKey = 'reminder_sound';
  static const _reminderVibrationKey = 'reminder_vibration';

  Future<int> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyGoalKey) ?? 2000;
  }

  Future<void> setDailyGoal(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, ml);
  }

  Future<int> getGlassSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_glassSizeKey) ?? 250;
  }

  Future<void> setGlassSize(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_glassSizeKey, ml);
  }

  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  /// null يعني "لغة الجهاز" (System Default)
  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  Future<void> setLanguageCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_languageKey);
    } else {
      await prefs.setString(_languageKey, code);
    }
  }

  Future<ReminderSettings> getReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSettings(
      enabled: prefs.getBool(_reminderEnabledKey) ?? true,
      intervalMinutes: prefs.getInt(_reminderIntervalKey) ?? 60,
      startHour: prefs.getInt(_reminderStartHourKey) ?? 8,
      startMinute: prefs.getInt(_reminderStartMinuteKey) ?? 0,
      endHour: prefs.getInt(_reminderEndHourKey) ?? 22,
      endMinute: prefs.getInt(_reminderEndMinuteKey) ?? 0,
      soundEnabled: prefs.getBool(_reminderSoundKey) ?? true,
      vibrationEnabled: prefs.getBool(_reminderVibrationKey) ?? true,
    );
  }

  Future<void> saveReminderSettings(ReminderSettings s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderEnabledKey, s.enabled);
    await prefs.setInt(_reminderIntervalKey, s.intervalMinutes);
    await prefs.setInt(_reminderStartHourKey, s.startHour);
    await prefs.setInt(_reminderStartMinuteKey, s.startMinute);
    await prefs.setInt(_reminderEndHourKey, s.endHour);
    await prefs.setInt(_reminderEndMinuteKey, s.endMinute);
    await prefs.setBool(_reminderSoundKey, s.soundEnabled);
    await prefs.setBool(_reminderVibrationKey, s.vibrationEnabled);
  }

  Future<Map<String, List<int>>> _getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_entriesKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, List<int>.from(v)));
  }

  Future<void> _saveAll(Map<String, List<int>> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_entriesKey, jsonEncode(entries));
  }

  Future<void> addEntry(int amountMl, {DateTime? date}) async {
    final entries = await _getAllEntries();
    final key = _dateKey(date ?? DateTime.now());
    entries.putIfAbsent(key, () => []);
    entries[key]!.add(amountMl);
    await _saveAll(entries);
  }

  Future<int> getTotalForDate(DateTime date) async {
    final entries = await _getAllEntries();
    final list = entries[_dateKey(date)] ?? [];
    return list.fold<int>(0, (sum, v) => sum + v);
  }

  Future<int> getCountForDate(DateTime date) async {
    final entries = await _getAllEntries();
    return (entries[_dateKey(date)] ?? []).length;
  }

  Future<List<WaterEntryDay>> getLast7Days() async {
    final entries = await _getAllEntries();
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final total = (entries[_dateKey(day)] ?? []).fold<int>(0, (s, v) => s + v);
      return WaterEntryDay(date: DateTime(day.year, day.month, day.day), totalMl: total);
    });
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
