// lib/cubit/expense_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/models/category_data_model.dart';
import 'package:my_transport_budget_95t/models/expense.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseState.initial());

  /// Adds a new expense and updates the grouped data.
  void addExpense(Expense expense) {
    final updatedExpenses = List<Expense>.from(state.expenses)..add(expense);
    _updateGroupedData(updatedExpenses, state.selectedDate);
  }

  /// Sets the selected date and updates the grouped data.
  void setSelectedDate(DateTime date) {
    _updateGroupedData(state.expenses, date);
  }

  /// Sets the selected month by applying an offset and updates the grouped data.
  void setMonth(int monthOffset) {
    final newDate = DateTime(
      state.selectedDate.year,
      state.selectedDate.month + monthOffset,
      state.selectedDate.day,
    );
    _updateGroupedData(state.expenses, newDate);
  }

  /// Updates the save button state based on input validity.
  void updateSaveButtonState(String amount, String? category) {
    final isValid = amount.trim().isNotEmpty &&
        double.tryParse(amount.trim()) != null &&
        category != null;
    if (isValid != state.isSaveButtonEnabled) {
      emit(state.copyWith(isSaveButtonEnabled: isValid));
    }
  }

  /// Private method to compute grouped data and emit a new state.
  void _updateGroupedData(List<Expense> expenses, DateTime selectedDate) async {
    // If the dataset is large, consider using compute for heavy processing
    // final result = await compute(_processExpenses, {
    //   'expenses': expenses,
    //   'selectedDate': selectedDate,
    // });
    // emit(state.copyWith(
    //   expenses: expenses,
    //   selectedDate: selectedDate,
    //   categoryExpenses: result['categoryExpenses'],
    //   dailyExpenses: result['dailyExpenses'],
    //   categoryData: result['categoryData'],
    // ));

    // For simplicity, processing synchronously
    // Group expenses by category
    final Map<String, double> categoryExpenses = {};
    // Group expenses by day
    final Map<int, double> dailyExpenses = {};
    // Group expenses by category for ExpenseCard
    final Map<String, CategoryData> categoryData = {};

    for (var expense in expenses) {
      if (expense.date.year == selectedDate.year &&
          expense.date.month == selectedDate.month) {
        // Group by category
        categoryExpenses[expense.category] =
            (categoryExpenses[expense.category] ?? 0) + expense.amount;

        // Group by day
        int day = expense.date.day;
        dailyExpenses[day] = (dailyExpenses[day] ?? 0) + expense.amount;

        // Group for ExpenseCard
        categoryData[expense.category] ??= CategoryData(expenses: []);
        categoryData[expense.category]!.expenses.add(expense);
      }
    }

    emit(state.copyWith(
      expenses: expenses,
      selectedDate: selectedDate,
      categoryExpenses: categoryExpenses,
      dailyExpenses: dailyExpenses,
      categoryData: categoryData,
    ));
  }

  /// Optional: Load expenses from a data source (e.g., database, API)
  void loadExpenses(List<Expense> loadedExpenses) {
    _updateGroupedData(loadedExpenses, state.selectedDate);
  }

  /// Optional: Asynchronous processing using compute
  // static Map<String, dynamic> _processExpenses(Map<String, dynamic> params) {
  //   List<Expense> expenses = params['expenses'];
  //   DateTime selectedDate = params['selectedDate'];
  //
  //   // Similar grouping logic as above
  // }
}
