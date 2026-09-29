import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final t = AppLocalizations.of(context)!;

    if (appState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final last7 = appState.last7Days;
    final dailyGoal = appState.dailyGoal;
    final today = last7.last;

    final todayPercent =
        (today.totalMl / dailyGoal * 100).clamp(0, 999).round();

    final maxVal = last7
        .map((e) => e.totalMl)
        .fold<int>(
          dailyGoal,
          (a, b) => a > b ? a : b,
        );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          t.historyTitle,
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
                          t.trackIntake,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Mascot Image
                  SizedBox(
                    width: 100,
                    height: 90,
                    child: Image.asset(
                      'assets/images/AAA.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // TODAY CARD
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.today,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '${today.totalMl} ml',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            '${t.dailyGoal}: $dailyGoal ml',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: (today.totalMl / dailyGoal)
                                .clamp(0.0, 1.0),
                            strokeWidth: 8,
                            backgroundColor: AppColors.trackLight,
                            valueColor:
                                const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),

                          Text(
                            '$todayPercent%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // LAST 7 DAYS
              // =========================
              Text(
                t.last7Days,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SizedBox(
                  height: 160,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barWidth =
                          (constraints.maxWidth / last7.length) * 0.5;

                      return Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: last7.map((entry) {

                          final barHeight = maxVal == 0
                              ? 0.0
                              : (entry.totalMl / maxVal) * 120;

                          final now = DateTime.now();

                          final isToday =
                              entry.date.day == now.day &&
                              entry.date.month == now.month;

                          return Column(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [

                              Text(
                                '${entry.totalMl}',
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Container(
                                width: barWidth.clamp(
                                  14.0,
                                  26.0,
                                ),
                                height: barHeight.clamp(
                                  4,
                                  120,
                                ),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.primary
                                      : AppColors.primary
                                          .withOpacity(0.4),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                _weekdayLabel(entry.date),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color:
                                      AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // DAILY RECORDS
              // =========================
              Text(
                t.dailyRecords,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              ...last7.reversed.map((entry) {

                final percent =
                    (entry.totalMl / dailyGoal * 100)
                        .clamp(0, 999)
                        .round();

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [

                      SizedBox(
                        width: 70,
                        child: Text(
                          _dateLabel(entry.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.local_drink,
                        color: AppColors.primary,
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          '${entry.totalMl} ml',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _weekdayLabel(DateTime d) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return names[d.weekday - 1];
  }

  String _dateLabel(DateTime d) {
    return '${_weekdayLabel(d)} ${d.day}/${d.month}';
  }
}