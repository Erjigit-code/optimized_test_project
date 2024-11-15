// // lib/main/main_screen.dart

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:my_transport_budget_95t/cubit/expense_cubit.dart';
// import 'package:my_transport_budget_95t/cubit/expense_state.dart';
// import 'package:my_transport_budget_95t/main/add_spend_per_trip.dart';
// import 'package:my_transport_budget_95t/main/statistics.dart';
// import 'package:my_transport_budget_95t/models/expense.dart';
// import 'package:my_transport_budget_95t/models/expense_category.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   bool _isSaveButtonEnabled = false;

//   // Define your expense categories
//   final List<ExpenseCategory> _expenseCategories = [
//     ExpenseCategory(
//         title: 'Taxi & Carsharing', iconPath: 'assets/images/taxi.png'),
//     ExpenseCategory(title: 'Mass transit', iconPath: 'assets/images/mass.png'),
//     ExpenseCategory(
//         title: 'Intercity transport', iconPath: 'assets/images/Intercity.png'),
//   ];

//   String? _selectedCategory;

//   @override
//   void initState() {
//     super.initState();
//     _amountController.addListener(_validateInput);
//   }

//   @override
//   void dispose() {
//     _amountController.removeListener(_validateInput);
//     _amountController.dispose();
//     super.dispose();
//   }

//   void _validateInput() {
//     setState(() {
//       _isSaveButtonEnabled = _amountController.text.trim().isNotEmpty &&
//           double.tryParse(_amountController.text.trim()) != null &&
//           _selectedCategory != null;
//     });
//   }

//   void _openCustomCalendar(BuildContext context, DateTime selectedDate) {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final screenHeight = MediaQuery.of(context).size.height;
//         final screenWidth = MediaQuery.of(context).size.width;
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
//           backgroundColor: const Color(0xff1C1C1E),
//           insetPadding: const EdgeInsets.all(0),
//           contentPadding: const EdgeInsets.all(0),
//           content: SizedBox(
//             height: screenHeight * 0.5,
//             width: screenWidth * 0.9,
//             child: CustomCalendar(
//               onDateSelected: (DateTime date) {
//                 context.read<ExpenseCubit>().setSelectedDate(date);
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showAddExpenseModal(BuildContext context, DateTime selectedDate) {
//     _amountController.clear();
//     _selectedCategory = null;
//     setState(() {
//       _isSaveButtonEnabled = false;
//     });

//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       backgroundColor: const Color(0xff121213),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 16.w,
//             right: 16.w,
//             top: 16.h,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Divider(
//                   thickness: 4,
//                   indent: 154.w,
//                   endIndent: 153.w,
//                   color: Colors.white.withOpacity(0.2),
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Add Spend per Trip',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//                 // Category selection
//                 DropdownButtonFormField<String>(
//                   value: _selectedCategory,
//                   hint: Text(
//                     'Select Category',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   dropdownColor: const Color(0xff1A1A21),
//                   items: _expenseCategories.map((category) {
//                     return DropdownMenuItem<String>(
//                       value: category.title,
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             category.iconPath,
//                             width: 24.w,
//                             height: 24.w,
//                           ),
//                           SizedBox(width: 8.w),
//                           Text(
//                             category.title,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCategory = value;
//                       _validateInput();
//                     });
//                   },
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xff010008),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                       borderSide:
//                           BorderSide(color: Colors.white.withOpacity(0.2)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 // Amount input
//                 TextField(
//                   controller: _amountController,
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: 'Enter spend per trip, \$',
//                     hintStyle: TextStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     filled: true,
//                     fillColor: const Color(0xff010008),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                       borderSide:
//                           BorderSide(color: Colors.white.withOpacity(0.2)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//                 ElevatedButton(
//                   onPressed: _isSaveButtonEnabled
//                       ? () {
//                           _saveExpense(context);
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _isSaveButtonEnabled
//                         ? const Color(0xff000DFF)
//                         : const Color(0xff1A1A21),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40.r),
//                     ),
//                     fixedSize: Size(double.infinity, 56.h),
//                   ),
//                   child: Text(
//                     'SAVE',
//                     style: TextStyle(
//                       color: Colors.white
//                           .withOpacity(_isSaveButtonEnabled ? 1.0 : 0.6),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _saveExpense(BuildContext context) {
//     final enteredAmount = double.parse(_amountController.text.trim());
//     final selectedDate = context.read<ExpenseCubit>().state.selectedDate;
//     final category = _selectedCategory;

//     // Check if an expense already exists for this day and category
//     final existingExpense = context.read<ExpenseCubit>().state.expenses.firstWhere(
//           (expense) =>
//               expense.date.year == selectedDate.year &&
//               expense.date.month == selectedDate.month &&
//               expense.date.day == selectedDate.day &&
//               expense.category == category,
//           orElse: () => null,
//         );

//     if (existingExpense != null) {
//       // Show an error message or notify the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Expense for this day and category already exists.')),
//       );
//       return;
//     }

//     final newExpense = Expense(
//       date: selectedDate,
//       amount: enteredAmount,
//       category: category ?? 'Uncategorized',
//     );

//     context.read<ExpenseCubit>().addExpense(newExpense);

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ExpenseCubit, ExpenseState>(
//       builder: (context, state) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.black,
//             surfaceTintColor: Colors.black,
//             title: Text(
//               'Transport Expenses',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             centerTitle: false,
//           ),
//           body: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Track your expenses',
//                   style: TextStyle(
//                     color: const Color(0xffFFFFFF).withOpacity(0.6),
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   width: double.infinity,
//                   height: 80.h,
//                   padding: EdgeInsets.symmetric(horizontal: 8.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xff1A1A21),
//                     borderRadius: BorderRadius.circular(40.r),
//                     border: Border.all(
//                       width: 1,
//                       color: const Color(0xffFFFFFF).withOpacity(0.2),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           context.read<ExpenseCubit>().setMonth(-1);
//                         },
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundColor:
//                               const Color(0xffFFFFFF).withOpacity(0.1),
//                           child: Image.asset(
//                             'assets/images/Union1.png',
//                             width: 17.5.w,
//                             height: 17.5.w,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: Text(
//                           DateFormat('MMMM').format(state.selectedDate),
//                           style: TextStyle(
//                             color: const Color(0xffFFFFFF),
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       GestureDetector(
//                         onTap: () {
//                           context.read<ExpenseCubit>().setMonth(1);
//                         },
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundColor:
//                               const Color(0xffFFFFFF).withOpacity(0.1),
//                           child: Image.asset(
//                             'assets/images/Union.png',
//                             width: 17.5.w,
//                             height: 17.5.w,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const GraphScreen(),
//                             ),
//                           );
//                         },
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundColor:
//                               const Color(0xffFFFFFF).withOpacity(0.1),
//                           child: SvgPicture.asset(
//                             'assets/svg/Chart.svg',
//                             width: 17.5.w,
//                             height: 17.5.w,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   width: double.infinity,
//                   height: 88.h,
//                   decoration: BoxDecoration(
//                     color: const Color(0xff000DFF),
//                     borderRadius: BorderRadius.circular(40.r),
//                   ),
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Monthly expenses',
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xffFFFFFF).withOpacity(0.6),
//                         ),
//                       ),
//                       Text(
//                         '\$${_calculateMonthlyExpenses(state.expenses, state.selectedDate)}',
//                         style: TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xffFFFFFF),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Expanded(
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _expenseCategories.length,
//                     separatorBuilder: (context, index) => SizedBox(width: 12.w),
//                     itemBuilder: (context, index) {
//                       final category = _expenseCategories[index];
//                       return _buildExpenseCard(
//                         category.title,
//                         category.iconPath,
//                         context,
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 46.h)
//               ],
//             ),
//           ),

//         );
//       },

//       double _calculateMonthlyExpenses(
//           List<Expense> expenses, DateTime selectedDate) {
//         final filteredExpenses = expenses.where((expense) {
//           return expense.date.year == selectedDate.year &&
//               expense.date.month == selectedDate.month;
//         }).toList();

//         double total = 0.0;
//         for (var expense in filteredExpenses) {
//           total += expense.amount;
//         }

//         return total;
//       },

//       Widget _buildExpenseCard(
//           String title, String iconPath, BuildContext context) {
//         return Container(
//           width: 320.w,
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             color: const Color(0xff1A1A21),
//             borderRadius: BorderRadius.circular(40.r),
//             border: Border.all(
//               color: const Color(0xffFFFFFF).withOpacity(0.2),
//             ),
//           ),
//           child: BlocBuilder<ExpenseCubit, ExpenseState>(
//             builder: (context, state) {
//               final categoryExpenses = state.expenses.where((expense) {
//                 return expense.category == title &&
//                     expense.date.year == state.selectedDate.year &&
//                     expense.date.month == state.selectedDate.month;
//               }).toList();

//               double categoryTotal = categoryExpenses.fold(
//                   0.0, (previousValue, element) => previousValue + element.amount);

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         iconPath,
//                         width: 56.w,
//                         height: 56.w,
//                         color: Colors.white,
//                       ),
//                       SizedBox(width: 8.w),
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Monthly expenses',
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white.withOpacity(0.6),
//                             ),
//                           ),
//                           Text(
//                             '\$${categoryTotal.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 24.sp,
//                               fontWeight: FontWeight.w500,
//                               color: const Color(0xffFFFFFF),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Exceeding the limit',
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white.withOpacity(0.6),
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Container(
//                             width: 120.w,
//                             height: 34.h,
//                             padding: EdgeInsets.only(left: 8.w),
//                             decoration: BoxDecoration(
//                               color: const Color(0xff000DFF),
//                               borderRadius: BorderRadius.circular(40.r),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               'no limits', // Adjust based on your logic
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   // Bar Chart
//                   SizedBox(
//                     height: 100.h,
//                     child: categoryExpenses.isNotEmpty
//                         ? BarChart(
//                             BarChartData(
//                               maxY: _calculateMaxY(categoryExpenses),
//                               barGroups: _generateBarData(categoryExpenses),
//                               gridData: FlGridData(show: false),
//                               titlesData: FlTitlesData(
//                                 leftTitles: AxisTitles(
//                                   sideTitles: SideTitles(showTitles: false),
//                                 ),
//                                 bottomTitles: AxisTitles(
//                                   sideTitles: SideTitles(showTitles: false),
//                                 ),
//                               ),
//                               borderData: FlBorderData(show: false),
//                               barTouchData: BarTouchData(enabled: false),
//                             ),
//                           )
//                         : Center(
//                             child: Text(
//                               'No data',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.6),
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                           ),
//                   ),
//                   const Spacer(),
//                   ElevatedButton(
//                     onPressed: () => _showAddExpenseModal(
//                         context, context.read<ExpenseCubit>().state.selectedDate),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       side: BorderSide(color: Colors.white.withOpacity(0.2)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(1000.r),
//                       ),
//                       fixedSize: Size(double.infinity, 56.h),
//                     ),
//                     child: Text(
//                       'ADD SPEND PER TRIP',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       }

//       double _calculateMaxY(List<Expense> categoryExpenses) {
//         double maxY = categoryExpenses
//             .map((e) => e.amount)
//             .fold(0.0, (prev, amount) => amount > prev ? amount : prev);
//         return (maxY * 1.2).ceilToDouble(); // Add some padding
//       }

//       List<BarChartGroupData> _generateBarData(List<Expense> categoryExpenses) {
//         // Group expenses by day
//         Map<int, double> dayExpenses = {};
//         for (var expense in categoryExpenses) {
//           int day = expense.date.day;
//           dayExpenses[day] = (dayExpenses[day] ?? 0) + expense.amount;
//         }

//         // Sort the entries by day
//         var sortedEntries = dayExpenses.entries.toList()
//           ..sort((a, b) => a.key.compareTo(b.key));

//         return sortedEntries.map((entry) {
//           return BarChartGroupData(
//             x: entry.key,
//             barRods: [
//               BarChartRodData(
//                 toY: entry.value,
//                 color: const Color(0xff000DFF),
//                 width: 8.w,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           );
//         }).toList();
//       }
//     }
// }
// lib/main/main_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart'; // Added for firstWhereOrNull
import 'package:my_transport_budget_95t/cubit/expense_cubit.dart';
import 'package:my_transport_budget_95t/cubit/expense_state.dart';
import 'package:my_transport_budget_95t/main/add_spend_per_trip.dart';
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
  bool _isSaveButtonEnabled = false;

  // Define your expense categories
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
    _amountController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateInput);
    _amountController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isSaveButtonEnabled = _amountController.text.trim().isNotEmpty &&
          double.tryParse(_amountController.text.trim()) != null &&
          _selectedCategory != null;
    });
  }

  void _openCustomCalendar(BuildContext context, DateTime selectedDate) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
          backgroundColor: const Color(0xff1C1C1E),
          insetPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            height: screenHeight * 0.5,
            width: screenWidth * 0.9,
            child: CustomCalendar(
              onDateSelected: (DateTime date) {
                context.read<ExpenseCubit>().setSelectedDate(date);
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddExpenseModal(BuildContext context, DateTime selectedDate) {
    _amountController.clear();
    _selectedCategory = null;
    setState(() {
      _isSaveButtonEnabled = false;
    });

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
                Divider(
                  thickness: 4,
                  indent: 154.w,
                  endIndent: 153.w,
                  color: Colors.white.withOpacity(0.2),
                ),
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
                // Category selection
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            category.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _validateInput();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff010008),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Amount input
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter spend per trip, \$',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: const Color(0xff010008),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          _saveExpense(context);
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaveButtonEnabled
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
                      color: Colors.white
                          .withOpacity(_isSaveButtonEnabled ? 1.0 : 0.6),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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

    // Check if an expense already exists for this day and category
    final existingExpense =
        context.read<ExpenseCubit>().state.expenses.firstWhereOrNull(
              (expense) =>
                  expense.date.year == selectedDate.year &&
                  expense.date.month == selectedDate.month &&
                  expense.date.day == selectedDate.day &&
                  expense.category == category,
            );

    if (existingExpense != null) {
      // Show an error message or notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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

  // Helper function to calculate monthly expenses
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

  // Helper function to build expense cards
  Widget _buildExpenseCard(
      String title, String iconPath, BuildContext context) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A21),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(
          color: const Color(0xffFFFFFF).withOpacity(0.2),
        ),
      ),
      child: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          final categoryExpenses = state.expenses.where((expense) {
            return expense.category == title &&
                expense.date.year == state.selectedDate.year &&
                expense.date.month == state.selectedDate.month;
          }).toList();

          double categoryTotal = categoryExpenses.fold(
              0.0, (previousValue, element) => previousValue + element.amount);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 56.w,
                    height: 56.w,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Monthly expenses
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly expenses',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        '\$${categoryTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ],
                  ),
                  // Exceeding the limit
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exceeding the limit',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
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
                        child: Text(
                          'No limits', // Adjust based on your logic
                          style: TextStyle(
                            fontSize: 12.sp,
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
              // Bar Chart
              SizedBox(
                  height: 100.h,
                  child: BarChart(
                    BarChartData(
                      maxY: _calculateMaxY(categoryExpenses),
                      barGroups: _generateBarData(categoryExpenses),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
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
                  )),
              Spacer(),
              ElevatedButton(
                onPressed: () => _showAddExpenseModal(
                    context, context.read<ExpenseCubit>().state.selectedDate),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  fixedSize: Size(double.infinity, 56.h),
                ),
                child: Text(
                  'ADD SPEND PER TRIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper function to calculate the maximum Y value for the bar chart
  double _calculateMaxY(List<Expense> categoryExpenses) {
    double maxY = categoryExpenses
        .map((e) => e.amount)
        .fold(0.0, (prev, amount) => amount > prev ? amount : prev);
    return (maxY * 1.2).ceilToDouble(); // Add some padding
  }

  // Helper function to generate bar chart data
  List<BarChartGroupData> _generateBarData(List<Expense> categoryExpenses) {
    // Group expenses by day
    Map<int, double> dayExpenses = {};
    for (var expense in categoryExpenses) {
      int day = expense.date.day;
      dayExpenses[day] = (dayExpenses[day] ?? 0) + expense.amount;
    }

    // Sort the entries by day
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            title: Text(
              'Transport Expenses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
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
                Text(
                  'Track your expenses',
                  style: TextStyle(
                    color: const Color(0xffFFFFFF).withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A21),
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffFFFFFF).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ExpenseCubit>().setMonth(-1);
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              const Color(0xffFFFFFF).withOpacity(0.1),
                          child: Image.asset(
                            'assets/images/Union1.png',
                            width: 17.5.w,
                            height: 17.5.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          DateFormat('MMMM').format(state.selectedDate),
                          style: TextStyle(
                            color: const Color(0xffFFFFFF),
                            fontSize: 20.sp,
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
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              const Color(0xffFFFFFF).withOpacity(0.1),
                          child: Image.asset(
                            'assets/images/Union.png',
                            width: 17.5.w,
                            height: 17.5.w,
                          ),
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
                              const Color(0xffFFFFFF).withOpacity(0.1),
                          child: SvgPicture.asset(
                            'assets/svg/Chart.svg',
                            width: 17.5.w,
                            height: 17.5.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
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
                      Text(
                        'Monthly expenses',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFFFFF).withOpacity(0.6),
                        ),
                      ),
                      Text(
                        '\$${_calculateMonthlyExpenses(state.expenses, state.selectedDate).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _expenseCategories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final category = _expenseCategories[index];
                      return _buildExpenseCard(
                        category.title,
                        category.iconPath,
                        context,
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
