import 'package:flutter_test/flutter_test.dart';

class WaterTrackerModel {
  final double dailyGoal;
  final double glassSize;
  double currentIntake;

  WaterTrackerModel({
    required this.dailyGoal,
    required this.glassSize,
    this.currentIntake = 0.0,
  });

  double get progressPercentage => (currentIntake / dailyGoal) * 100;
  int get todayGlassesCount => (currentIntake / glassSize).floor();

  void addGlass() {
    currentIntake += glassSize;
  }
}

class ReminderService {
  final DateTime startTime;
  final DateTime endTime;
  final int intervalMinutes;

  ReminderService({
    required this.startTime,
    required this.endTime,
    required this.intervalMinutes,
  });

  int calculateTotalReminders() {
    final difference = endTime.difference(startTime).inMinutes;
    if (difference <= 0 || intervalMinutes <= 0) return 0;
    return (difference / intervalMinutes).floor();
  }
}

void main() {
  group('اختبارات الشاشة الرئيسية والحسابات (Home & Settings Tests)', () {
    test('حساب نسبة الإنجاز وعدد الأكواب بناءً على بيانات الواجهة', () {
      final tracker = WaterTrackerModel(
        dailyGoal: 2000,
        glassSize: 250,
        currentIntake: 500,
      );

      expect(tracker.progressPercentage, 25.0);
      expect(tracker.todayGlassesCount, 2);
    });

    test('إضافة كوب جديد عبر زر Add a Glass يزيد الإجمالي وتتحدث النسبة', () {
      final tracker = WaterTrackerModel(
        dailyGoal: 2000,
        glassSize: 250,
        currentIntake: 500,
      );

      tracker.addGlass();

      expect(tracker.currentIntake, 750.0);
      expect(tracker.progressPercentage, 37.5);
      expect(tracker.todayGlassesCount, 3);
    });
  });

  group('اختبارات شاشة التذكيرات (Reminders Tests)', () {
    test('حساب عدد التذكيرات بين 8:00 AM و 10:00 PM بفاصل 30 دقيقة', () {
      final start = DateTime(2026, 9, 29, 8, 0);
      final end = DateTime(2026, 9, 29, 22, 0);
      
      final reminder = ReminderService(
        startTime: start,
        endTime: end,
        intervalMinutes: 30,
      );

      expect(reminder.calculateTotalReminders(), 28);
    });
  });
}
