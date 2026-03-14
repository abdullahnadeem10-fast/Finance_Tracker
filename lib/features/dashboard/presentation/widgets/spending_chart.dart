import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../transactions/domain/transaction_model.dart';

class SpendingChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const SpendingChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No Data', style: TextStyle(color: Colors.white70)));
    }

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final Map<DateTime, double> dailySpending = {};
    for (var tx in transactions) {
      if (tx.type == 'expense') {
        final date = DateTime(tx.date.year, tx.date.month, tx.date.day);
        if (date.isAfter(normalizedToday)) {
          continue;
        }
        dailySpending[date] = (dailySpending[date] ?? 0) + tx.amount;
      }
    }

    if (dailySpending.isEmpty) {
      return const Center(child: Text('No Data', style: TextStyle(color: Colors.white70)));
    }

    final sortedDates = dailySpending.keys.toList()..sort();
    final List<FlSpot> spots = [];
    for (int i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dailySpending[sortedDates[i]]!));
    }

    if (spots.isEmpty) {
      return const Center(child: Text('No Data', style: TextStyle(color: Colors.white70)));
    }

    final minX = 0.0;
    final maxX = spots.length == 1 ? 1.0 : (spots.length - 1).toDouble();

    final yValues = spots.map((spot) => spot.y).toList();
    final rawMinY = yValues.reduce(math.min);
    final rawMaxY = yValues.reduce(math.max);

    double minY = rawMinY;
    double maxY = rawMaxY;

    if (minY == maxY) {
      if (minY == 0) {
        minY = 0;
        maxY = 100;
      } else {
        final delta = (minY.abs() * 0.2).clamp(1.0, double.infinity);
        minY -= delta;
        maxY += delta;
      }
    }

    if (!minY.isFinite || !maxY.isFinite) {
      minY = 0;
      maxY = 100;
    }

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM d').format(sortedDates[value.toInt()]),
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 22,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFFFF5252)],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF00E676).withValues(alpha: 0.3),
                  const Color(0xFF00E676).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
