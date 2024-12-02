// expense_card.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final ExpenseState state;
  final VoidCallback onAddSpendPerTrip;

  const ExpenseCard({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.state,
    required this.onAddSpendPerTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryExpenses = state.expenses.where((expense) {
      return expense.category == title &&
          expense.date.year == state.selectedDate.year &&
          expense.date.month == state.selectedDate.month;
    }).toList();

    double categoryTotal = categoryExpenses.fold(
        0.0, (previousValue, element) => previousValue + element.amount);

    // Генерация данных для графика
    final barData = _generateBarData(categoryExpenses);
    final maxY = _calculateMaxY(categoryExpenses);

    return RepaintBoundary(
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A21),
          borderRadius: BorderRadius.circular(40.r),
          border: const Border.fromBorderSide(
              BorderSide(color: Color.fromRGBO(255, 255, 255, 0.2))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок карточки
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 56.w,
                  height: 56.w,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Информация о расходах
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Месячные расходы
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly expenses',
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
                    ),
                    Text(
                      '\$${categoryTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Превышение лимита
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exceeding the limit',
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 120.w,
                      height: 34.h,
                      padding: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff000DFF),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'No limits', // Здесь можно добавить логику отображения
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // График
            RepaintBoundary(
              child: SizedBox(
                height: 100.h,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barGroups: barData,
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: false),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Кнопка добавления расхода
            ElevatedButton(
              onPressed: onAddSpendPerTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Color(0x33FFFFFF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                fixedSize: Size(double.infinity, 56.h),
              ),
              child: const Text(
                'ADD SPEND PER TRIP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Функция для расчёта максимального Y значения в графике
  double _calculateMaxY(List<Expense> categoryExpenses) {
    if (categoryExpenses.isEmpty) return 10.0;
    double maxY =
        categoryExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return (maxY * 1.2).ceilToDouble(); // Добавление отступа
  }

  // Функция для генерации данных графика
  List<BarChartGroupData> _generateBarData(List<Expense> categoryExpenses) {
    if (categoryExpenses.isEmpty) return [];

    // Группировка расходов по дням
    Map<int, double> dayExpenses = {};
    for (var expense in categoryExpenses) {
      int day = expense.date.day;
      dayExpenses[day] = (dayExpenses[day] ?? 0) + expense.amount;
    }

    // Сортировка по дням
    var sortedEntries = dayExpenses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: const Color(0xff000DFF),
            width: 8.w,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
