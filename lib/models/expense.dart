// lib/models/expense.dart

class Expense {
  final DateTime date;
  final double amount;
  final String category;

  Expense({
    required this.date,
    required this.amount,
    required this.category,
  });
}
