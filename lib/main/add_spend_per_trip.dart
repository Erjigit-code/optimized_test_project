// lib/main/custom_calendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendar({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildDaysOfWeek(),
        _buildCalendar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMM().format(currentDate),
            style: const TextStyle(
              color: Color(0xff000DFF),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xff000DFF),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    currentDate = DateTime(
                      currentDate.year,
                      currentDate.month - 1,
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xff000DFF),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    currentDate = DateTime(
                      currentDate.year,
                      currentDate.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    const List<String> daysOfWeek = [
      'SUN',
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT'
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: daysOfWeek
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF7D7D7D),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    int daysInMonth =
        DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    int firstWeekdayOfMonth =
        DateTime(currentDate.year, currentDate.month, 1).weekday % 7;
    List<Widget> dayWidgets = [];

    // Add empty cells before the first day of the month
    for (int i = 0; i < firstWeekdayOfMonth; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentDate.year, currentDate.month, day);
      bool isSelected = selectedDate.day == day &&
          selectedDate.month == currentDate.month &&
          selectedDate.year == currentDate.year;
      bool isToday = _isSameDate(date, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
            widget.onDateSelected(selectedDate);
          },
          child: _buildDayCell(
            day: day,
            isSelected: isSelected,
            isToday: isToday,
          ),
        ),
      );
    }

    // Add empty cells after the last day of the month to fill the grid
    int totalCells = (dayWidgets.length / 7).ceil() * 7;
    while (dayWidgets.length < totalCells) {
      dayWidgets.add(const SizedBox());
    }

    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 7,
        children: dayWidgets,
      ),
    );
  }

  Widget _buildDayCell({
    required int day,
    required bool isSelected,
    required bool isToday,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xff000DFF)
            : isToday
                ? const Color(0xffE0F7FF)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        day.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected
              ? Colors.white
              : isToday
                  ? const Color(0xff000DFF)
                  : const Color(0xff000DFF),
        ),
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
