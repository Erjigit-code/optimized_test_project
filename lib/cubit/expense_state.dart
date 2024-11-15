// lib/cubit/expense_state.dart

import 'package:equatable/equatable.dart';
import 'package:my_transport_budget_95t/models/expense.dart';

class ExpenseState extends Equatable {
  final List<Expense> expenses;
  final DateTime selectedDate;

  const ExpenseState({
    this.expenses = const [],
    required this.selectedDate,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    DateTime? selectedDate,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [expenses, selectedDate];
}
