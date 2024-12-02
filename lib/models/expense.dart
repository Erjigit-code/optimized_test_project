// lib/models/expense.dart

import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final DateTime date;
  final double amount;
  final String category;

  const Expense({
    required this.date,
    required this.amount,
    required this.category,
  });

  @override
  List<Object> get props => [date, amount, category];
}
