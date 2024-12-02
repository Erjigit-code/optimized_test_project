// lib/cubit/expense_state.dart

import 'package:equatable/equatable.dart';
import 'package:my_transport_budget_95t/models/category_data_model.dart';
import 'package:my_transport_budget_95t/models/expense.dart';

class ExpenseState extends Equatable {
  final DateTime selectedDate;
  final List<Expense> expenses;
  final bool isSaveButtonEnabled;
  final Map<String, double> categoryExpenses;
  final Map<int, double> dailyExpenses;
  final Map<String, CategoryData> categoryData; // Added for ExpenseCard

  const ExpenseState({
    required this.selectedDate,
    required this.expenses,
    this.isSaveButtonEnabled = false,
    required this.categoryExpenses,
    required this.dailyExpenses,
    required this.categoryData, // Initialize in constructor
  });

  factory ExpenseState.initial() {
    return ExpenseState(
      selectedDate: DateTime.now(),
      expenses: const [],
      categoryExpenses: {},
      dailyExpenses: {},
      categoryData: {}, // Initialize as empty
    );
  }

  ExpenseState copyWith({
    DateTime? selectedDate,
    List<Expense>? expenses,
    bool? isSaveButtonEnabled,
    Map<String, double>? categoryExpenses,
    Map<int, double>? dailyExpenses,
    Map<String, CategoryData>? categoryData, // Added for ExpenseCard
  }) {
    return ExpenseState(
      selectedDate: selectedDate ?? this.selectedDate,
      expenses: expenses ?? this.expenses,
      isSaveButtonEnabled: isSaveButtonEnabled ?? this.isSaveButtonEnabled,
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      categoryData: categoryData ?? this.categoryData, // Updated
    );
  }

  @override
  List<Object> get props => [
        selectedDate,
        expenses,
        isSaveButtonEnabled,
        categoryExpenses,
        dailyExpenses,
        categoryData, // Include in props
      ];
}
