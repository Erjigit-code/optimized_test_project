// main_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:my_transport_budget_95t/cubit/expense_cubit.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/main/expense_card.dart';
import 'package:my_transport_budget_95t/main/statistics.dart';
import 'package:my_transport_budget_95t/models/expense.dart';
import 'package:my_transport_budget_95t/models/expense_category.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _amountController = TextEditingController();

  // Определение категорий расходов
  final List<ExpenseCategory> _expenseCategories = [
    ExpenseCategory(
        title: 'Taxi & Carsharing', iconPath: 'assets/images/taxi.png'),
    ExpenseCategory(title: 'Mass transit', iconPath: 'assets/images/mass.png'),
    ExpenseCategory(
        title: 'Intercity transport', iconPath: 'assets/images/Intercity.png'),
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    context.read<ExpenseCubit>().updateSaveButtonState(
          _amountController.text,
          _selectedCategory,
        );
  }

  void _showAddExpenseModal(BuildContext context, DateTime selectedDate) {
    _amountController.clear();
    _selectedCategory = null;
    context.read<ExpenseCubit>().updateSaveButtonState('', null);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: const Color(0xff121213),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                    thickness: 4,
                    indent: 154,
                    endIndent: 153,
                    color: Color(0x33FFFFFF)),
                SizedBox(height: 16.h),
                Text(
                  'Add Spend per Trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                // Выбор категории
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  buildWhen: (previous, current) =>
                      previous.isSaveButtonEnabled !=
                      current.isSaveButtonEnabled,
                  builder: (context, state) {
                    return DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: const Text(
                        'Select Category',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                      ),
                      dropdownColor: const Color(0xff1A1A21),
                      items: _expenseCategories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.title,
                          child: Row(
                            children: [
                              Image.asset(
                                category.iconPath,
                                width: 24.w,
                                height: 24.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  category.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedCategory = value;
                        context.read<ExpenseCubit>().updateSaveButtonState(
                              _amountController.text,
                              value,
                            );
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff010008),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r),
                          borderSide:
                              const BorderSide(color: Color(0x33FFFFFF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Поле ввода суммы
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter spend per trip, \$',
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                    filled: true,
                    fillColor: const Color(0xff010008),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  buildWhen: (previous, current) =>
                      previous.isSaveButtonEnabled !=
                      current.isSaveButtonEnabled,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isSaveButtonEnabled
                          ? () => _saveExpense(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isSaveButtonEnabled
                            ? const Color(0xff000DFF)
                            : const Color(0xff1A1A21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        fixedSize: Size(double.infinity, 56.h),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: state.isSaveButtonEnabled
                              ? Colors.white
                              : const Color.fromRGBO(255, 255, 255, 0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveExpense(BuildContext context) {
    final enteredAmount = double.parse(_amountController.text.trim());
    final selectedDate = context.read<ExpenseCubit>().state.selectedDate;
    final category = _selectedCategory;

    // Проверка существования расхода для данной даты и категории
    final existingExpense = context
        .read<ExpenseCubit>()
        .state
        .expenses
        .firstWhereOrNull((expense) =>
            expense.date.year == selectedDate.year &&
            expense.date.month == selectedDate.month &&
            expense.date.day == selectedDate.day &&
            expense.category == category);

    if (existingExpense != null) {
      // Показ сообщения об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Expense for this day and category already exists.')),
      );
      return;
    }

    final newExpense = Expense(
      date: selectedDate,
      amount: enteredAmount,
      category: category ?? 'Uncategorized',
    );

    context.read<ExpenseCubit>().addExpense(newExpense);

    Navigator.pop(context);
  }

  // Функция для расчёта месячных расходов
  double _calculateMonthlyExpenses(
      List<Expense> expenses, DateTime selectedDate) {
    final filteredExpenses = expenses.where((expense) {
      return expense.date.year == selectedDate.year &&
          expense.date.month == selectedDate.month;
    }).toList();

    double total = 0.0;
    for (var expense in filteredExpenses) {
      total += expense.amount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      buildWhen: (previous, current) =>
          previous.expenses != current.expenses ||
          previous.selectedDate != current.selectedDate,
      builder: (context, state) {
        final monthlyExpenses =
            _calculateMonthlyExpenses(state.expenses, state.selectedDate);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            title: const Text(
              'Transport Expenses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track your expenses',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                // Навигация по месяцам
                Container(
                  width: double.infinity,
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A21),
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ExpenseCubit>().setMonth(-1);
                        },
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          DateFormat('MMMM').format(state.selectedDate),
                          style: const TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          context.read<ExpenseCubit>().setMonth(1);
                        },
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GraphScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 0.1),
                          child: SvgPicture.asset(
                            'assets/svg/Chart.svg',
                            width: 17.5.w,
                            height: 17.5.w,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Месячные расходы
                Container(
                  width: double.infinity,
                  height: 88.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff000DFF),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Monthly expenses',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\$${monthlyExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Список карточек категорий
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _expenseCategories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final category = _expenseCategories[index];
                      return ExpenseCard(
                        title: category.title,
                        iconPath: category.iconPath,
                        state: state,
                        onAddSpendPerTrip: () =>
                            _showAddExpenseModal(context, state.selectedDate),
                      );
                    },
                  ),
                ),
                SizedBox(height: 46.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
