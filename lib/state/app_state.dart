import 'package:flutter/material.dart';
import '../data/repositories/water_repository.dart';
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  final WaterRepository _repo = WaterRepository();
  final NotificationService notificationService = NotificationService();

  int dailyGoal = 2000;
  int glassSize = 250;
  int todayTotal = 0;
  int todayCount = 0;
  List<WaterEntryDay> last7Days = [];
  bool isDarkMode = false;
  bool isLoading = true;

  /// null = يتبع لغة الجهاز تلقائياً (System Default)
  Locale? locale;

  ReminderSettings reminderSettings = ReminderSettings(
    enabled: true,
    intervalMinutes: 60,
    startHour: 8,
    startMinute: 0,
    endHour: 22,
    endMinute: 0,
    soundEnabled: true,
    vibrationEnabled: true,
  );

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> init() async {
    dailyGoal = await _repo.getDailyGoal();
    glassSize = await _repo.getGlassSize();
    isDarkMode = await _repo.getIsDarkMode();
    reminderSettings = await _repo.getReminderSettings();

    final langCode = await _repo.getLanguageCode();
    locale = langCode == null ? null : Locale(langCode);

    await _refreshEntries();

    await notificationService.init();
    await notificationService.scheduleReminders(reminderSettings);

    isLoading = false;
    notifyListeners();
  }

  Future<void> _refreshEntries() async {
    final now = DateTime.now();
    todayTotal = await _repo.getTotalForDate(now);
    todayCount = await _repo.getCountForDate(now);
    last7Days = await _repo.getLast7Days();
  }

  Future<void> addGlass() async {
    await _repo.addEntry(glassSize);
    await _refreshEntries();
    notifyListeners();
  }

  Future<void> updateDailyGoal(int ml) async {
    dailyGoal = ml;
    await _repo.setDailyGoal(ml);
    notifyListeners();
  }

  Future<void> updateGlassSize(int ml) async {
    glassSize = ml;
    await _repo.setGlassSize(ml);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    await _repo.setIsDarkMode(isDarkMode);
    notifyListeners();
  }

  /// code = null يرجّع اللغة لتتبع الجهاز تلقائياً
  Future<void> setLanguage(String? code) async {
    locale = code == null ? null : Locale(code);
    await _repo.setLanguageCode(code);
    notifyListeners();
  }

  Future<void> updateReminderSettings(ReminderSettings settings) async {
    reminderSettings = settings;
    await _repo.saveReminderSettings(settings);
    await notificationService.scheduleReminders(settings);
    notifyListeners();
  }

  Future<void> sendTestReminder() async {
    await notificationService.showTestNotification();
  }
}
