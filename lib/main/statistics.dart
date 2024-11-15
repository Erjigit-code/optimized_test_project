// lib/main/statistics.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_transport_budget_95t/cubit/expense_cubit.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/models/expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Statistics',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Expanded(child: _buildChart1(state)),
                SizedBox(height: 16.h),
                Expanded(child: _buildChart2(state)),
                SizedBox(height: 16.h),
                Expanded(child: _buildChart3(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart1(ExpenseState state) {
    // Line Chart showing daily expenses
    Map<int, double> dailyExpenses = {};
    for (var expense in state.expenses) {
      if (expense.date.year == state.selectedDate.year &&
          expense.date.month == state.selectedDate.month) {
        int day = expense.date.day;
        dailyExpenses[day] = (dailyExpenses[day] ?? 0) + expense.amount;
      }
    }

    List<FlSpot> spots = dailyExpenses.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    // Sort the spots by day
    spots.sort((a, b) => a.x.compareTo(b.x));

    return Card(
      color: const Color(0xff1A1A21),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Daily Expenses',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: spots.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        minX: 1,
                        maxX: DateUtils.getDaysInMonth(state.selectedDate.year,
                                state.selectedDate.month)
                            .toDouble(),
                        minY: 0,
                        maxY: spots
                                .map((e) => e.y)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                        ],
                        gridData:
                            FlGridData(show: true, drawVerticalLine: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: (DateUtils.getDaysInMonth(
                                          state.selectedDate.year,
                                          state.selectedDate.month) /
                                      5)
                                  .ceilToDouble(),
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(value.toInt().toString()),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        // barTou: BarTouchData(enabled: false),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart2(ExpenseState state) {
    // Pie Chart showing expense distribution by category
    Map<String, double> categoryExpenses = {};
    for (var expense in state.expenses) {
      if (expense.date.year == state.selectedDate.year &&
          expense.date.month == state.selectedDate.month) {
        categoryExpenses[expense.category] =
            (categoryExpenses[expense.category] ?? 0) + expense.amount;
      }
    }

    List<PieChartSectionData> sections = categoryExpenses.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
        color: _getCategoryColor(entry.key),
        radius: 50.r,
        titleStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      color: const Color(0xff1A1A21),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Expense by Category',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: categoryExpenses.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 30.r,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart3(ExpenseState state) {
    // Bar Chart showing total expenses per category
    Map<String, double> categoryExpenses = {};
    for (var expense in state.expenses) {
      if (expense.date.year == state.selectedDate.year &&
          expense.date.month == state.selectedDate.month) {
        categoryExpenses[expense.category] =
            (categoryExpenses[expense.category] ?? 0) + expense.amount;
      }
    }

    List<BarChartGroupData> barData = [];
    int index = 0;
    categoryExpenses.forEach((category, amount) {
      barData.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: _getCategoryColor(category),
              width: 20.w,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
      index++;
    });

    return Card(
      color: const Color(0xff1A1A21),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: categoryExpenses.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: categoryExpenses.values.isNotEmpty
                            ? categoryExpenses.values
                                    .reduce((a, b) => a > b ? a : b) *
                                1.2
                            : 10,
                        barGroups: barData,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() < 0 ||
                                    value.toInt() >=
                                        categoryExpenses.keys.length) {
                                  return const SizedBox.shrink();
                                }
                                String category = categoryExpenses.keys
                                    .toList()[value.toInt()];
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(enabled: false),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Taxi & Carsharing':
        return Colors.blue;
      case 'Mass transit':
        return Colors.green;
      case 'Intercity transport':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
