// lib/cubit/expense_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/models/expense.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseState(selectedDate: DateTime.now()));

  void addExpense(Expense expense) {
    final updatedExpenses = List<Expense>.from(state.expenses)..add(expense);
    emit(state.copyWith(expenses: updatedExpenses));
  }

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setMonth(int offset) {
    final newDate = DateTime(
      state.selectedDate.year,
      state.selectedDate.month + offset,
      state.selectedDate.day,
    );
    emit(state.copyWith(selectedDate: newDate));
  }
}
