import 'package:budget_app/models/transaction.dart';
import 'package:budget_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        var currentTransaction = recentTransactions[i];
        if (currentTransaction.date.day == weekDay.day &&
            currentTransaction.date.month == weekDay.month &&
            currentTransaction.date.year == weekDay.year) {
          totalSum += currentTransaction.amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(
        0.0, (previousValue, element) => previousValue + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  tx['day'],
                  tx['amount'],
                  maxSpending == 0
                      ? 0
                      : (tx['amount'] as double) / maxSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
